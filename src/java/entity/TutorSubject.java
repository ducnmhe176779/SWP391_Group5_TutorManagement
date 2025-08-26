package entity;

/**
 * Entity class for TutorSubject - represents a tutor's ability to teach a specific subject
 * with their own pricing and description for that subject
 */
public class TutorSubject {
    private int tutorSubjectID;
    private int tutorID;
    private int subjectID;
    private String description;
    private float pricePerHour;
    private String status; // "Active", "Inactive", "Pending"
    private String subjectName; // For display purposes
    
    // Default constructor
    public TutorSubject() {
    }
    
    // Constructor for creating new tutor subject
    public TutorSubject(int tutorID, int subjectID, String description, float pricePerHour) {
        this.tutorID = tutorID;
        this.subjectID = subjectID;
        this.description = description;
        this.pricePerHour = pricePerHour;
        this.status = "Active";
    }
    
    // Constructor for simple tutor subject (only TutorID and SubjectID)
    public TutorSubject(int tutorID, int subjectID) {
        this.tutorID = tutorID;
        this.subjectID = subjectID;
        this.status = "Active";
    }
    
    // Full constructor
    public TutorSubject(int tutorSubjectID, int tutorID, int subjectID, String description, 
                       float pricePerHour, String status) {
        this.tutorSubjectID = tutorSubjectID;
        this.tutorID = tutorID;
        this.subjectID = subjectID;
        this.description = description;
        this.pricePerHour = pricePerHour;
        this.status = status;
    }
    
    // Constructor for display purposes
    public TutorSubject(int tutorSubjectID, int tutorID, int subjectID, String description, 
                       float pricePerHour, String status, String subjectName) {
        this.tutorSubjectID = tutorSubjectID;
        this.tutorID = tutorID;
        this.subjectID = subjectID;
        this.description = description;
        this.pricePerHour = pricePerHour;
        this.status = status;
        this.subjectName = subjectName;
    }
    
    // Getters and Setters
    public int getTutorSubjectID() {
        return tutorSubjectID;
    }
    
    public void setTutorSubjectID(int tutorSubjectID) {
        this.tutorSubjectID = tutorSubjectID;
    }
    
    public int getTutorID() {
        return tutorID;
    }
    
    public void setTutorID(int tutorID) {
        this.tutorID = tutorID;
    }
    
    public int getSubjectID() {
        return subjectID;
    }
    
    public void setSubjectID(int subjectID) {
        this.subjectID = subjectID;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public float getPricePerHour() {
        return pricePerHour;
    }
    
    public void setPricePerHour(float pricePerHour) {
        this.pricePerHour = pricePerHour;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getSubjectName() {
        return subjectName;
    }
    
    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
    
    @Override
    public String toString() {
        return "TutorSubject{" +
                "tutorSubjectID=" + tutorSubjectID +
                ", tutorID=" + tutorID +
                ", subjectID=" + subjectID +
                ", description='" + description + '\'' +
                ", pricePerHour=" + pricePerHour +
                ", status='" + status + '\'' +
                ", subjectName='" + subjectName + '\'' +
                '}';
    }
}
