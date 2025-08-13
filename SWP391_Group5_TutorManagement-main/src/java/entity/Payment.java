/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author minht
 */
import java.util.Date;

public class Payment {
    private int paymentID;
    private int bookingID;
    private int userID;
    private double amount;
    private String paymentMethod;
    private Date paymentDate;
    private int promotionID;
    private int subjectID;
    private String status;
    private String userName; // Thêm để lưu FullName
    private String email;    // Thêm để lưu Email
    // Constructor mặc định
    public Payment() {
    }

    public Payment(int paymentID, int bookingID, int userID, double amount, String paymentMethod, Date paymentDate, int promotionID, int subjectID, String status, String userName, String email) {
        this.paymentID = paymentID;
        this.bookingID = bookingID;
        this.userID = userID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentDate = paymentDate;
        this.promotionID = promotionID;
        this.subjectID = subjectID;
        this.status = status;
        this.userName = userName;
        this.email = email;
    }
    

    public Payment(int paymentID, int bookingID, int userID, double amount, String paymentMethod, Date paymentDate, int subjectID, String status) {
        this.paymentID = paymentID;
        this.bookingID = bookingID;
        this.userID = userID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentDate = paymentDate;
        this.subjectID = subjectID;
        this.status = status;
    }

    public Payment(int paymentID, int bookingID, int userID, double amount, String paymentMethod, Date paymentDate, int promotionID, int subjectID, String status) {
        this.paymentID = paymentID;
        this.bookingID = bookingID;
        this.userID = userID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentDate = paymentDate;
        this.promotionID = promotionID;
        this.subjectID = subjectID;
        this.status = status;
    }

    public int getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(int promotionID) {
        this.promotionID = promotionID;
    }
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public int getSubjectID() {
        return subjectID;
    }

    public void setSubjectID(int subjectID) {
        this.subjectID = subjectID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    
}