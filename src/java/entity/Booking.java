package entity;

import java.sql.Date;

public class Booking {
    private int bookingID;
    private int studentID;
    private String studentName; // Thêm để lưu FullName của học sinh
    private int tutorID;
    private String tutorName;   // Thêm để lưu FullName của gia sư
    private int slotID;
    private Date bookingDate;
    private String status;
    private int subjectID;

    private Slot slot;
    private Subject subject;
    private Tutor tutor;
    private User user;
    
    public Booking() {
    }

    public Booking(int bookingID, int studentID, String studentName, int tutorID, String tutorName, int slotID, Date bookingDate, String status, int subjectID) {
        this.bookingID = bookingID;
        this.studentID = studentID;
        this.studentName = studentName;
        this.tutorID = tutorID;
        this.tutorName = tutorName;
        this.slotID = slotID;
        this.bookingDate = bookingDate;
        this.status = status;
        this.subjectID = subjectID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getStudentID() {
        return studentID;
    }

    public void setStudentID(int studentID) {
        this.studentID = studentID;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public int getTutorID() {
        return tutorID;
    }

    public void setTutorID(int tutorID) {
        this.tutorID = tutorID;
    }

    public String getTutorName() {
        return tutorName;
    }

    public void setTutorName(String tutorName) {
        this.tutorName = tutorName;
    }

    public int getSlotID() {
        return slotID;
    }

    public void setSlotID(int slotID) {
        this.slotID = slotID;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getSubjectID() {
        return subjectID;
    }

    public void setSubjectID(int subjectID) {
        this.subjectID = subjectID;
    }

    public Slot getSlot() {
        return slot;
    }

    public void setSlot(Slot slot) {
        this.slot = slot;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public Tutor getTutor() {
        return tutor;
    }

    public void setTutor(Tutor tutor) {
        this.tutor = tutor;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}