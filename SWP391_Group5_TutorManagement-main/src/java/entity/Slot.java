
package entity;

public class Slot {
    private int slotID;
    private int scheduleID;
    private String status;
    
    private Schedule schedule;
    private Booking booking;
    
    public Slot() {
    }

    public Slot(int slotID, int scheduleID, String status) {
        this.slotID = slotID;
        this.scheduleID = scheduleID;
        this.status = status;
    }

    public int getSlotID() {
        return slotID;
    }

    public void setSlotID(int slotID) {
        this.slotID = slotID;
    }

    public int getScheduleID() {
        return scheduleID;
    }

    public void setScheduleID(int scheduleID) {
        this.scheduleID = scheduleID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }
    
}
