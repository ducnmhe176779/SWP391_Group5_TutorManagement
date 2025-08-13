
package entity;
import java.util.Date;

public class Schedule {
    private int scheduleID;
    private int tutorID;    
    private Date startTime;
    private Date endTime;
    private boolean isBooked;
    private int subjectId;
    private String status;
    
    private Tutor tutor; 
    private Subject subject;
    private Slot slot;

    public Schedule() {
    }

    public Schedule(int scheduleID, int tutorID, Date startTime, Date endTime, boolean isBooked, int subjectId) {
        this.scheduleID = scheduleID;
        this.tutorID = tutorID;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isBooked = isBooked;
        this.subjectId = subjectId;
    }

    public int getScheduleID() {
        return scheduleID;
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

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public boolean getIsBooked() {
        return isBooked;
    }

    public void setIsBooked(boolean isBooked) {
        this.isBooked = isBooked;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public Tutor getTutor() {
        return tutor;
    }

    public void setTutor(Tutor tutor) {
        this.tutor = tutor;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public Slot getSlot() {
        return slot;
    }

    public void setSlot(Slot slot) {
        this.slot = slot;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
}
