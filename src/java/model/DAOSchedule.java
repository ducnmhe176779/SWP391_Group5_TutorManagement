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
        WHERE b.StudentID = ? 
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
        String query = """
        SELECT *
        FROM Schedule s
        WHERE TutorID = ? and SubjectID = ? and IsBooked = 0  AND StartTime > GETDATE() and Status != 'pending'
    """;
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tutorId);
            ps.setInt(2, subjectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Schedule schedule = new Schedule();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime"));
                schedule.setEndTime(rs.getTimestamp("EndTime"));
                schedule.setSubjectId(rs.getInt("SubjectID"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách lịch của tutor: " + e.getMessage());
            e.printStackTrace();
        }
        return schedules;
    }

  public List<Schedule> getSchedulesByTutorId(int tutorId) {
    List<Schedule> schedules = new ArrayList<>();
    String query = """
        SELECT s.ScheduleID, s.TutorID, s.SlotNumber, s.IsBooked, s.SubjectID, s.Status, sub.SubjectName
        FROM Schedule s
        INNER JOIN Subject sub ON s.SubjectID = sub.SubjectID
        WHERE s.TutorID = ?
        ORDER BY s.SlotNumber ASC
    """;

    try (PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, tutorId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Schedule schedule = new Schedule();
            schedule.setScheduleID(rs.getInt("ScheduleID"));
            schedule.setTutorID(rs.getInt("TutorID"));
            schedule.setSlotNumber(rs.getInt("SlotNumber"));   // ✅ slotNumber thay cho StartTime/EndTime
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
        INSERT INTO Schedule (TutorID, SlotNumber, IsBooked, SubjectID, Status)
        VALUES (?, ?, ?, ?, ?)
    """;
    try (PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, schedule.getTutorID());
        ps.setInt(2, schedule.getSlotNumber());   // Slot
        ps.setBoolean(3, schedule.getIsBooked());
        ps.setInt(4, schedule.getSubjectId());
        ps.setString(5, schedule.getStatus());

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
        SELECT s.ScheduleID, s.TutorID, s.SlotNumber, s.IsBooked, s.SubjectID, s.Status, sub.SubjectName
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
            schedule.setSlotNumber(rs.getInt("SlotNumber"));   // ✅
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
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
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

}
