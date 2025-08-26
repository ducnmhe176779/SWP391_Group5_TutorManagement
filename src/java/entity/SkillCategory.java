package entity;

import java.sql.Timestamp;

/**
 * Entity class for SkillCategories table
 */
public class SkillCategory {
    private int categoryID;
    private String categoryName;
    private String description;
    private Timestamp createdAt;
    
    // Constructors
    public SkillCategory() {}
    
    public SkillCategory(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public SkillCategory(String categoryName, String description) {
        this.categoryName = categoryName;
        this.description = description;
    }
    
    public SkillCategory(int categoryID, String categoryName, String description) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.description = description;
    }
    
    // Getters and Setters
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
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "SkillCategory{" +
                "categoryID=" + categoryID +
                ", categoryName='" + categoryName + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        SkillCategory that = (SkillCategory) o;
        
        return categoryID == that.categoryID;
    }
    
    @Override
    public int hashCode() {
        return categoryID;
    }
}
