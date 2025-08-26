package entity;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Entity class for TutorExperience table
 */
public class TutorExperience {
    private int experienceID;
    private int tutorID;
    private String jobTitle;
    private String company;
    private String location;
    private Date startDate;
    private Date endDate;
    private boolean isCurrent;
    private String description;
    private String achievements;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display
    private String tutorName;
    private String duration;
    
    // Constructors
    public TutorExperience() {}
    
    public TutorExperience(int tutorID, String jobTitle, Date startDate) {
        this.tutorID = tutorID;
        this.jobTitle = jobTitle;
        this.startDate = startDate;
    }
    
    public TutorExperience(int tutorID, String jobTitle, String company, String location, 
                          Date startDate, Date endDate, boolean isCurrent) {
        this(tutorID, jobTitle, startDate);
        this.company = company;
        this.location = location;
        this.endDate = endDate;
        this.isCurrent = isCurrent;
    }
    
    // Getters and Setters
    public int getExperienceID() {
        return experienceID;
    }
    
    public void setExperienceID(int experienceID) {
        this.experienceID = experienceID;
    }
    
    public int getTutorID() {
        return tutorID;
    }
    
    public void setTutorID(int tutorID) {
        this.tutorID = tutorID;
    }
    
    public String getJobTitle() {
        return jobTitle;
    }
    
    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }
    
    public String getCompany() {
        return company;
    }
    
    public void setCompany(String company) {
        this.company = company;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public boolean isCurrent() {
        return isCurrent;
    }
    
    public void setCurrent(boolean current) {
        isCurrent = current;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getAchievements() {
        return achievements;
    }
    
    public void setAchievements(String achievements) {
        this.achievements = achievements;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getTutorName() {
        return tutorName;
    }
    
    public void setTutorName(String tutorName) {
        this.tutorName = tutorName;
    }
    
    public String getDuration() {
        return duration;
    }
    
    public void setDuration(String duration) {
        this.duration = duration;
    }
    
    @Override
    public String toString() {
        return "TutorExperience{" +
                "experienceID=" + experienceID +
                ", tutorID=" + tutorID +
                ", jobTitle='" + jobTitle + '\'' +
                ", company='" + company + '\'' +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", isCurrent=" + isCurrent +
                '}';
    }
}
