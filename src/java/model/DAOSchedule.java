package model;

import entity.Booking;
import entity.Cv;
import entity.Schedule;
import entity.Slot;
import entity.Subject;
import entity.Tutor;
import entity.User;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOSchedule extends DBConnect {

    //Hungnv: View Schedules
    public List<Map<String, Object>> getSchedulesByUserId(int userId, String search) {
        List<Map<String, Object>> schedules = new ArrayList<>();
        String query = """
        SELECT b.BookingID, b.BookingDate, b.Status AS BookingStatus,
               s.ScheduleID, s.StartTime, s.EndTime, sub.SubjectName
        FROM Booking b
        JOIN Slot sl ON b.SlotID = sl.SlotID
        JOIN Schedule s ON sl.ScheduleID = s.ScheduleID
        JOIN Subject sub ON b.SubjectID = sub.SubjectID
        JOIN Student st ON b.StudentID = st.StudentID
        JOIN CustomerUsers cu ON st.CustomerUserID = cu.CustomerUserID
        JOIN Users u ON u.Email = cu.Email
        WHERE u.UserID = ?
          AND (sub.SubjectName LIKE ? OR b.Status LIKE ?)
    """;
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, "%" + search + "%");
            ps.setString(3, "%" + search + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> schedule = new HashMap<>();
                schedule.put("id", rs.getInt("ScheduleID"));
                schedule.put("bookingID", rs.getInt("BookingID")); // Thêm BookingID vào Map
                schedule.put("title", rs.getString("SubjectName") + " - " + rs.getString("BookingStatus"));
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                schedule.put("start", sdf.format(rs.getTimestamp("StartTime")));
                schedule.put("end", sdf.format(rs.getTimestamp("EndTime")));
                schedules.add(schedule);
            }
            System.out.println("DEBUG: getSchedulesByUserId returned " + schedules.size() + " items for user=" + userId);
        } catch (SQLException e) {
            System.out.println("lấy schedules by user Id thất bại!");
            e.printStackTrace();
        }
        System.out.println("lấy thành công schedules by user Id");
        return schedules;
    }

    public List<Map<String, Object>> getSchedulesByTutorIdd(int tutorId, String search) {
        List<Map<String, Object>> schedules = new ArrayList<>();
        String query = """
        SELECT b.BookingID, b.BookingDate, b.Status AS BookingStatus, 
               s.ScheduleID, s.StartTime, s.EndTime, sub.SubjectName
        FROM Booking b
        JOIN Slot sl ON b.SlotID = sl.SlotID
        JOIN Schedule s ON sl.ScheduleID = s.ScheduleID
        JOIN Subject sub ON b.SubjectID = sub.SubjectID
        WHERE s.TutorID = ?
        AND sub.SubjectName LIKE ?
    """;
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tutorId);
            ps.setString(2, "%" + search + "%"); // Lọc theo SubjectName, sử dụng LIKE để tìm kiếm gần đúng

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> schedule = new HashMap<>();
                schedule.put("bookingID", rs.getInt("BookingID"));
                schedule.put("title", rs.getString("SubjectName") + " - " + rs.getString("BookingStatus"));
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                schedule.put("start", sdf.format(rs.getTimestamp("StartTime")));
                schedule.put("end", sdf.format(rs.getTimestamp("EndTime")));
                schedules.add(schedule);
            }
            System.out.println("Lấy thành công " + schedules.size() + " schedules for Tutor ID " + tutorId + " with search: " + search);
        } catch (SQLException e) {
            System.out.println("Lấy schedules by tutor Id thất bại: " + e.getMessage());
            e.printStackTrace();
        }
        return schedules;
    }

    // Hungnv: Book Schedule
    public List<Schedule> getSchedulesByTutorAndSubject(int tutorId, int subjectId) {
        List<Schedule> schedules = new ArrayList<>();
        
        // Debug: In ra tất cả schedules trước khi filter
        System.out.println("DEBUG: Tìm schedules cho TutorID=" + tutorId + ", SubjectID=" + subjectId);
        
        String query = """
        SELECT s.*, sub.SubjectName, sub.SubjectID
        FROM Schedule s
        INNER JOIN Subject sub ON s.SubjectID = sub.SubjectID
        WHERE s.TutorID = ? and s.SubjectID = ? and s.IsBooked = 0  
        AND s.StartTime > GETDATE() and s.Status = 'Available'
        ORDER BY s.StartTime ASC
    """;
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tutorId);
            ps.setInt(2, subjectId);
            ResultSet rs = ps.executeQuery();
            
            // Debug: In ra số lượng schedules tìm được
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("DEBUG: Tìm thấy ScheduleID=" + rs.getInt("ScheduleID") + 
                    ", StartTime=" + rs.getTimestamp("StartTime") + 
                    ", IsBooked=" + rs.getBoolean("IsBooked") + 
                    ", Status=" + rs.getString("Status"));
                Schedule schedule = new Schedule();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime"));
                schedule.setEndTime(rs.getTimestamp("EndTime"));
                schedule.setIsBooked(rs.getBoolean("IsBooked"));
                schedule.setSubjectId(rs.getInt("SubjectID"));
                schedule.setStatus(rs.getString("Status"));
                
                Subject subject = new Subject();
                subject.setSubjectID(rs.getInt("SubjectID"));
                subject.setSubjectName(rs.getString("SubjectName"));
                schedule.setSubject(subject);
                
                schedules.add(schedule);
            }
            System.out.println("DEBUG: Tổng cộng tìm thấy " + count + " schedules phù hợp");
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách lịch của tutor: " + e.getMessage());
            e.printStackTrace();
        }
        return schedules;
    }
    
    // Debug method: Lấy tất cả schedules của tutor (không filter)
    public List<Schedule> getAllSchedulesByTutorAndSubjectDebug(int tutorId, int subjectId) {
        List<Schedule> schedules = new ArrayList<>();
        String query = """
        SELECT s.*, sub.SubjectName, sub.SubjectID
        FROM Schedule s
        INNER JOIN Subject sub ON s.SubjectID = sub.SubjectID
        WHERE s.TutorID = ? and s.SubjectID = ?
        ORDER BY s.StartTime ASC
    """;
        
        System.out.println("DEBUG: Lấy TẤT CẢ schedules (không filter) cho TutorID=" + tutorId + ", SubjectID=" + subjectId);
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tutorId);
            ps.setInt(2, subjectId);
            ResultSet rs = ps.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("DEBUG: Schedule " + count + " - ID=" + rs.getInt("ScheduleID") + 
                    ", StartTime=" + rs.getTimestamp("StartTime") + 
                    ", IsBooked=" + rs.getBoolean("IsBooked") + 
                    ", Status=" + rs.getString("Status"));
                
                Schedule schedule = new Schedule();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime"));
                schedule.setEndTime(rs.getTimestamp("EndTime"));
                schedule.setIsBooked(rs.getBoolean("IsBooked"));
                schedule.setSubjectId(rs.getInt("SubjectID"));
                schedule.setStatus(rs.getString("Status"));
                
                Subject subject = new Subject();
                subject.setSubjectID(rs.getInt("SubjectID"));
                subject.setSubjectName(rs.getString("SubjectName"));
                schedule.setSubject(subject);
                
                schedules.add(schedule);
            }
            System.out.println("DEBUG: Tổng cộng có " + count + " schedules (không filter)");
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy tất cả schedules: " + e.getMessage());
            e.printStackTrace();
        }
        return schedules;
    }

    public List<Schedule> getSchedulesByTutorId(int tutorId) {
        List<Schedule> schedules = new ArrayList<>();
        String query = """
        SELECT s.*, sub.SubjectName
        FROM Schedule s
        INNER JOIN Subject sub ON s.SubjectID = sub.SubjectID
        WHERE s.TutorID = ?
        ORDER BY s.StartTime ASC
    """;

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tutorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Schedule schedule = new Schedule();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime"));
                schedule.setEndTime(rs.getTimestamp("EndTime"));
                schedule.setIsBooked(rs.getBoolean("IsBooked"));
                schedule.setSubjectId(rs.getInt("SubjectID"));
                schedule.setStatus(rs.getString("Status"));

                Subject subject = new Subject();
                subject.setSubjectName(rs.getString("SubjectName"));

                schedule.setSubject(subject);

                schedules.add(schedule);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách lịch trình của tutor: " + e.getMessage());
            e.printStackTrace();
        }
        return schedules;
    }

    public boolean insertSchedule(Schedule schedule) {
        String query = """
        INSERT INTO Schedule (TutorID, StartTime, EndTime, IsBooked, SubjectID, Status)
        VALUES (?, ?, ?, ?, ?, ?)
    """;
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, schedule.getTutorID());
            Timestamp startTs = new Timestamp(schedule.getStartTime().getTime());
            Timestamp endTs = new Timestamp(schedule.getEndTime().getTime());
            System.out.println("DEBUG INSERT: schedule start=" + startTs + ", end=" + endTs);
            java.util.Calendar dbgCal = java.util.Calendar.getInstance();
            dbgCal.setTimeInMillis(startTs.getTime());
            System.out.println("DEBUG INSERT: start DOW=" + dbgCal.get(java.util.Calendar.DAY_OF_WEEK));
            ps.setTimestamp(2, startTs);
            ps.setTimestamp(3, endTs);
            ps.setBoolean(4, schedule.getIsBooked());
            ps.setInt(5, schedule.getSubjectId());
            ps.setString(6, schedule.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi thêm lịch dạy: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public Schedule getScheduleById(int scheduleId) {
        Schedule schedule = null;
        String query = """
        SELECT s.*, sub.SubjectName
        FROM Schedule s
        INNER JOIN Subject sub ON s.SubjectID = sub.SubjectID
        WHERE s.ScheduleID = ?
    """;

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                schedule = new Schedule();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime"));
                schedule.setEndTime(rs.getTimestamp("EndTime"));
                schedule.setIsBooked(rs.getBoolean("IsBooked"));
                schedule.setSubjectId(rs.getInt("SubjectID"));
                schedule.setStatus(rs.getString("Status"));

                Subject subject = new Subject();
                subject.setSubjectName(rs.getString("SubjectName"));
                schedule.setSubject(subject);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy lịch học theo scheduleId: " + e.getMessage());
            e.printStackTrace();
        }
        return schedule;
    }
