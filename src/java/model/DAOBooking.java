package model;

import entity.Booking;
import entity.Schedule;
import entity.Subject;
import entity.Slot;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOBooking extends DBConnect {

    public int addBooking(Booking booking) {
        int result = 0;
        String sql = """
            INSERT INTO [dbo].[Booking] (studentID, tutorID, slotID, bookingDate, status, subjectID) 
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, booking.getStudentID());
            ps.setInt(2, booking.getTutorID());
            ps.setInt(3, booking.getSlotID());
            ps.setDate(4, booking.getBookingDate());
            ps.setString(5, booking.getStatus());
            ps.setInt(6, booking.getSubjectID());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int getLastInsertedBookingID() {
        String sql = "SELECT SCOPE_IDENTITY() AS BookingID";
        try (PreparedStatement pre = conn.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("BookingID");
            }
        } catch (SQLException ex) {
            System.out.println("Error getting last inserted BookingID: " + ex.getMessage());
        }
        return -1;
    }

    public int addSlotsAndBookings(List<Slot> slots, List<Booking> bookings) {
        int result = 0;
        String slotSql = "INSERT INTO [dbo].[Slot] (TutorID, StartTime, EndTime, SubjectID, Status) VALUES (?, ?, ?, ?, ?)";
        String bookingSql = "INSERT INTO [dbo].[Booking] (studentID, tutorID, slotID, bookingDate, status, subjectID) VALUES (?, ?, ?, ?, ?, ?)";
        String updateScheduleSql = "UPDATE [dbo].[Schedule] SET IsBooked = 1 WHERE ScheduleID = ?";

        try {
            conn.setAutoCommit(false);
            List<Integer> slotIds = new ArrayList<>();

            try (PreparedStatement slotPs = conn.prepareStatement(slotSql, Statement.RETURN_GENERATED_KEYS)) {
                for (Slot slot : slots) {
                    slotPs.setInt(1, slot.getTutorID());
                    slotPs.setTimestamp(2, slot.getStartTime());
                    slotPs.setTimestamp(3, slot.getEndTime());
                    slotPs.setInt(4, slot.getSubjectID());
                    slotPs.setString(5, slot.getStatus());
                    slotPs.executeUpdate();
                    try (ResultSet rs = slotPs.getGeneratedKeys()) {
                        if (rs.next()) {
                            slotIds.add(rs.getInt(1));
                        }
                    }
                }
            }

            try (PreparedStatement updateSchedulePs = conn.prepareStatement(updateScheduleSql)) {
                for (Slot slot : slots) {
                    // Cần tìm ScheduleID tương ứng với Slot
                    // Tạm thời bỏ qua phần này vì không có ScheduleID trong Slot
                    // updateSchedulePs.setInt(1, slot.getScheduleID());
                    // updateSchedulePs.addBatch();
                }
                // updateSchedulePs.executeBatch();
            }

            try (PreparedStatement bookingPs = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
                for (int i = 0; i < bookings.size(); i++) {
                    Booking booking = bookings.get(i);
                    bookingPs.setInt(1, booking.getStudentID());
                    bookingPs.setInt(2, booking.getTutorID());
                    bookingPs.setInt(3, slotIds.get(i));
                    bookingPs.setDate(4, booking.getBookingDate());
                    bookingPs.setString(5, booking.getStatus());
                    bookingPs.setInt(6, booking.getSubjectID());
                    bookingPs.executeUpdate();

                    try (ResultSet rs = bookingPs.getGeneratedKeys()) {
                        if (rs.next()) {
                            booking.setBookingID(rs.getInt(1));
                            result++;
                        }
                    }
                }
            }

            conn.commit();
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public int changeBookingStatusToCompleted(int bookingID) {
        int result = 0;
        String sql = "UPDATE [dbo].[Booking] SET Status = 'Completed' WHERE BookingID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("Booking ID " + bookingID + " updated to Completed successfully.");
            } else {
                System.out.println("Failed to update Booking ID " + bookingID + ": Booking not found.");
            }
        } catch (SQLException e) {
            System.out.println("Error updating booking status: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    public int changeBookingStatusToRefund(int bookingID) {
        int result = 0;
        String sql = "UPDATE [dbo].[Booking] SET Status = 'Cancelled' WHERE BookingID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            result = ps.executeUpdate();
            if (result > 0) {
                System.out.println("Booking ID " + bookingID + " updated to Cancelled successfully.");
            } else {
                System.out.println("Failed to update Booking ID " + bookingID + ": No matching record found.");
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in changeBookingStatusToRefund: " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    public List<Booking> getAllBookings() {
        List<Booking> bookingList = new ArrayList<>();
        String sql = """
            SELECT 
                b.BookingID, 
                b.StudentID, 
                us.FullName AS StudentName, 
                b.TutorID, 
                t.CVID, 
                ut.FullName AS TutorName, 
                b.SlotID, 
                b.BookingDate, 
                b.Status, 
                b.SubjectID 
            FROM [dbo].[Booking] b
            JOIN [dbo].[Users] us ON b.StudentID = us.UserID
            JOIN [dbo].[Tutor] t ON b.TutorID = t.TutorID
            JOIN [dbo].[CV] cv ON t.CVID = cv.CVID
            JOIN [dbo].[Users] ut ON cv.UserID = ut.UserID
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setStudentID(rs.getInt("StudentID"));
                booking.setStudentName(rs.getString("StudentName"));
                booking.setTutorID(rs.getInt("TutorID"));
                booking.setTutorName(rs.getString("TutorName"));
                booking.setSlotID(rs.getInt("SlotID"));
                booking.setBookingDate(rs.getDate("BookingDate"));
                booking.setStatus(rs.getString("Status"));
                booking.setSubjectID(rs.getInt("SubjectID"));
                bookingList.add(booking);
            }
            System.out.println("Total bookings retrieved: " + bookingList.size());
        } catch (SQLException e) {
            System.out.println("SQL Error in getAllBookings: " + e.getMessage());
            e.printStackTrace();
        }
        return bookingList;
    }

    // Lấy tổng số booking với trạng thái Confirmed và Completed
    public int getTotalConfirmedAndCompletedBookings() throws SQLException {
        int totalBookings = 0;
        String sql = "SELECT COUNT(*) AS TotalBookings FROM Booking WHERE Status IN ('Confirmed', 'Completed')";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalBookings = rs.getInt("TotalBookings");
            }
        }
        return totalBookings;
    }

    // Thêm method để kiểm tra học sinh đã đặt lịch chưa
    public boolean hasStudentBookedSchedule(int studentId, int scheduleId) {
        // Kiểm tra xem học sinh đã đặt lịch này chưa
        // Vì chúng ta đang tạo Slot từ Schedule, nên cần kiểm tra theo cách khác
        String sql = """
            SELECT COUNT(*) FROM Booking b
            INNER JOIN Slot s ON b.SlotID = s.SlotID
            WHERE b.StudentID = ? AND s.TutorID = (
                SELECT TutorID FROM Schedule WHERE ScheduleID = ?
            ) AND s.StartTime = (
                SELECT StartTime FROM Schedule WHERE ScheduleID = ?
            ) AND s.EndTime = (
                SELECT EndTime FROM Schedule WHERE ScheduleID = ?
            )
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, scheduleId);
            ps.setInt(3, scheduleId);
            ps.setInt(4, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi kiểm tra booking: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Thêm method để lấy booking theo student ID
    public List<Booking> getBookingsByStudentId(int studentId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = """
            SELECT b.*, sl.StartTime, sl.EndTime, sub.SubjectName, u.FullName as TutorName, sl.Status as SlotStatus
            FROM Booking b
            INNER JOIN Slot sl ON b.SlotID = sl.SlotID
            INNER JOIN Subject sub ON b.SubjectID = sub.SubjectID
            INNER JOIN Users u ON b.TutorID = u.UserID
            WHERE b.StudentID = ?
            ORDER BY b.BookingDate DESC
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setStudentID(rs.getInt("StudentID"));
                booking.setStudentName(rs.getString("StudentName"));
                booking.setTutorID(rs.getInt("TutorID"));
                booking.setTutorName(rs.getString("TutorName"));
                booking.setSlotID(rs.getInt("SlotID"));
                booking.setBookingDate(rs.getDate("BookingDate"));
                booking.setStatus(rs.getString("Status"));
                booking.setSubjectID(rs.getInt("SubjectID"));
                
                // Tạo Slot object (thay vì Schedule)
                Slot slot = new Slot();
                slot.setSlotID(rs.getInt("SlotID"));
                slot.setStatus(rs.getString("SlotStatus"));
                booking.setSlot(slot);
                
                // Tạo Subject object
                Subject subject = new Subject();
                subject.setSubjectName(rs.getString("SubjectName"));
                booking.setSubject(subject);
                
                bookings.add(booking);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy booking theo student ID: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }
}


