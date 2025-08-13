package entity;

import java.sql.Date;

public class TutorEarning {
    private int id; // Thay EarningID thành ID để khớp với bảng
    private int tutorID;
    private int bookingID;
    private Date bookingDate;
    private double hourlyRate;
    private double totalEarnings;
    private double sytemCommissionRate; // Sửa thành SytemCommissionRate
    private double earningsAfterCommission;

    // Constructors
    public TutorEarning() {}

    public TutorEarning(int id, int tutorID, int bookingID, Date bookingDate, double hourlyRate, 
                       double totalEarnings, double sytemCommissionRate, double earningsAfterCommission) {
        this.id = id;
        this.tutorID = tutorID;
        this.bookingID = bookingID;
        this.bookingDate = bookingDate;
        this.hourlyRate = hourlyRate;
        this.totalEarnings = totalEarnings;
        this.sytemCommissionRate = sytemCommissionRate;
        this.earningsAfterCommission = earningsAfterCommission;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTutorID() { return tutorID; }
    public void setTutorID(int tutorID) { this.tutorID = tutorID; }

    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }

    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }

    public double getHourlyRate() { return hourlyRate; }
    public void setHourlyRate(double hourlyRate) { this.hourlyRate = hourlyRate; }

    public double getTotalEarnings() { return totalEarnings; }
    public void setTotalEarnings(double totalEarnings) { this.totalEarnings = totalEarnings; }

    public double getSytemCommissionRate() { return sytemCommissionRate; }
    public void setSytemCommissionRate(double sytemCommissionRate) { this.sytemCommissionRate = sytemCommissionRate; }

    public double getEarningsAfterCommission() { return earningsAfterCommission; }
    public void setEarningsAfterCommission(double earningsAfterCommission) { this.earningsAfterCommission = earningsAfterCommission; }

    @Override
    public String toString() {
        return "TutorEarning{" +
               "id=" + id +
               ", tutorID=" + tutorID +
               ", bookingID=" + bookingID +
               ", bookingDate=" + bookingDate +
               ", hourlyRate=" + hourlyRate +
               ", totalEarnings=" + totalEarnings +
               ", sytemCommissionRate=" + sytemCommissionRate +
               ", earningsAfterCommission=" + earningsAfterCommission +
               '}';
    }
}