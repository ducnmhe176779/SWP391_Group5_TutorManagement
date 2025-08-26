package entity;

import java.sql.Timestamp;

public class CVAssignment {
    private int assignmentID;
    private int cvID;
    private int assignedStaffID;
    private Timestamp assignedDate;
    private String status;
    private int priority;
    private Timestamp reviewDate;
    private String reviewNotes;
    
    // Additional fields for display purposes
    private String tutorName;
    private String tutorEmail;
    private String tutorPhone;
    private String staffName;
    private String staffEmail;
    private String assignmentStatus;
    private String education;
    private String experience;
    private String skill;
    private float price;
    
    // Additional CV fields (nếu cần thêm sau)
    private String certificates;
    private String cvStatus;
    private int subjectId;
    private String description;
    private Timestamp cvCreatedDate;
    private Timestamp cvUpdatedDate;
    private String subjectName;
    private String subjectDescription;
    
    // Additional User fields (nếu cần thêm sau)
    private Timestamp dateOfBirth;
    private String gender;
    private String address;
    private String avatar;
    
    // Constructors
    public CVAssignment() {}
    
    public CVAssignment(int assignmentID, int cvID, int assignedStaffID, Timestamp assignedDate, 
                       String status, int priority, Timestamp reviewDate, String reviewNotes) {
        this.assignmentID = assignmentID;
        this.cvID = cvID;
        this.assignedStaffID = assignedStaffID;
        this.assignedDate = assignedDate;
        this.status = status;
        this.priority = priority;
        this.reviewDate = reviewDate;
        this.reviewNotes = reviewNotes;
    }
    
    // Getters and Setters
    public int getAssignmentID() {
        return assignmentID;
    }
    
    public void setAssignmentID(int assignmentID) {
        this.assignmentID = assignmentID;
    }
    
    public int getCvID() {
        return cvID;
    }
    
    public void setCvID(int cvID) {
        this.cvID = cvID;
    }
    
    public int getAssignedStaffID() {
        return assignedStaffID;
    }
    
    public void setAssignedStaffID(int assignedStaffID) {
        this.assignedStaffID = assignedStaffID;
    }
    
    public Timestamp getAssignedDate() {
        return assignedDate;
    }
    
    public void setAssignedDate(Timestamp assignedDate) {
        this.assignedDate = assignedDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getPriority() {
        return priority;
    }
    
    public void setPriority(int priority) {
        this.priority = priority;
    }
    
    public Timestamp getReviewDate() {
        return reviewDate;
    }
    
    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }
    
    public String getReviewNotes() {
        return reviewNotes;
    }
    
    public void setReviewNotes(String reviewNotes) {
        this.reviewNotes = reviewNotes;
    }
    
    // Additional getters and setters for display fields
    public String getTutorName() {
        return tutorName;
    }
    
    public void setTutorName(String tutorName) {
        this.tutorName = tutorName;
    }
    
    public String getTutorEmail() {
        return tutorEmail;
    }
    
    public void setTutorEmail(String tutorEmail) {
        this.tutorEmail = tutorEmail;
    }
    
    public String getTutorPhone() {
        return tutorPhone;
    }
    
    public void setTutorPhone(String tutorPhone) {
        this.tutorPhone = tutorPhone;
    }
    
    public String getStaffName() {
        return staffName;
    }
    
    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }
    
    public String getStaffEmail() {
        return staffEmail;
    }
    
    public void setStaffEmail(String staffEmail) {
        this.staffEmail = staffEmail;
    }
    
    public String getAssignmentStatus() {
        return assignmentStatus;
    }
    
    public void setAssignmentStatus(String assignmentStatus) {
        this.assignmentStatus = assignmentStatus;
    }
    
    public String getEducation() {
        return education;
    }
    
    public void setEducation(String education) {
        this.education = education;
    }
    
    public String getExperience() {
        return experience;
    }
    
    public void setExperience(String experience) {
        this.experience = experience;
    }
    
    public String getSkill() {
        return skill;
    }
    
    public void setSkill(String skill) {
        this.skill = skill;
    }
    
    public float getPrice() {
        return price;
    }
    
    public void setPrice(float price) {
        this.price = price;
    }
    
    // Additional CV getters and setters
    public String getCertificates() {
        return certificates;
    }
    
    public void setCertificates(String certificates) {
        this.certificates = certificates;
    }
    
    public String getCvStatus() {
        return cvStatus;
    }
    
    public void setCvStatus(String cvStatus) {
        this.cvStatus = cvStatus;
    }
    
    public int getSubjectId() {
        return subjectId;
    }
    
    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Timestamp getCvCreatedDate() {
        return cvCreatedDate;
    }
    
    public void setCvCreatedDate(Timestamp cvCreatedDate) {
        this.cvCreatedDate = cvCreatedDate;
    }
    
    public Timestamp getCvUpdatedDate() {
        return cvUpdatedDate;
    }
    
    public void setCvUpdatedDate(Timestamp cvUpdatedDate) {
        this.cvUpdatedDate = cvUpdatedDate;
    }
    
    public String getSubjectName() {
        return subjectName;
    }
    
    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
    
    public String getSubjectDescription() {
        return subjectDescription;
    }
    
    public void setSubjectDescription(String subjectDescription) {
        this.subjectDescription = subjectDescription;
    }
    
    // Additional User getters and setters
    public Timestamp getDateOfBirth() {
        return dateOfBirth;
    }
    
    public void setDateOfBirth(Timestamp dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getAvatar() {
        return avatar;
    }
    
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
    
    @Override
    public String toString() {
        return "CVAssignment{" +
                "assignmentID=" + assignmentID +
                ", cvID=" + cvID +
                ", assignedStaffID=" + assignedStaffID +
                ", assignedDate=" + assignedDate +
                ", status='" + status + '\'' +
                ", priority=" + priority +
                ", reviewDate=" + reviewDate +
                ", reviewNotes='" + reviewNotes + '\'' +
                '}';
    }
}