//    public boolean isScheduleExist(int tutorId, int subjectId, Date startTime) throws SQLException {
//    String sql = "SELECT COUNT(*) FROM Schedule WHERE tutorId = ? AND subjectId = ? AND startTime = ?";
//    try (Connection conn = getConnection();
//         PreparedStatement ps = conn.prepareStatement(sql)) {
//        ps.setInt(1, tutorId);
//        ps.setInt(2, subjectId);
//        ps.setTimestamp(3, new Timestamp(startTime.getTime()));
//        
//        try (ResultSet rs = ps.executeQuery()) {
//            if (rs.next()) {
//                return rs.getInt(1) > 0;
//            }
//        }
//    }
//    return false;
//}
public boolean isScheduleConflict(int tutorId, Date startTime, Date endTime) throws SQLException {
    String sql = "SELECT COUNT(*) FROM Schedule WHERE tutorId = ? " +
                 "AND ((startTime BETWEEN ? AND ?) OR (endTime BETWEEN ? AND ?) " +
                 "OR (? BETWEEN startTime AND endTime) OR (? BETWEEN startTime AND endTime))";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, tutorId);
        ps.setTimestamp(2, new java.sql.Timestamp(startTime.getTime()));
        ps.setTimestamp(3, new java.sql.Timestamp(endTime.getTime()));
        ps.setTimestamp(4, new java.sql.Timestamp(startTime.getTime()));
        ps.setTimestamp(5, new java.sql.Timestamp(endTime.getTime()));
        ps.setTimestamp(6, new java.sql.Timestamp(startTime.getTime()));
        ps.setTimestamp(7, new java.sql.Timestamp(endTime.getTime()));

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0; // Nếu COUNT > 0, có lịch trùng
        }
    }
    return false;
}


    public boolean isScheduleExist(int tutorId, int subjectId, java.util.Date startTime) {
        String sql = "SELECT COUNT(*) FROM Schedule WHERE TutorID = ? AND SubjectID = ? AND StartTime = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorId);
            ps.setInt(2, subjectId);
            ps.setTimestamp(3, new Timestamp(startTime.getTime()));
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi kiểm tra lịch tồn tại: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Thêm method để tạo lịch mới
    public int addSchedule(Schedule schedule) {
        String sql = "INSERT INTO Schedule (TutorID, SubjectID, StartTime, EndTime, IsBooked, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, schedule.getTutorID());
            ps.setInt(2, schedule.getSubjectId());
            ps.setTimestamp(3, new Timestamp(schedule.getStartTime().getTime()));
            ps.setTimestamp(4, new Timestamp(schedule.getEndTime().getTime()));
            ps.setBoolean(5, schedule.getIsBooked());
            ps.setString(6, schedule.getStatus() != null ? schedule.getStatus() : "Available");
            
            int result = ps.executeUpdate();
            if (result > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        schedule.setScheduleID(rs.getInt(1));
                    }
                }
            }
            return result;
        } catch (SQLException e) {
            System.out.println("Lỗi khi thêm lịch mới: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    




    // Thêm method để xóa lịch
    public int deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM Schedule WHERE ScheduleID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Lỗi khi xóa lịch: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    // Thêm method để cập nhật trạng thái lịch
    public boolean updateScheduleStatus(int scheduleId, boolean isBooked) {
        String sql = "UPDATE Schedule SET IsBooked = ? WHERE ScheduleID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isBooked);
            ps.setInt(2, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi cập nhật trạng thái lịch: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }


    /**
     * Lấy TẤT CẢ lịch của tutor để hiển thị trên calendar (bao gồm cả đã book và chưa book)
     */
    public List<Schedule> getAllSchedulesForCalendar(int tutorId, java.util.Date fromDate) {
        List<Schedule> schedules = new ArrayList<>();
        
        String query = """
            SELECT s.*, sub.SubjectName, sub.SubjectID
            FROM Schedule s
            INNER JOIN Subject sub ON s.SubjectID = sub.SubjectID
            WHERE s.TutorID = ? 
                AND s.StartTime >= ?
                AND s.Status = 'Available'
            ORDER BY s.StartTime ASC
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tutorId);
            ps.setTimestamp(2, new Timestamp(fromDate.getTime()));
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Schedule schedule = new Schedule();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime"));
                schedule.setEndTime(rs.getTimestamp("EndTime"));
                schedule.setIsBooked(rs.getBoolean("IsBooked"));
                schedule.setSubjectId(rs.getInt("SubjectID"));
                schedule.setStatus(rs.getString("Status"));
                
                Subject subject = new Subject();
                subject.setSubjectID(rs.getInt("SubjectID"));
                subject.setSubjectName(rs.getString("SubjectName"));
                schedule.setSubject(subject);
                
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy tất cả lịch cho calendar: " + e.getMessage());
            e.printStackTrace();
        }
        
        return schedules;
    }

    /**
     * Lấy lịch available của tutor để student có thể book
     */
    public List<Schedule> getAvailableSchedules(int tutorId, java.util.Date fromDate) {
        List<Schedule> schedules = new ArrayList<>();
        
        String query = """
            SELECT s.*, sub.SubjectName, sub.SubjectID
            FROM Schedule s
            INNER JOIN Subject sub ON s.SubjectID = sub.SubjectID
            WHERE s.TutorID = ? 
                AND s.StartTime >= ?
                AND s.IsBooked = 0 
                AND s.Status = 'Available'
                AND NOT EXISTS (
                    SELECT 1 FROM Booking b 
                    WHERE b.SlotID = s.ScheduleID 
                    AND b.Status NOT IN ('Cancelled')
                )
            ORDER BY s.StartTime ASC
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tutorId);
            ps.setTimestamp(2, new Timestamp(fromDate.getTime()));
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Schedule schedule = new Schedule();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime"));
                schedule.setEndTime(rs.getTimestamp("EndTime"));
                schedule.setIsBooked(rs.getBoolean("IsBooked"));
                schedule.setSubjectId(rs.getInt("SubjectID"));
                schedule.setStatus(rs.getString("Status"));
                
                Subject subject = new Subject();
                subject.setSubjectID(rs.getInt("SubjectID"));
                subject.setSubjectName(rs.getString("SubjectName"));
                schedule.setSubject(subject);
                
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy lịch available: " + e.getMessage());
            e.printStackTrace();
        }
        
        return schedules;
    }



}
