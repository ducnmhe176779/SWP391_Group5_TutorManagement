package entity;
import java.time.LocalDateTime;


public class ScheduleTemp {
    private int scheduleID;
    private int tutorID;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private boolean isBooked;
    private int subjectID;
    private String tutorName;
    private String subjectName;
    // Getters and Setters
    public int getScheduleID() {
        return scheduleID;
    }

    public ScheduleTemp() {
    }
    

    public ScheduleTemp(int scheduleID, int tutorID, LocalDateTime startTime, LocalDateTime endTime, boolean isBooked, int subjectID, String tutorName, String subjectName) {
        this.scheduleID = scheduleID;
        this.tutorID = tutorID;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isBooked = isBooked;
        this.subjectID = subjectID;
        this.tutorName = tutorName;
        this.subjectName = subjectName;
    }

    public boolean isIsBooked() {
        return isBooked;
    }

    public void setIsBooked(boolean isBooked) {
        this.isBooked = isBooked;
    }

    public String getTutorName() {
        return tutorName;
    }

    public void setTutorName(String tutorName) {
        this.tutorName = tutorName;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
    

    public void setScheduleID(int scheduleID) {
        this.scheduleID = scheduleID;
    }

    public int getTutorID() {
        return tutorID;
    }

    public void setTutorID(int tutorID) {
        this.tutorID = tutorID;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public boolean isBooked() {
        return isBooked;
    }

    public void setBooked(boolean isBooked) {
        this.isBooked = isBooked;
    }

    public int getSubjectID() {
        return subjectID;
    }

    public void setSubjectID(int subjectID) {
        this.subjectID = subjectID;
    }

    @Override
    public String toString() {
        return "Schedule{" + "scheduleID=" + scheduleID + ", tutorID=" + tutorID + ", startTime=" + startTime + ", endTime=" + endTime + ", isBooked=" + isBooked + ", subjectID=" + subjectID + '}';
    }
    
}


