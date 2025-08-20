package model;

import entity.Payment;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author minht
 */
public class DAOPayment extends DBConnect {

    private static final Logger LOGGER = Logger.getLogger(DAOPayment.class.getName());

    public DAOPayment() {
        super(); // Gọi constructor của DBConnect để khởi tạo kết nối
    }

    public int getLatestPaymentID(int userID) {
        String sql = "SELECT TOP 1 PaymentID FROM Payment WHERE UserID = ? ORDER BY PaymentDate DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("PaymentID");
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting latest PaymentID for userID: " + userID, ex);
        }
        return -1; // Trả về -1 nếu không tìm thấy
    }

    // Thêm một Payment mới và trả về PaymentID
    public int insertPayment(Payment payment) {
        String sql = "INSERT INTO Payment (BookingID, UserID, Amount, PaymentDate, PaymentMethod, SubjectID, Status) "
                + "OUTPUT INSERTED.PaymentID "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            if (payment.getBookingID() != 0) {
                pre.setInt(1, payment.getBookingID());
            } else {
                pre.setNull(1, java.sql.Types.INTEGER);
            }
            pre.setInt(2, payment.getUserID());
            pre.setDouble(3, payment.getAmount());
            pre.setTimestamp(4, payment.getPaymentDate() != null ? new Timestamp(payment.getPaymentDate().getTime()) : null);
            pre.setString(5, payment.getPaymentMethod());
            pre.setInt(6, payment.getSubjectID());
            String status = payment.getStatus() != null ? payment.getStatus() : "Processing";
            pre.setString(7, status);

            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    int paymentID = rs.getInt("PaymentID");
                    LOGGER.log(Level.INFO, "Inserted Payment: PaymentID={0}", paymentID);
                    return paymentID;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting Payment: " + ex.getMessage(), ex);
        }
        return -1; // Trả về -1 nếu thất bại
    }

    // Lấy lịch sử thanh toán theo UserID (cho user)
    public List<Payment> getPaymentsByUserId(int userID) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.* FROM Payment p WHERE p.UserID = ? ORDER BY p.PaymentDate DESC";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, userID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Payment payment = extractPaymentFromResultSet(rs);
                    payments.add(payment);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting payments for userID: " + userID, ex);
        }
        return payments;
    }

    // Lấy toàn bộ lịch sử thanh toán (cho admin)
    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT PaymentID, Payment.BookingID, FullName, Email, Price, PaymentDate, Payment.Status, PromotionID "
                + "FROM dbo.Payment "
                + "JOIN dbo.Users ON Users.UserID = Payment.UserID "
                + "LEFT JOIN dbo.Booking ON Booking.BookingID = Payment.BookingID "
                + "LEFT JOIN dbo.Tutor ON Tutor.TutorID = Booking.TutorID "
                + "ORDER BY PaymentDate DESC";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentID(rs.getInt("PaymentID"));
                    payment.setBookingID(rs.getInt("BookingID"));
                    if (rs.wasNull()) {
                        payment.setBookingID(0);
                    }
                    payment.setPaymentDate(rs.getTimestamp("PaymentDate"));
                    payment.setStatus(rs.getString("Status"));
                    payment.setUserName(rs.getString("FullName"));
                    payment.setEmail(rs.getString("Email"));
                    payment.setAmount(rs.getDouble("Price"));
                    payment.setPromotionID(rs.getInt("PromotionID"));
                    if (rs.wasNull()) {
                        payment.setPromotionID(0);
                    }
                    payments.add(payment);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting all payments", ex);
        }
        return payments;
    }

    // Lấy danh sách Payment theo trang (phân trang cho admin)
    public List<Payment> getPaymentsByPageForAdmin(int page, int pageSize) {
        List<Payment> payments = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT PaymentID, Payment.BookingID, FullName, Email, Price, PaymentDate, Payment.Status, PromotionID "
                + "FROM dbo.Payment "
                + "JOIN dbo.Users ON Users.UserID = Payment.UserID "
                + "LEFT JOIN dbo.Booking ON Booking.BookingID = Payment.BookingID "
                + "LEFT JOIN dbo.Tutor ON Tutor.TutorID = Booking.TutorID "
                + "ORDER BY PaymentDate DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, offset);
            pre.setInt(2, pageSize);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentID(rs.getInt("PaymentID"));
                    payment.setBookingID(rs.getInt("BookingID"));
                    if (rs.wasNull()) {
                        payment.setBookingID(0);
                    }
                    payment.setPaymentDate(rs.getTimestamp("PaymentDate"));
                    payment.setStatus(rs.getString("Status"));
                    payment.setUserName(rs.getString("FullName"));
                    payment.setEmail(rs.getString("Email"));
                    payment.setAmount(rs.getDouble("Price"));
                    payment.setPromotionID(rs.getInt("PromotionID"));
                    if (rs.wasNull()) {
                        payment.setPromotionID(0);
                    }
                    payments.add(payment);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting payments by page for admin: page=" + page + ", pageSize=" + pageSize, ex);
        }
        return payments;
    }

    // Cập nhật trạng thái của Payment
    public boolean updatePaymentStatus(Payment payment) {
        if (payment == null || payment.getStatus() == null || payment.getStatus().trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Invalid input for updating payment status: PaymentID=" + (payment != null ? payment.getPaymentID() : "null"));
            return false;
        }

        String sql = "UPDATE Payment SET Status = ? WHERE PaymentID = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, payment.getStatus());
            pre.setInt(2, payment.getPaymentID());
            int rowsAffected = pre.executeUpdate();
            LOGGER.log(Level.INFO, "Updated payment status: PaymentID={0}, Status={1}, RowsAffected={2}",
                    new Object[]{payment.getPaymentID(), payment.getStatus(), rowsAffected});
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating payment status: PaymentID=" + payment.getPaymentID(), ex);
            return false;
        }
    }

    // Cập nhật BookingID của Payment
    public boolean updatePaymentBookingId(Payment payment) {
        String sql = "UPDATE Payment SET BookingID = ? WHERE PaymentID = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            if (payment.getBookingID() != 0) {
                pre.setInt(1, payment.getBookingID());
            } else {
                pre.setNull(1, java.sql.Types.INTEGER);
            }
            pre.setInt(2, payment.getPaymentID());
            int rowsAffected = pre.executeUpdate();
            LOGGER.log(Level.INFO, "Updated payment BookingID: PaymentID={0}, BookingID={1}, RowsAffected={2}",
                    new Object[]{payment.getPaymentID(), payment.getBookingID(), rowsAffected});
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating payment BookingID: PaymentID=" + payment.getPaymentID(), ex);
            return false;
        }
    }

    // Lấy Payment theo PaymentID
    public Payment getPaymentById(int paymentID) {
        String sql = "SELECT * FROM Payment WHERE PaymentID = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, paymentID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return extractPaymentFromResultSet(rs);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting payment by PaymentID: " + paymentID, ex);
        }
        return null;
    }

    // Lấy Payment theo BookingID
    public Payment getPaymentByBookingId(int bookingID) {
        String sql = "SELECT * FROM Payment WHERE BookingID = ? ORDER BY PaymentDate DESC";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, bookingID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return extractPaymentFromResultSet(rs);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting payment by BookingID: " + bookingID, ex);
        }
        return null;
    }

    // Xóa Payment với trạng thái Processing
    public boolean deletePayment(int paymentID) {
        String sql = "DELETE FROM Payment WHERE PaymentID = ? AND Status = 'Processing'";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, paymentID);
            int rowsAffected = pre.executeUpdate();
            LOGGER.log(Level.INFO, "Deleted payment: PaymentID={0}, RowsAffected={1}",
                    new Object[]{paymentID, rowsAffected});
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting payment: PaymentID=" + paymentID, ex);
            return false;
        }
    }

    // Lấy danh sách Payment theo trang (phân trang)
    public List<Payment> getPaymentsByPage(int page, int pageSize) {
        List<Payment> paymentList = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM Payment ORDER BY PaymentDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, offset);
            pre.setInt(2, pageSize);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Payment payment = extractPaymentFromResultSet(rs);
                    paymentList.add(payment);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting payments by page: page=" + page + ", pageSize=" + pageSize, ex);
        }
        return paymentList;
    }

    // Lấy tổng số Payment để tính số trang
    public int getTotalPayments() {
        String sql = "SELECT COUNT(*) FROM Payment";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting total payments", ex);
        }
        return 0;
    }

    // Phương thức trích xuất dữ liệu Payment từ ResultSet
    private Payment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentID(rs.getInt("PaymentID"));
        payment.setBookingID(rs.getInt("BookingID"));
        if (rs.wasNull()) {
            payment.setBookingID(0);
        }
        payment.setUserID(rs.getInt("UserID"));
        payment.setAmount(rs.getDouble("Amount"));
        payment.setPaymentMethod(rs.getString("PaymentMethod"));
        Timestamp timestamp = rs.getTimestamp("PaymentDate");
        if (timestamp != null) {
            payment.setPaymentDate(new Date(timestamp.getTime()));
        }
        payment.setSubjectID(rs.getInt("SubjectID"));
        if (rs.wasNull()) {
            payment.setSubjectID(0);
        }
        payment.setStatus(rs.getString("Status"));
        return payment;
    }

    // Test method
    public static void main(String[] args) {
        DAOPayment dao = new DAOPayment();
        Payment payment = new Payment();
        payment.setUserID(5);
        payment.setAmount(23232);
        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
        payment.setPaymentMethod("VNPAY");
        payment.setSubjectID(2);
        payment.setBookingID(0);
        payment.setStatus("Processing");

        int paymentID = dao.insertPayment(payment);
        if (paymentID > 0) {
            System.out.println("Chèn Payment thành công: PaymentID=" + paymentID);
        } else {
            System.out.println("Chèn Payment thất bại");
        }

        System.out.println(paymentID);
    }

    // Lấy tổng Amount từ Payment với trạng thái Completed
    public double getTotalProfit() throws SQLException {
        double totalProfit = 0.0;
        String sql = "SELECT SUM(Amount) AS TotalProfit FROM Payment WHERE Status = 'Completed'";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalProfit = rs.getDouble("TotalProfit");
            }
        }
        return totalProfit;
    }

    // Lấy 5 giao dịch gần nhất
    public List<Payment> getRecentPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT TOP 5 PaymentID, BookingID, UserID, Amount, PaymentMethod, PaymentDate, PromotionID, SubjectID, Status "
                + "FROM Payment "
                + "ORDER BY PaymentDate DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentID(rs.getInt("PaymentID"));
                payment.setBookingID(rs.getInt("BookingID"));
                payment.setUserID(rs.getInt("UserID"));
                payment.setAmount(rs.getDouble("Amount"));
                payment.setPaymentMethod(rs.getString("PaymentMethod"));
                payment.setPaymentDate(rs.getTimestamp("PaymentDate"));
                payment.setPromotionID(rs.getInt("PromotionID"));
                payment.setSubjectID(rs.getInt("SubjectID"));
                payment.setStatus(rs.getString("Status"));
                payments.add(payment);
            }
        }
        return payments;
    }
}


