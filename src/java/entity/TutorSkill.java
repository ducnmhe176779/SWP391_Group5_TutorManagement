package entity;

import java.sql.Timestamp;

/**
 * Entity class for TutorSkills table
 */
public class TutorSkill {
    private int skillID;
    private int tutorID;
    private String skillName;
    private String skillLevel; // Beginner, Intermediate, Advanced, Expert
    private int yearsOfExperience;
    private String description;
    private int categoryID;
    private String categoryName;
    private String categoryDescription;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display
    private String tutorName;
    
    // Constructors
    public TutorSkill() {}
    
    public TutorSkill(int tutorID, String skillName, String skillLevel, int yearsOfExperience) {
        this.tutorID = tutorID;
        this.skillName = skillName;
        this.skillLevel = skillLevel;
        this.yearsOfExperience = yearsOfExperience;
    }
    
    public TutorSkill(int tutorID, String skillName, String skillLevel, int yearsOfExperience, 
                     String description, int categoryID) {
        this(tutorID, skillName, skillLevel, yearsOfExperience);
        this.description = description;
        this.categoryID = categoryID;
    }
    
    // Getters and Setters
    public int getSkillID() {
        return skillID;
    }
    
    public void setSkillID(int skillID) {
        this.skillID = skillID;
    }
    
    public int getTutorID() {
        return tutorID;
    }
    
    public void setTutorID(int tutorID) {
        this.tutorID = tutorID;
    }
    
    public String getSkillName() {
        return skillName;
    }
    
    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }
    
    public String getSkillLevel() {
        return skillLevel;
    }
    
    public void setSkillLevel(String skillLevel) {
        this.skillLevel = skillLevel;
    }
    
    public int getYearsOfExperience() {
        return yearsOfExperience;
    }
    
    public void setYearsOfExperience(int yearsOfExperience) {
        this.yearsOfExperience = yearsOfExperience;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getCategoryID() {
        return categoryID;
    }
    
    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getCategoryDescription() {
        return categoryDescription;
    }
    
    public void setCategoryDescription(String categoryDescription) {
        this.categoryDescription = categoryDescription;
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
    
    @Override
    public String toString() {
        return "TutorSkill{" +
                "skillID=" + skillID +
                ", tutorID=" + tutorID +
                ", skillName='" + skillName + '\'' +
                ", skillLevel='" + skillLevel + '\'' +
                ", yearsOfExperience=" + yearsOfExperience +
                ", categoryName='" + categoryName + '\'' +
                '}';
    }
}
