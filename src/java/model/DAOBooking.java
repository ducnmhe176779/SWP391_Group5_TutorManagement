package model;

import entity.Booking;
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
        String slotSql = "INSERT INTO [dbo].[Slot] (scheduleID, status) VALUES (?, ?)";
        String bookingSql = "INSERT INTO [dbo].[Booking] (studentID, tutorID, slotID, bookingDate, status, subjectID) VALUES (?, ?, ?, ?, ?, ?)";
        String updateScheduleSql = "UPDATE [dbo].[Schedule] SET IsBooked = 1 WHERE scheduleID = ?";

        try {
            conn.setAutoCommit(false);
            List<Integer> slotIds = new ArrayList<>();

            try (PreparedStatement slotPs = conn.prepareStatement(slotSql, Statement.RETURN_GENERATED_KEYS)) {
                for (Slot slot : slots) {
                    slotPs.setInt(1, slot.getScheduleID());
                    slotPs.setString(2, slot.getStatus());
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
                    updateSchedulePs.setInt(1, slot.getScheduleID());
                    updateSchedulePs.addBatch();
                }
                updateSchedulePs.executeBatch();
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
}


