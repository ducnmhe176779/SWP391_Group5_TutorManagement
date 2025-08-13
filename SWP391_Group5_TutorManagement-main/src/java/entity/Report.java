/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;
import java.util.Date;

public class Report {
    private int reportID;
    private int bookID;
    private int userID;
    private String reason;
    private String status;
    private Date createdAt;

    public Report() {}

    public Report(int reportID, int bookID, int userID, String reason, String status) {
        this.reportID = reportID;
        this.bookID = bookID;
        this.userID = userID;
        this.reason = reason;
        this.status = status;
    }

    public Report(int reportID, int bookID, int userID, String reason, String status, Date createdAt) {
        this.reportID = reportID;
        this.bookID = bookID;
        this.userID = userID;
        this.reason = reason;
        this.status = status;
        this.createdAt = createdAt;
    }
    
    

    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public int getBookID() {
        return bookID;
    }

    public void setBookID(int bookID) {
        this.bookID = bookID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}

