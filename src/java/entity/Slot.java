
package entity;

import java.sql.Timestamp;

public class Slot {
    private int scheduleID;
    private int slotID;
    private int tutorID;
    private Timestamp startTime;
    private Timestamp endTime;
    private int subjectID;
    private String status;
    private Schedule schedule;
    // Constructors
    public Slot() {
    }
    
    public Slot(int slotID, int tutorID, Timestamp startTime, Timestamp endTime, int subjectID, String status) {
        this.slotID = slotID;
        this.tutorID = tutorID;
        this.startTime = startTime;
        this.endTime = endTime;
        this.subjectID = subjectID;
        this.status = status;
    }
    
    // Getters and Setters
    public int getSlotID() {
        return slotID;
    }
    
    public void setSlotID(int slotID) {
        this.slotID = slotID;
    }
    
    public int getTutorID() {
        return tutorID;
    }
    
    public void setTutorID(int tutorID) {
        this.tutorID = tutorID;
    }
    
    public Timestamp getStartTime() {
        return startTime;
    }
    
    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }
    
    public Timestamp getEndTime() {
        return endTime;
    }
    
    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
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
        public void setScheduleID(int scheduleID) {
        this.scheduleID = scheduleID;
    }
    public int getScheduleID() {
        return this.scheduleID;
    }
        public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }
    @Override
    public String toString() {
        return "Slot{" +
                "slotID=" + slotID +
                ", tutorID=" + tutorID +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", subjectID=" + subjectID +
                ", status='" + status + '\'' +
                '}';
    }
}
