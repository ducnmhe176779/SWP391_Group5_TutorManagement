package entity;

import java.sql.Timestamp;

public class MonthlyWithdrawalRequest {
    private int requestID;
    private int tutorID;
    private String month;
    private double totalEarningsAfterCommission;
    private String withdrawStatus;
    private String content;
    private Timestamp requestDate;
    private int adminID;
    private String tutorName;

    // Constructors
    public MonthlyWithdrawalRequest() {}

    public MonthlyWithdrawalRequest(int requestID, int tutorID, String month, double totalEarningsAfterCommission, 
                                    String withdrawStatus, String content, Timestamp requestDate, int adminID) {
        this.requestID = requestID;
        this.tutorID = tutorID;
        this.month = month;
        this.totalEarningsAfterCommission = totalEarningsAfterCommission;
        this.withdrawStatus = withdrawStatus;
        this.content = content;
        this.requestDate = requestDate;
        this.adminID = adminID;
    }

    public MonthlyWithdrawalRequest(int requestID, int tutorID, String month, double totalEarningsAfterCommission, String withdrawStatus, String content, Timestamp requestDate, int adminID, String tutorName) {
        this.requestID = requestID;
        this.tutorID = tutorID;
        this.month = month;
        this.totalEarningsAfterCommission = totalEarningsAfterCommission;
        this.withdrawStatus = withdrawStatus;
        this.content = content;
        this.requestDate = requestDate;
        this.adminID = adminID;
        this.tutorName = tutorName;
    }

    public String getTutorName() {
        return tutorName;
    }

    public void setTutorName(String tutorName) {
        this.tutorName = tutorName;
    }
    

    // Getters and Setters
    public int getRequestID() { return requestID; }
    public void setRequestID(int requestID) { this.requestID = requestID; }

    public int getTutorID() { return tutorID; }
    public void setTutorID(int tutorID) { this.tutorID = tutorID; }

    public String getMonth() { return month; }
    public void setMonth(String month) { this.month = month; }

    public double getTotalEarningsAfterCommission() { return totalEarningsAfterCommission; }
    public void setTotalEarningsAfterCommission(double totalEarningsAfterCommission) { this.totalEarningsAfterCommission = totalEarningsAfterCommission; }

    public String getWithdrawStatus() { return withdrawStatus; }
    public void setWithdrawStatus(String withdrawStatus) { this.withdrawStatus = withdrawStatus; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Timestamp getRequestDate() { return requestDate; }
    public void setRequestDate(Timestamp requestDate) { this.requestDate = requestDate; }

    public int getAdminID() { return adminID; }
    public void setAdminID(int adminID) { this.adminID = adminID; }

    @Override
    public String toString() {
        return "MonthlyWithdrawalRequest{" +
               "requestID=" + requestID +
               ", tutorID=" + tutorID +
               ", month='" + month + '\'' +
               ", totalEarningsAfterCommission=" + totalEarningsAfterCommission +
               ", withdrawStatus='" + withdrawStatus + '\'' +
               ", content='" + content + '\'' +
               ", requestDate=" + requestDate +
               ", adminID=" + adminID +
               '}';
    }
}