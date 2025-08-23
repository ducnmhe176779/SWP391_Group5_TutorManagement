package model;

import entity.TutorRating;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOTutorRating extends DBConnect {

    // Thêm một đánh giá mới
    public int insertTutorRating(TutorRating rating) throws SQLException {
        int n = 0;
        String sql = "INSERT INTO [dbo].[TutorRating] (BookingID, StudentID, TutorID, Rating, Comment) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, rating.getBookingId());
            pre.setInt(2, rating.getStudentId());
            pre.setInt(3, rating.getTutorId());
            pre.setInt(4, rating.getRating());
            pre.setString(5, rating.getComment());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    // Lấy TutorRating theo ID
    public TutorRating getTutorRatingById(int ratingId) throws SQLException {
        TutorRating rating = null;
        String sql = "SELECT * FROM [dbo].[TutorRating] WHERE RatingID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, ratingId);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                rating = extractTutorRatingFromResultSet(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rating;
    }

    // Lấy danh sách tất cả TutorRating
    public List<TutorRating> getAllTutorRatings() throws SQLException {
        List<TutorRating> list = new ArrayList<>();
        String sql = "SELECT tr.RatingID, tr.BookingID, u.FullName, tr.TutorID, tr.Comment, tr.RatingDate, tr.StudentID, tr.Rating \n"
                + "                     FROM [dbo].[TutorRating] tr \n"
                + "                     JOIN dbo.Users u ON u.UserID = tr.StudentID \n"
                + "                     ORDER BY tr.RatingDate DESC";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                TutorRating rating = extractTutorRatingFromResultSet(rs);
                list.add(rating);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<TutorRating> getTutorRatings(String sql) throws SQLException {
        List<TutorRating> list = new ArrayList<>();
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                TutorRating rating = extractTutorRatingFromResultSet(rs);
                list.add(rating);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Lấy danh sách đánh giá theo TutorID
    public List<TutorRating> getRatingsByTutorId(int tutorId) throws SQLException {
        List<TutorRating> list = new ArrayList<>();
        String sql = "SELECT * FROM [dbo].[TutorRating] WHERE TutorID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, tutorId);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                TutorRating rating = extractTutorRatingFromResultSet(rs);
                list.add(rating);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public int getAvgRating(int tutorid) {
        int avg = 0;
        String sql = "SELECT sum(rating)/COUNT(rating)  FROM [dbo].[TutorRating] WHERE TutorID =" + tutorid;
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                avg = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return avg;
    }

    public int numberReview(int tutorid) {
        int count = 0;
        String sql = "SELECT COUNT(rating)  FROM [dbo].[TutorRating] WHERE TutorID =" + tutorid;
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }

    // Kiểm tra vai trò học sinh (RoleID = 2)
    public boolean isStudent(int userId) throws SQLException {
        String sql = "SELECT RoleID FROM [dbo].[Users] WHERE UserID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, userId);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                return rs.getInt("RoleID") == 2;
            }
            return false;
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Kiểm tra trạng thái và quyền của Booking
    public TutorRating checkBookingEligibility(int bookingId, int userId) throws SQLException {
        String sql = "SELECT StudentID, TutorID, Status FROM [dbo].[Booking] WHERE BookingID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, bookingId);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                int studentId = rs.getInt("StudentID");
                int tutorId = rs.getInt("TutorID");
                String status = rs.getString("Status");
                if ("Completed".equals(status) && studentId == userId) {
                    return new TutorRating(0, bookingId, studentId, tutorId, 0, null, null);
                }
            }
            return null;
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Kiểm tra xem Booking đã được đánh giá chưa
    public boolean isBookingRated(int bookingId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM [dbo].[TutorRating] WHERE BookingID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, bookingId);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Trích xuất TutorRating từ ResultSet
    private TutorRating extractTutorRatingFromResultSet(ResultSet rs) throws SQLException {
        int ratingId = rs.getInt("RatingID");
        int bookingId = rs.getInt("BookingID");
        String FullName = rs.getString("FullName");
        int tutorId = rs.getInt("TutorID");
        int rating = rs.getInt("Rating");
        String comment = rs.getString("Comment");
        Timestamp ratingDate = rs.getTimestamp("RatingDate");

        TutorRating tutorRating = new TutorRating(ratingId, bookingId, FullName, tutorId, rating, comment, ratingDate);

        // Get the username if it exists in the result set
        try {
            if (rs.getMetaData().getColumnCount() > 7) {
                tutorRating.setUsername(rs.getString("FullName"));
            }
        } catch (SQLException e) {
            // Handle the case where UserName column doesn't exist
        }

        return tutorRating;
    }

    public List<Object[]> getTutorsWithAverageRating(String order) throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT t.TutorID, u.FullName, ROUND(COALESCE(AVG(tr.Rating), 0), 1) as averageRating, COUNT(tr.Rating) as reviewCount "
                + "FROM dbo.Users u "
                + "JOIN dbo.CV cv ON cv.UserID = u.UserID "
                + "JOIN dbo.Tutor t ON t.CVID = cv.CVID "
                + "LEFT JOIN dbo.TutorRating tr ON tr.TutorID = t.TutorID "
                + "GROUP BY t.TutorID, u.FullName "
                + "ORDER BY averageRating " + ("DESC".equals(order) ? "DESC" : "ASC");

        try (PreparedStatement pre = conn.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                Object[] tutorData = new Object[4]; // Có 4 cột: TutorID, FullName, averageRating, reviewCount
                tutorData[0] = rs.getInt("TutorID");           // Mã gia sư
                tutorData[1] = rs.getString("FullName");       // Tên gia sư
                tutorData[2] = rs.getDouble("averageRating");  // Điểm trung bình (đã làm tròn)
                tutorData[3] = rs.getInt("reviewCount");       // Số lượng đánh giá
                list.add(tutorData);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, "Error fetching tutors with ratings", ex);
            throw ex;
        }
        return list;
    }

    public List<Object[]> searchTutorsByIdOrName(String keyword) throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT t.TutorID, u.FullName, ROUND(COALESCE(AVG(tr.Rating), 0), 1) as averageRating, COUNT(tr.Rating) as reviewCount "
                + "FROM dbo.Users u "
                + "JOIN dbo.CV cv ON cv.UserID = u.UserID "
                + "JOIN dbo.Tutor t ON t.CVID = cv.CVID "
                + "LEFT JOIN dbo.TutorRating tr ON tr.TutorID = t.TutorID "
                + "WHERE t.TutorID LIKE ? OR u.FullName LIKE ? "
                + "GROUP BY t.TutorID, u.FullName "
                + "ORDER BY averageRating DESC";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, "%" + keyword + "%");
            pre.setString(2, "%" + keyword + "%");
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Object[] tutorData = new Object[4];
                    tutorData[0] = rs.getInt("TutorID");
                    tutorData[1] = rs.getString("FullName");
                    tutorData[2] = rs.getDouble("averageRating");
                    tutorData[3] = rs.getInt("reviewCount");
                    list.add(tutorData);
                }
            }
        }
        return list;
    }

    // Tìm kiếm TutorRating theo RatingID, TutorID, RatingDate
    public List<TutorRating> searchTutorRatings(String ratingId, String tutorId, String ratingDate) throws SQLException {
        List<TutorRating> list = new ArrayList<>();

        // Start with a query that joins TutorRating with Users to get FullName
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT tr.RatingID, tr.BookingID, tr.StudentID, u.FullName, tr.TutorID, tr.Rating, tr.Comment, tr.RatingDate "
                + "FROM [dbo].[TutorRating] tr "
                + "JOIN dbo.Users u ON u.UserID = tr.StudentID "
                + "WHERE 1=1"
        );

        // List for parameters
        List<Object> params = new ArrayList<>();

        // Add conditions based on search parameters
        if (ratingId != null && !ratingId.trim().isEmpty()) {
            try {
                sqlBuilder.append(" AND tr.RatingID = ?");
                params.add(Integer.parseInt(ratingId));
            } catch (NumberFormatException e) {
                // Skip this condition if invalid number
                Logger.getLogger(DAOTutorRating.class.getName()).log(Level.WARNING, "Invalid RatingID format", e);
            }
        }

        if (tutorId != null && !tutorId.trim().isEmpty()) {
            try {
                sqlBuilder.append(" AND tr.TutorID = ?");
                params.add(Integer.parseInt(tutorId));
            } catch (NumberFormatException e) {
                // Skip this condition if invalid number
                Logger.getLogger(DAOTutorRating.class.getName()).log(Level.WARNING, "Invalid TutorID format", e);
            }
        }

        if (ratingDate != null && !ratingDate.trim().isEmpty()) {
            sqlBuilder.append(" AND CONVERT(date, tr.RatingDate) = ?");
            params.add(ratingDate);
        }

        // Add order by clause
        sqlBuilder.append(" ORDER BY tr.RatingDate DESC");

        String sql = sqlBuilder.toString();
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            // Set the parameters
            for (int i = 0; i < params.size(); i++) {
                pre.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    TutorRating rating = extractTutorRatingFromResultSet(rs);
                    list.add(rating);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, "Error searching tutor ratings", ex);
            throw ex;
        }

        return list;
    }

    // Test method trong main
    public static void main(String[] args) {
        DAOTutorRating dao = new DAOTutorRating();
        try {
            // Test với thứ tự giảm dần (DESC)
            System.out.println("=== Danh sách gia sư sắp xếp theo điểm trung bình giảm dần (DESC) ===");
            List<Object[]> tutorListDesc = dao.getTutorsWithAverageRating("DESC");
            printTutorList(tutorListDesc);

            // Test với thứ tự tăng dần (ASC)
            System.out.println("\n=== Danh sách gia sư sắp xếp theo điểm trung bình tăng dần (ASC) ===");
            List<Object[]> tutorListAsc = dao.getTutorsWithAverageRating("ASC");
            printTutorList(tutorListAsc);

        } catch (SQLException e) {
            System.err.println("Lỗi khi thực hiện truy vấn: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void printTutorList(List<Object[]> tutorList) {
        if (tutorList.isEmpty()) {
            System.out.println("Không có dữ liệu gia sư nào.");
            return;
        }

        System.out.printf("%-10s %-20s %-15s %-15s%n", "TutorID", "FullName", "AverageRating", "ReviewCount");
        System.out.println("------------------------------------------------------------");
        for (Object[] tutor : tutorList) {
            int tutorId = (int) tutor[0];
            String fullName = (String) tutor[1];
            double averageRating = (double) tutor[2];
            int reviewCount = (int) tutor[3];
            System.out.printf("%-10d %-20s %-15.2f %-15d%n", tutorId, fullName, averageRating, reviewCount);
        }
    }

    // Lấy tổng số rating từ TutorRating
    public int getTotalRatings() throws SQLException {
        int totalRatings = 0;
        String sql = "SELECT COUNT(*) AS TotalRatings FROM TutorRating";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalRatings = rs.getInt("TotalRatings");
            }
        }
        return totalRatings;
    }

    // Xóa một đánh giá theo RatingID
    public boolean deleteTutorRating(int ratingId) throws SQLException {
        String sql = "DELETE FROM [dbo].[TutorRating] WHERE RatingID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, ratingId);
            int rowsAffected = pre.executeUpdate();
            return rowsAffected > 0; // Trả về true nếu xóa thành công
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, "Error deleting tutor rating", ex);
            throw ex;
        }
    }
}

