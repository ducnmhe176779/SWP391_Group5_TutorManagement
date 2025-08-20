package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import entity.ScheduleTemp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

public class ScheduleDAO {

    // Sử dụng DBConnect đã có sẵn
    private DBConnect dbConnect;

    public ScheduleDAO() {
        this.dbConnect = new DBConnect();  // Khởi tạo kết nối
    }

    // Thêm lịch dạy mới vào cơ sở dữ liệu
    public int createSchedule(ScheduleTemp schedule) {
        String sql = "INSERT INTO dbo.Schedule (TutorID, StartTime, EndTime, IsBooked, SubjectID) VALUES (?, ?, ?, 0, ?)";
        try (Connection conn = dbConnect.conn; PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, schedule.getTutorID());
            stmt.setObject(2, schedule.getStartTime());
            stmt.setObject(3, schedule.getEndTime());
            stmt.setInt(4, schedule.getSubjectID());
            stmt.executeUpdate();

            // Lấy ID của lịch dạy vừa tạo
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);  // Trả về ScheduleID
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Lấy tất cả lịch chưa được đặt
    public List<ScheduleTemp> getAvailableSchedules() {
        List<ScheduleTemp> schedules = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Schedule WHERE IsBooked = 0";
        try (Connection conn = dbConnect.conn; PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ScheduleTemp schedule = new ScheduleTemp();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime").toLocalDateTime());
                schedule.setEndTime(rs.getTimestamp("EndTime").toLocalDateTime());
                schedule.setBooked(rs.getBoolean("IsBooked"));
                schedule.setSubjectID(rs.getInt("SubjectID"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }

    // Cập nhật lịch đã được phê duyệt (IsBooked = 1)
    public boolean approveSchedule(int scheduleID) {
        String sql = "UPDATE dbo.Schedule SET status = 'Qualified' WHERE ScheduleID = ?";
        try (Connection conn = dbConnect.conn; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, scheduleID);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hủy lịch (IsBooked = 0)
    public boolean cancelSchedule(int scheduleID) {
        String sql = "UPDATE dbo.Schedule SET IsBooked = 0 WHERE ScheduleID = ?";
        try (Connection conn = dbConnect.conn; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, scheduleID);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ScheduleTemp> getSchedulesByUserId(int userId) {
        List<ScheduleTemp> schedules = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Schedule WHERE TutorID = ?";
        try (Connection conn = dbConnect.conn; PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ScheduleTemp schedule = new ScheduleTemp();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime").toLocalDateTime());
                schedule.setEndTime(rs.getTimestamp("EndTime").toLocalDateTime());
                schedule.setBooked(rs.getBoolean("IsBooked"));
                schedule.setSubjectID(rs.getInt("SubjectID"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }

 public Map<String, Object> getSchedulesWithPaginationStatusPending(int pageNumber, int pageSize) {
    Map<String, Object> result = new HashMap<>();
    List<ScheduleTemp> schedules = new ArrayList<>();
    int totalPages = 1;
    int offset = (pageNumber - 1) * pageSize;

    // SQL đếm tổng số bản ghi có trạng thái 'Pending'
    String countSql = "SELECT COUNT(*) FROM dbo.Schedule WHERE Status = 'Pending'";

    // SQL lấy danh sách lịch Pending theo phân trang
    String sql = "SELECT s.ScheduleID, u.FullName AS TutorName, s.StartTime, s.EndTime, " +
                 "sub.SubjectName, s.IsBooked " +
                 "FROM dbo.Schedule s " +
                 "JOIN dbo.CV cv ON cv.SubjectID = s.SubjectID " +
                 "LEFT JOIN dbo.Users u ON u.UserID = cv.UserID " +
                 "LEFT JOIN dbo.Subject sub ON sub.SubjectID = cv.SubjectID " +
                 "WHERE s.Status = 'Pending' " +
                 "ORDER BY s.ScheduleID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (Connection conn = dbConnect.getConnection()) { // Mở kết nối mới
        if (conn == null || conn.isClosed()) {
            System.out.println("Database connection is closed!");
            return result;
        }

        // Lấy tổng số trang
        try (PreparedStatement countStmt = conn.prepareStatement(countSql);
             ResultSet countRs = countStmt.executeQuery()) {
            if (countRs.next()) {
                int totalRecords = countRs.getInt(1);
                totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            }
        }

        // Lấy danh sách lịch dạy có trạng thái 'Pending'
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, offset);
            stmt.setInt(2, pageSize);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleTemp schedule = new ScheduleTemp();
                    schedule.setScheduleID(rs.getInt("ScheduleID"));
                    schedule.setTutorName(rs.getString("TutorName")); // Lấy tên Tutor
                    schedule.setStartTime(rs.getTimestamp("StartTime").toLocalDateTime());
                    schedule.setEndTime(rs.getTimestamp("EndTime").toLocalDateTime());
                    schedule.setSubjectName(rs.getString("SubjectName")); // Lấy SubjectName
                    schedule.setBooked(rs.getBoolean("IsBooked"));
                    schedules.add(schedule);
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        System.out.println("Lỗi khi lấy danh sách lịch dạy đang Pending!");
    }

    result.put("schedules", schedules);
    result.put("totalPages", totalPages);
    return result;
}

    public List<Map<String, Object>> getTutorSchedules(int tutorId, String search) {
    List<Map<String, Object>> schedules = new ArrayList<>();
    String sql = "SELECT s.*, u.FullName AS StudentName " +
                 "FROM dbo.Schedule s " +
                 "LEFT JOIN dbo.[User] u ON s.StudentID = u.UserID " +
                 "WHERE s.TutorID = ? AND (u.FullName LIKE ? OR s.StartTime LIKE ?)";
    
    try (Connection conn = dbConnect.conn;
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, tutorId);
        stmt.setString(2, "%" + search + "%");
        stmt.setString(3, "%" + search + "%");
        
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Map<String, Object> schedule = new HashMap<>();
            schedule.put("ScheduleID", rs.getInt("ScheduleID"));
            schedule.put("TutorID", rs.getInt("TutorID"));
            schedule.put("StartTime", rs.getTimestamp("StartTime").toLocalDateTime());
            schedule.put("EndTime", rs.getTimestamp("EndTime").toLocalDateTime());
            schedule.put("IsBooked", rs.getBoolean("IsBooked"));
            schedule.put("SubjectID", rs.getInt("SubjectID"));
            schedule.put("StudentName", rs.getString("StudentName")); // Nếu null thì chưa có ai book

            schedules.add(schedule);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return schedules;
}



}
