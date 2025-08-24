package model;

import entity.MonthlyWithdrawalRequest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

public class DAOMonthlyWithdrawalRequest extends DBConnect {

    private static final Logger LOGGER = Logger.getLogger(DAOMonthlyWithdrawalRequest.class.getName());
    // Biểu thức chính quy để kiểm tra định dạng "STK: [số tài khoản] - Ngân hàng [tên ngân hàng]"
    private static final Pattern BANK_INFO_PATTERN = Pattern.compile("STK:\\s*\\d+\\s*-\\s*Ngân hàng\\s+[A-Za-zÀ-ỹ\\s]+");

   // Kiểm tra xem tháng đã được rút thành công (Approved) hay chưa
public boolean hasWithdrawnForMonth(int tutorID, String month) {
    String sql = "SELECT COUNT(*) FROM MonthlyWithdrawalRequest WHERE TutorID = ? AND Month = ? AND WithdrawStatus = 'Approved'";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, tutorID);
        ps.setString(2, month);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error checking approved withdrawal for TutorID: " + tutorID + ", Month: " + month, e);
    }
    return false;
}
// Lấy tổng tiền đã rút của hệ thống
    public double getTotalWithdrawnAmount() {
        String sql = "SELECT SUM(Amount) AS TotalWithdrawn " +
                    "FROM MonthlyWithdrawalRequest " +
                    "WHERE WithdrawStatus = 'Paid'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("TotalWithdrawn");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total withdrawn amount", e);
        }
        return 0.0;
    }

    // Lấy chi tiết rút tiền theo tháng với tìm kiếm và sắp xếp
    public Map<String, Map<String, Double>> getMonthlyWithdrawalDetails(String searchField, String search, String sortBy, String sortOrder) {
        Map<String, Map<String, Double>> monthlyDetails = new HashMap<>();
        StringBuilder sql = new StringBuilder(
            "SELECT Month, SUM(Amount) AS WithdrawnAmount " +
            "FROM MonthlyWithdrawalRequest " +
            "WHERE WithdrawStatus = 'Paid' " +
            "GROUP BY Month " +
            "HAVING 1=1 "
        );

        List<Object> params = new ArrayList<>();

        // Xử lý tìm kiếm
        if (search != null && !search.trim().isEmpty() && searchField != null) {
            switch (searchField) {
                case "Month":
                    String normalizedSearch = search.trim().replaceAll("[/-]", "");
                    if (normalizedSearch.length() == 6) {
                        sql.append(" AND Month = ? ");
                        params.add(normalizedSearch); // Giả sử Month trong DB là yyyyMM
                    } else if (normalizedSearch.length() == 4) {
                        sql.append(" AND LEFT(Month, 4) = ? ");
                        params.add(normalizedSearch);
                    }
                    break;
                case "WithdrawnAmount":
                    sql.append(" AND SUM(Amount) >= ? ");
                    params.add(Double.parseDouble(search.trim()));
                    break;
            }
        }

        // Xử lý sắp xếp
        if (sortBy != null && !sortBy.isEmpty()) {
            switch (sortBy) {
                case "WithdrawnAmount":
                    sql.append(" ORDER BY WithdrawnAmount ");
                    break;
                case "Month":
                default:
                    sql.append(" ORDER BY Month ");
                    break;
            }
            sql.append((sortOrder != null && sortOrder.equalsIgnoreCase("desc")) ? "DESC" : "ASC");
        } else {
            sql.append(" ORDER BY Month DESC");
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String month = rs.getString("Month");
                    Map<String, Double> details = new HashMap<>();
                    details.put("WithdrawnAmount", rs.getDouble("WithdrawnAmount"));
                    monthlyDetails.put(month, details);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting monthly withdrawal details", e);
        }
        return monthlyDetails;
    }
    // Kiểm tra xem một tháng đã có yêu cầu với trạng thái Pending hay chưa
    public boolean hasPendingWithdrawalRequest(int tutorID, String month) {
        String sql = "SELECT COUNT(*) FROM MonthlyWithdrawalRequest WHERE TutorID = ? AND Month = ? AND WithdrawStatus = 'Pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            ps.setString(2, month);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking pending withdrawal request for TutorID: " + tutorID + ", Month: " + month, e);
        }
        return false;
    }

    // Thêm yêu cầu rút tiền vào MonthlyWithdrawalRequest
    public boolean createWithdrawalRequest(int tutorID, String month, double totalEarnings, String content) {
    // Kiểm tra dữ liệu đầu vào
    if (month == null || !month.matches("\\d{4}-\\d{2}")) {
        LOGGER.log(Level.WARNING, "Invalid month format for TutorID: {0}, Month: {1}", 
                  new Object[]{tutorID, month});
        return false;
    }
    if (totalEarnings <= 0) {
        LOGGER.log(Level.WARNING, "Total earnings must be positive for TutorID: {0}, Month: {1}", 
                  new Object[]{tutorID, month});
        return false;
    }
    if (content == null || content.trim().isEmpty()) {
        LOGGER.log(Level.WARNING, "Content cannot be empty for TutorID: {0}, Month: {1}", 
                  new Object[]{tutorID, month});
        return false;
    }
    if (!BANK_INFO_PATTERN.matcher(content).matches()) {
        LOGGER.log(Level.WARNING, "Invalid bank info format for TutorID: {0}, Month: {1}, Content: {2}", 
                  new Object[]{tutorID, month, content});
        return false;
    }

    // Kiểm tra xem tháng đã được rút thành công chưa
    if (hasWithdrawnForMonth(tutorID, month)) {
        LOGGER.log(Level.WARNING, "Month already withdrawn (Approved) for TutorID: {0}, Month: {1}", 
                  new Object[]{tutorID, month});
        return false;
    }

    // Kiểm tra xem tháng có yêu cầu đang chờ xử lý không
    if (hasPendingWithdrawalRequest(tutorID, month)) {
        LOGGER.log(Level.WARNING, "Pending withdrawal request exists for TutorID: {0}, Month: {1}", 
                  new Object[]{tutorID, month});
        return false;
    }

    String sql = "INSERT INTO MonthlyWithdrawalRequest (TutorID, Month, TotalEarningsAfterCommission, WithdrawStatus, Content, RequestDate) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, tutorID);
        ps.setString(2, month);
        ps.setDouble(3, totalEarnings);
        ps.setString(4, "Pending");
        ps.setString(5, content);
        ps.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
        int rowsAffected = ps.executeUpdate();
        if (rowsAffected > 0) {
            LOGGER.log(Level.INFO, "Created withdrawal request for TutorID: {0}, Month: {1}", 
                      new Object[]{tutorID, month});
            return true;
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error creating withdrawal request for TutorID: " + tutorID + ", Month: " + month, e);
    }
    return false;
}
    // Lấy tất cả yêu cầu rút tiền (không bao gồm tên tutor)
    public List<MonthlyWithdrawalRequest> getAllRequests() {
        List<MonthlyWithdrawalRequest> requests = new ArrayList<>();
        String sql = "SELECT * FROM MonthlyWithdrawalRequest";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MonthlyWithdrawalRequest request = new MonthlyWithdrawalRequest();
                    request.setRequestID(rs.getInt("RequestID"));
                    request.setTutorID(rs.getInt("TutorID"));
                    request.setMonth(rs.getString("Month"));
                    request.setTotalEarningsAfterCommission(rs.getDouble("TotalEarningsAfterCommission"));
                    request.setWithdrawStatus(rs.getString("WithdrawStatus"));
                    request.setContent(rs.getString("Content"));
                    request.setRequestDate(rs.getTimestamp("RequestDate"));
                    request.setAdminID(rs.getInt("AdminID"));
                    requests.add(request);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all withdrawal requests", e);
        }
        return requests;
    }

    // Lấy tất cả yêu cầu rút tiền với thông tin tên tutor, hỗ trợ tìm kiếm, sắp xếp và phân trang
    public List<MonthlyWithdrawalRequest> getAllRequestsWithTutorName(String searchField, String search, String sortBy, String sortOrder, int page, int pageSize) {
        List<MonthlyWithdrawalRequest> requests = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT mwr.*, u.FullName AS TutorFullName " +
            "FROM MonthlyWithdrawalRequest mwr " +
            "JOIN Tutor t ON mwr.TutorID = t.TutorID " +
            "JOIN CV cv ON t.CVID = cv.CVID " +
            "JOIN Users u ON cv.UserID = u.UserID WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        // Thêm điều kiện tìm kiếm
        if (search != null && !search.trim().isEmpty()) {
            if ("TutorName".equalsIgnoreCase(searchField)) {
                sql.append(" AND u.FullName LIKE ?");
                params.add("%" + search.trim() + "%");
            } else if ("WithdrawStatus".equalsIgnoreCase(searchField)) {
                sql.append(" AND mwr.WithdrawStatus LIKE ?");
                params.add("%" + search.trim() + "%");
            } else if ("RequestDate".equalsIgnoreCase(searchField)) {
                String searchValue = search.trim();
                if (searchValue.matches("\\d{1,2}")) { // Tìm theo ngày
                    sql.append(" AND DAY(mwr.RequestDate) = ?");
                    params.add(Integer.parseInt(searchValue));
                } else if (searchValue.matches("\\d{1,2}/\\d{4}")) { // Tìm theo tháng/năm
                    String[] parts = searchValue.split("/");
                    sql.append(" AND MONTH(mwr.RequestDate) = ? AND YEAR(mwr.RequestDate) = ?");
                    params.add(Integer.parseInt(parts[0]));
                    params.add(Integer.parseInt(parts[1]));
                } else if (searchValue.matches("\\d{4}")) { // Tìm theo năm
                    sql.append(" AND YEAR(mwr.RequestDate) = ?");
                    params.add(Integer.parseInt(searchValue));
                }
            }
        }

        // Thêm sắp xếp và phân trang
        sql.append(" ORDER BY mwr.").append(sortBy).append(" ").append(sortOrder)
                  .append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex++, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MonthlyWithdrawalRequest request = new MonthlyWithdrawalRequest();
                    request.setRequestID(rs.getInt("RequestID"));
                    request.setTutorID(rs.getInt("TutorID"));
                    request.setTutorName(rs.getString("TutorFullName"));
                    request.setMonth(rs.getString("Month"));
                    request.setTotalEarningsAfterCommission(rs.getDouble("TotalEarningsAfterCommission"));
                    request.setWithdrawStatus(rs.getString("WithdrawStatus"));
                    request.setContent(rs.getString("Content"));
                    request.setRequestDate(rs.getTimestamp("RequestDate"));
                    request.setAdminID(rs.getInt("AdminID"));
                    requests.add(request);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all withdrawal requests with tutor name", e);
        }
        return requests;
    }

    // Đếm tổng số yêu cầu để hỗ trợ phân trang
    public int getTotalRequestCount(String searchField, String search) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) " +
            "FROM MonthlyWithdrawalRequest mwr " +
            "JOIN Tutor t ON mwr.TutorID = t.TutorID " +
            "JOIN CV cv ON t.CVID = cv.CVID " +
            "JOIN Users u ON cv.UserID = u.UserID WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            if ("TutorName".equalsIgnoreCase(searchField)) {
                sql.append(" AND u.FullName LIKE ?");
                params.add("%" + search.trim() + "%");
            } else if ("WithdrawStatus".equalsIgnoreCase(searchField)) {
                sql.append(" AND mwr.WithdrawStatus LIKE ?");
                params.add("%" + search.trim() + "%");
            } else if ("RequestDate".equalsIgnoreCase(searchField)) {
                String searchValue = search.trim();
                if (searchValue.matches("\\d{1,2}")) {
                    sql.append(" AND DAY(mwr.RequestDate) = ?");
                    params.add(Integer.parseInt(searchValue));
                } else if (searchValue.matches("\\d{1,2}/\\d{4}")) {
                    String[] parts = searchValue.split("/");
                    sql.append(" AND MONTH(mwr.RequestDate) = ? AND YEAR(mwr.RequestDate) = ?");
                    params.add(Integer.parseInt(parts[0]));
                    params.add(Integer.parseInt(parts[1]));
                } else if (searchValue.matches("\\d{4}")) {
                    sql.append(" AND YEAR(mwr.RequestDate) = ?");
                    params.add(Integer.parseInt(searchValue));
                }
            }
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total request count", e);
        }
        return 0;
    }

    // Lấy thông tin yêu cầu rút tiền theo RequestID
    public MonthlyWithdrawalRequest getRequestById(int requestID) {
        String sql = "SELECT * FROM MonthlyWithdrawalRequest WHERE RequestID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MonthlyWithdrawalRequest request = new MonthlyWithdrawalRequest();
                    request.setRequestID(rs.getInt("RequestID"));
                    request.setTutorID(rs.getInt("TutorID"));
                    request.setMonth(rs.getString("Month"));
                    request.setTotalEarningsAfterCommission(rs.getDouble("TotalEarningsAfterCommission"));
                    request.setWithdrawStatus(rs.getString("WithdrawStatus"));
                    request.setContent(rs.getString("Content"));
                    request.setRequestDate(rs.getTimestamp("RequestDate"));
                    request.setAdminID(rs.getInt("AdminID"));
                    return request;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting withdrawal request by ID: " + requestID, e);
        }
        return null;
    }

    // Cập nhật trạng thái yêu cầu rút tiền và AdminID
    public boolean updateWithdrawalRequestStatus(int requestID, int adminID, String status) {
        String sql = "UPDATE MonthlyWithdrawalRequest SET WithdrawStatus = ?, AdminID = ? WHERE RequestID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, adminID);
            ps.setInt(3, requestID);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Updated withdrawal request status to {0} for RequestID: {1}", 
                          new Object[]{status, requestID});
                return true;
            }
            return false;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating withdrawal request status for RequestID: " + requestID, e);
            return false;
        }
    }

    // Cập nhật trạng thái của tất cả yêu cầu trong cùng tháng
    public void updateAllRequestsInMonth(int tutorID, String month, String status) {
        String sql = "UPDATE MonthlyWithdrawalRequest SET WithdrawStatus = ? " +
                    "WHERE TutorID = ? AND Month = ? AND WithdrawStatus = 'Pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, tutorID);
            ps.setString(3, month);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Updated {0} withdrawal requests to {1} for TutorID: {2}, Month: {3}", 
                          new Object[]{rowsAffected, status, tutorID, month});
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating withdrawal requests for TutorID: " + tutorID + ", Month: " + month, e);
        }
    }

    // Các phương thức khác (giữ nguyên để tương thích)
    public List<MonthlyWithdrawalRequest> getWithdrawalRequestsByTutorId(int tutorID, String searchField, String search, String sortBy, String sortOrder) {
        List<MonthlyWithdrawalRequest> requests = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM MonthlyWithdrawalRequest WHERE TutorID = ?");
        
        if (search != null && !search.trim().isEmpty()) {
            if ("WithdrawStatus".equalsIgnoreCase(searchField)) {
                sql.append(" AND WithdrawStatus LIKE ?");
            } else if ("RequestDate".equalsIgnoreCase(searchField)) {
                String searchValue = search.trim();
                if (searchValue.matches("\\d{1,2}")) {
                    sql.append(" AND DAY(RequestDate) = ?");
                } else if (searchValue.matches("\\d{1,2}/\\d{4}")) {
                    String[] parts = searchValue.split("/");
                    sql.append(" AND MONTH(RequestDate) = ? AND YEAR(RequestDate) = ?");
                } else if (searchValue.matches("\\d{4}")) {
                    sql.append(" AND YEAR(RequestDate) = ?");
                }
            }
        }

        sql.append(" ORDER BY ").append(sortBy).append(" ").append(sortOrder);

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, tutorID);
            if (search != null && !search.trim().isEmpty()) {
                if ("WithdrawStatus".equalsIgnoreCase(searchField)) {
                    ps.setString(paramIndex++, "%" + search.trim() + "%");
                } else if ("RequestDate".equalsIgnoreCase(searchField)) {
                    String searchValue = search.trim();
                    if (searchValue.matches("\\d{1,2}")) {
                        ps.setInt(paramIndex++, Integer.parseInt(searchValue));
                    } else if (searchValue.matches("\\d{1,2}/\\d{4}")) {
                        String[] parts = searchValue.split("/");
                        ps.setInt(paramIndex++, Integer.parseInt(parts[0]));
                        ps.setInt(paramIndex++, Integer.parseInt(parts[1]));
                    } else if (searchValue.matches("\\d{4}")) {
                        ps.setInt(paramIndex++, Integer.parseInt(searchValue));
                    }
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MonthlyWithdrawalRequest request = new MonthlyWithdrawalRequest();
                    request.setRequestID(rs.getInt("RequestID"));
                    request.setTutorID(rs.getInt("TutorID"));
                    request.setMonth(rs.getString("Month"));
                    request.setTotalEarningsAfterCommission(rs.getDouble("TotalEarningsAfterCommission"));
                    request.setWithdrawStatus(rs.getString("WithdrawStatus"));
                    request.setContent(rs.getString("Content"));
                    request.setRequestDate(rs.getTimestamp("RequestDate"));
                    request.setAdminID(rs.getInt("AdminID"));
                    requests.add(request);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting withdrawal requests for TutorID: " + tutorID, e);
        }
        return requests;
    }

    public List<MonthlyWithdrawalRequest> getWithdrawalRequestsByTutorId(int tutorID) {
        return getWithdrawalRequestsByTutorId(tutorID, "WithdrawStatus", "", "RequestDate", "DESC");
    }

    public List<MonthlyWithdrawalRequest> getWithdrawalRequestsByTutorId(int tutorID, String sortBy, String sortOrder) {
        return getWithdrawalRequestsByTutorId(tutorID, "WithdrawStatus", "", sortBy, sortOrder);
    }
}