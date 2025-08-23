package model;

import entity.TutorEarning;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOTutorEarning extends DBConnect {

    private static final Logger LOGGER = Logger.getLogger(DAOTutorEarning.class.getName());

    // Lấy HourlyRate (Price) từ TutorID
    public double getPriceByTutorId(int tutorID) {
        String sql = "SELECT Price FROM Tutor WHERE TutorID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("Price");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting Price for TutorID: " + tutorID, e);
        }
        return 0.0;
    }

    // Thêm bản ghi vào TutorEarnings
    public void insertEarnings(TutorEarning earnings) {
        String sql = "INSERT INTO TutorEarnings (TutorID, BookingID, BookingDate, HourlyRate, TotalEarnings, " +
                     "SytemCommissionRate, EarningsAfterCommission) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, earnings.getTutorID());
            ps.setInt(2, earnings.getBookingID());
            ps.setDate(3, earnings.getBookingDate());
            ps.setDouble(4, earnings.getHourlyRate());
            ps.setDouble(5, earnings.getTotalEarnings());
            ps.setDouble(6, earnings.getSytemCommissionRate());
            ps.setDouble(7, earnings.getEarningsAfterCommission());
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Inserted earning for BookingID: {0}, TutorID: {1}", 
                          new Object[]{earnings.getBookingID(), earnings.getTutorID()});
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting earning for BookingID: " + earnings.getBookingID(), e);
        }
    }

    // Đồng bộ dữ liệu từ Booking sang TutorEarnings
    public void syncBookingToTutorEarnings(int tutorID) {
        String sql = "SELECT b.BookingID, b.TutorID, b.BookingDate, t.Price " +
                    "FROM Booking b " +
                    "JOIN Tutor t ON b.TutorID = t.TutorID " +
                    "WHERE b.Status = 'Completed' " +
                    "AND b.TutorID = ? " +
                    "AND NOT EXISTS (SELECT 1 FROM TutorEarnings te WHERE te.BookingID = b.BookingID)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int bookingID = rs.getInt("BookingID");
                    int fetchedTutorID = rs.getInt("TutorID");
                    java.sql.Date bookingDate = rs.getDate("BookingDate");
                    double hourlyRate = rs.getDouble("Price");

                    // Giả định mỗi booking là 1 giờ
                    double totalEarnings = hourlyRate * 1; // Có thể điều chỉnh nếu thời lượng booking khác
                    double commissionRate = 0.2; // Hệ thống lấy 20%, tutor nhận 80%
                    double earningsAfterCommission = totalEarnings * (1 - commissionRate);

                    // Tạo bản ghi TutorEarning
                    TutorEarning earnings = new TutorEarning();
                    earnings.setTutorID(fetchedTutorID);
                    earnings.setBookingID(bookingID);
                    earnings.setBookingDate(bookingDate);
                    earnings.setHourlyRate(hourlyRate);
                    earnings.setTotalEarnings(totalEarnings);
                    earnings.setSytemCommissionRate(commissionRate);
                    earnings.setEarningsAfterCommission(earningsAfterCommission);

                    insertEarnings(earnings);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error syncing Booking to TutorEarnings for TutorID: " + tutorID, e);
        }
    }

    // Lấy danh sách thu nhập của tutor theo TutorID với tìm kiếm, lọc theo tháng, sorting, phân trang
    public List<TutorEarning> getEarningsByTutorId(int tutorID, String search, String searchField, String month, String sortBy, String sortOrder, int page, int pageSize) {
        List<TutorEarning> earnings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT te.*, b.BookingDate " +
                    "FROM TutorEarnings te " +
                    "JOIN Booking b ON te.BookingID = b.BookingID " +
                    "WHERE te.TutorID = ? ");
        List<Object> params = new ArrayList<>();

        // Thêm điều kiện lọc theo tháng
        if (month != null && !month.isEmpty()) {
            sql.append("AND MONTH(b.BookingDate) = ? ");
            params.add(Integer.parseInt(month));
        }

        // Thêm điều kiện tìm kiếm
        if (search != null && !search.isEmpty()) {
            switch (searchField) {
                case "BookingDate":
                    SimpleDateFormat inputFormat = new SimpleDateFormat("dd/MM/yyyy");
                    SimpleDateFormat sqlFormat = new SimpleDateFormat("yyyy-MM-dd");
                    try {
                        java.util.Date date = inputFormat.parse(search);
                        String sqlDate = sqlFormat.format(date);
                        sql.append("AND CAST(b.BookingDate AS DATE) = ? ");
                        params.add(sqlDate);
                    } catch (Exception e) {
                        LOGGER.log(Level.WARNING, "Invalid date format for search: " + search);
                    }
                    break;
                case "BookingID":
                default:
                    sql.append("AND CAST(te.BookingID AS VARCHAR) LIKE ? ");
                    params.add("%" + search + "%");
                    break;
            }
        }

        sql.append("ORDER BY ").append(sortBy != null ? sortBy : "b.BookingDate").append(" ").append(sortOrder != null ? sortOrder : "ASC")
                  .append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, tutorID);
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex++, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TutorEarning earning = new TutorEarning();
                    earning.setId(rs.getInt("ID"));
                    earning.setTutorID(rs.getInt("TutorID"));
                    earning.setBookingID(rs.getInt("BookingID"));
                    earning.setBookingDate(rs.getDate("BookingDate"));
                    earning.setHourlyRate(rs.getDouble("HourlyRate"));
                    earning.setTotalEarnings(rs.getDouble("TotalEarnings"));
                    earning.setSytemCommissionRate(rs.getDouble("SytemCommissionRate"));
                    earning.setEarningsAfterCommission(rs.getDouble("EarningsAfterCommission"));
                    earnings.add(earning);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting earnings for TutorID: " + tutorID, e);
        }
        return earnings;
    }

    // Tính tổng số bản ghi
    public int getTotalRecords(int tutorID, String search, String searchField, String month) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) " +
                    "FROM TutorEarnings te " +
                    "JOIN Booking b ON te.BookingID = b.BookingID " +
                    "WHERE te.TutorID = ? ");
        List<Object> params = new ArrayList<>();

        if (month != null && !month.isEmpty()) {
            sql.append("AND MONTH(b.BookingDate) = ? ");
            params.add(Integer.parseInt(month));
        }

        if (search != null && !search.isEmpty()) {
            switch (searchField) {
                case "BookingDate":
                    SimpleDateFormat inputFormat = new SimpleDateFormat("dd/MM/yyyy");
                    SimpleDateFormat sqlFormat = new SimpleDateFormat("yyyy-MM-dd");
                    try {
                        java.util.Date date = inputFormat.parse(search);
                        String sqlDate = sqlFormat.format(date);
                        sql.append("AND CAST(b.BookingDate AS DATE) = ? ");
                        params.add(sqlDate);
                    } catch (Exception e) {
                        LOGGER.log(Level.WARNING, "Invalid date format for search: " + search);
                    }
                    break;
                case "BookingID":
                default:
                    sql.append("AND CAST(te.BookingID AS VARCHAR) LIKE ? ");
                    params.add("%" + search + "%");
                    break;
            }
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, tutorID);
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total records for TutorID: " + tutorID, e);
        }
        return 0;
    }

    // Tính tổng EarningsAfterCommission
    public double getTotalEarningsAfterCommission(int tutorID, String search, String searchField, String month) {
        StringBuilder sql = new StringBuilder("SELECT SUM(EarningsAfterCommission) " +
                    "FROM TutorEarnings te " +
                    "JOIN Booking b ON te.BookingID = b.BookingID " +
                    "WHERE te.TutorID = ? ");
        List<Object> params = new ArrayList<>();

        if (month != null && !month.isEmpty()) {
            sql.append("AND MONTH(b.BookingDate) = ? ");
            params.add(Integer.parseInt(month));
        }

        if (search != null && !search.isEmpty()) {
            switch (searchField) {
                case "BookingDate":
                    SimpleDateFormat inputFormat = new SimpleDateFormat("dd/MM/yyyy");
                    SimpleDateFormat sqlFormat = new SimpleDateFormat("yyyy-MM-dd");
                    try {
                        java.util.Date date = inputFormat.parse(search);
                        String sqlDate = sqlFormat.format(date);
                        sql.append("AND CAST(b.BookingDate AS DATE) = ? ");
                        params.add(sqlDate);
                    } catch (Exception e) {
                        LOGGER.log(Level.WARNING, "Invalid date format for search: " + search);
                    }
                    break;
                case "BookingID":
                default:
                    sql.append("AND CAST(te.BookingID AS VARCHAR) LIKE ? ");
                    params.add("%" + search + "%");
                    break;
            }
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, tutorID);
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total earnings for TutorID: " + tutorID, e);
        }
        return 0.0;
    }

    // Tính tổng EarningsAfterCommission theo tháng
    public double getTotalEarningsAfterCommissionByMonth(int tutorID, String month) {
        String sql = "SELECT SUM(EarningsAfterCommission) " +
                    "FROM TutorEarnings te " +
                    "JOIN Booking b ON te.BookingID = b.BookingID " +
                    "WHERE te.TutorID = ? " +
                    "AND MONTH(b.BookingDate) = ? " +
                    "AND NOT EXISTS (SELECT 1 FROM MonthlyWithdrawalRequest mwr WHERE mwr.TutorID = te.TutorID AND mwr.Month = FORMAT(b.BookingDate, 'yyyy-MM'))";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            ps.setInt(2, Integer.parseInt(month));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total earnings for TutorID: " + tutorID + ", Month: " + month, e);
        }
        return 0.0;
    }

    // Lấy danh sách các tháng có thu nhập chưa rút hoặc bị Rejected, loại bỏ tháng đã Paid
    public Map<String, Double> getEarningMonthsWithTotalByTutorId(int tutorID) {
        Map<String, Double> monthEarnings = new HashMap<>();
        
        LocalDate currentDate = LocalDate.now();
        String currentMonth = String.format("%d-%02d", currentDate.getYear(), currentDate.getMonthValue());

        String sql = "SELECT FORMAT(b.BookingDate, 'yyyy-MM') AS Month, SUM(te.EarningsAfterCommission) AS TotalEarnings " +
                    "FROM TutorEarnings te " +
                    "JOIN Booking b ON te.BookingID = b.BookingID " +
                    "WHERE te.TutorID = ? " +
                    "AND FORMAT(b.BookingDate, 'yyyy-MM') < ? " + // Chỉ lấy các tháng trước tháng hiện tại
                    "AND NOT EXISTS (SELECT 1 FROM MonthlyWithdrawalRequest mwr " +
                    "                WHERE mwr.TutorID = te.TutorID " +
                    "                AND mwr.Month = FORMAT(b.BookingDate, 'yyyy-MM') " +
                    "                AND mwr.WithdrawStatus = 'Paid') " + // Loại bỏ tháng đã Paid
                    "GROUP BY FORMAT(b.BookingDate, 'yyyy-MM') " +
                    "ORDER BY Month DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            ps.setString(2, currentMonth);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String month = rs.getString("Month");
                    double totalEarnings = rs.getDouble("TotalEarnings");
                    monthEarnings.put(month, totalEarnings);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting earning months with total for TutorID: " + tutorID, e);
        }
        return monthEarnings;
    }

 // Tính tổng thu của hệ thống
    public double getSystemTotalRevenue() {
        String sql = "SELECT SUM(te.TotalEarnings) AS SystemRevenue " +
                    "FROM TutorEarnings te " +
                    "JOIN Booking b ON te.BookingID = b.BookingID " +
                    "WHERE b.Status = 'Completed'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("SystemRevenue");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating system total revenue", e);
        }
        return 0.0;
    }

    // Tính tổng tiền trả cho gia sư
    public double getSystemTutorPayments() {
        String sql = "SELECT SUM(te.EarningsAfterCommission) AS TutorPayments " +
                    "FROM TutorEarnings te " +
                    "JOIN Booking b ON te.BookingID = b.BookingID " +
                    "WHERE b.Status = 'Completed'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("TutorPayments");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating system tutor payments", e);
        }
        return 0.0;
    }

    // Tính tổng tiền lãi của hệ thống
    public double getSystemProfit() {
        String sql = "SELECT SUM(te.TotalEarnings - te.EarningsAfterCommission) AS SystemProfit " +
                    "FROM TutorEarnings te " +
                    "JOIN Booking b ON te.BookingID = b.BookingID " +
                    "WHERE b.Status = 'Completed'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("SystemProfit");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating system profit", e);
        }
        return 0.0;
    }

    // Lấy chi tiết doanh thu theo tháng với tìm kiếm và sắp xếp
    public Map<String, Map<String, Double>> getMonthlyRevenueDetails(String searchField, String search, String sortBy, String sortOrder) {
        Map<String, Map<String, Double>> monthlyDetails = new HashMap<>();
        String sql = "SELECT FORMAT(b.BookingDate, 'yyyy-MM') AS Month, " +
                    "SUM(te.TotalEarnings) AS TotalRevenue, " +
                    "SUM(te.EarningsAfterCommission) AS TutorPayments, " +
                    "SUM(te.TotalEarnings - te.EarningsAfterCommission) AS Profit " +
                    "FROM TutorEarnings te " +
                    "JOIN Booking b ON te.BookingID = b.BookingID " +
                    "WHERE b.Status = 'Completed' ";

        // Tìm kiếm
        if (search != null && !search.trim().isEmpty() && searchField != null) {
            if (searchField.equals("Month")) {
                // Search theo tháng (VD: "3" hoặc "03"), năm (VD: "2024"), hoặc định dạng "2025-01", "2025/01"
                if (search.matches("\\d{1,2}")) { // Tháng: 1-12
                    int month = Integer.parseInt(search);
                    if (month >= 1 && month <= 12) {
                        sql += "AND MONTH(b.BookingDate) = ? ";
                    }
                } else if (search.matches("\\d{4}")) { // Năm: 2024
                    sql += "AND YEAR(b.BookingDate) = ? ";
                } else if (search.matches("\\d{4}-\\d{2}|\\d{4}/\\d{2}")) { // Định dạng: 2025-01 hoặc 2025/01
                    String normalizedSearch = search.replace("/", "-"); // Chuyển 2025/01 thành 2025-01
                    sql += "AND FORMAT(b.BookingDate, 'yyyy-MM') = ? ";
                }
            } else {
                sql += "GROUP BY FORMAT(b.BookingDate, 'yyyy-MM') HAVING ";
                if (searchField.equals("TotalRevenue")) {
                    sql += "SUM(te.TotalEarnings) >= ? ";
                } else if (searchField.equals("TutorPayments")) {
                    sql += "SUM(te.EarningsAfterCommission) >= ? ";
                } else if (searchField.equals("Profit")) {
                    sql += "SUM(te.TotalEarnings - te.EarningsAfterCommission) >= ? ";
                }
            }
        }

        // Đảm bảo GROUP BY luôn có nếu không có HAVING
        if (!sql.contains("HAVING")) {
            sql += "GROUP BY FORMAT(b.BookingDate, 'yyyy-MM') ";
        }

        // Sắp xếp
        if (sortBy != null && !sortBy.isEmpty()) {
            if (sortBy.equals("Month")) {
                sql += "ORDER BY FORMAT(b.BookingDate, 'yyyy-MM') "; // Sắp xếp trực tiếp trên cột gốc
            } else if (sortBy.equals("TotalRevenue")) {
                sql += "ORDER BY SUM(te.TotalEarnings) "; // Sắp xếp trên giá trị tổng hợp
            } else if (sortBy.equals("TutorPayments")) {
                sql += "ORDER BY SUM(te.EarningsAfterCommission) ";
            } else if (sortBy.equals("Profit")) {
                sql += "ORDER BY SUM(te.TotalEarnings - te.EarningsAfterCommission) ";
            }
            sql += (sortOrder != null && sortOrder.equalsIgnoreCase("desc")) ? "DESC" : "ASC";
        } else {
            sql += "ORDER BY FORMAT(b.BookingDate, 'yyyy-MM') DESC";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (search != null && !search.trim().isEmpty() && searchField != null) {
                if (searchField.equals("Month")) {
                    if (search.matches("\\d{1,2}")) {
                        ps.setInt(1, Integer.parseInt(search));
                    } else if (search.matches("\\d{4}")) {
                        ps.setInt(1, Integer.parseInt(search));
                    } else if (search.matches("\\d{4}-\\d{2}|\\d{4}/\\d{2}")) {
                        String normalizedSearch = search.replace("/", "-");
                        ps.setString(1, normalizedSearch);
                    }
                } else {
                    ps.setDouble(1, Double.parseDouble(search));
                }
            }
            LOGGER.log(Level.INFO, "Executing SQL: " + sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String month = rs.getString("Month");
                Map<String, Double> details = new HashMap<>();
                details.put("TotalRevenue", rs.getDouble("TotalRevenue"));
                details.put("TutorPayments", rs.getDouble("TutorPayments"));
                details.put("Profit", rs.getDouble("Profit"));
                monthlyDetails.put(month, details);
                LOGGER.log(Level.INFO, "Found data for Month: " + month);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getMonthlyRevenueDetails: " + sql, e);
        }
        return monthlyDetails;
    }
}