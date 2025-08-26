package model;

import entity.TutorSkill;
import entity.SkillCategory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO for managing TutorSkills
 */
public class DAOTutorSkill extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOTutorSkill.class.getName());
    
    public DAOTutorSkill() {
        super();
    }
    
    /**
     * Add a single skill for tutor
     */
    public boolean addTutorSkill(TutorSkill skill) {
        String sql = "INSERT INTO TutorSkills (TutorID, SkillName, SkillLevel, YearsOfExperience, Description, CategoryID, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, skill.getTutorID());
            stmt.setString(2, skill.getSkillName());
            stmt.setString(3, skill.getSkillLevel());
            stmt.setInt(4, skill.getYearsOfExperience());
            stmt.setString(5, skill.getDescription());
            
            if (skill.getCategoryID() > 0) {
                stmt.setInt(6, skill.getCategoryID());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            
            int result = stmt.executeUpdate();
            System.out.println("DEBUG: Added skill '" + skill.getSkillName() + "' for TutorID " + skill.getTutorID());
            return result > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding tutor skill", e);
            return false;
        }
    }
    
    /**
     * Add multiple skills for tutor (batch operation)
     */
    public boolean addTutorSkills(int tutorID, List<TutorSkill> skills) {
        if (skills == null || skills.isEmpty()) {
            System.out.println("DEBUG: No skills to add for TutorID " + tutorID);
            return true; // Nothing to add
        }
        
        String sql = "INSERT INTO TutorSkills (TutorID, SkillName, SkillLevel, YearsOfExperience, Description, CategoryID, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false); // Start transaction
            
            System.out.println("DEBUG: Executing TutorSkills batch insert for TutorID " + tutorID + " with " + skills.size() + " skills");
            
            for (TutorSkill skill : skills) {
                stmt.setInt(1, tutorID);
                stmt.setString(2, skill.getSkillName());
                stmt.setString(3, skill.getSkillLevel());
                stmt.setInt(4, skill.getYearsOfExperience());
                stmt.setString(5, skill.getDescription());
                
                if (skill.getCategoryID() > 0) {
                    stmt.setInt(6, skill.getCategoryID());
                } else {
                    stmt.setNull(6, Types.INTEGER);
                }
                
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            conn.commit();
            
            System.out.println("DEBUG: Added " + results.length + " skills for TutorID " + tutorID);
            return true;
            
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
            }
            System.out.println("ERROR: SQL Exception in addTutorSkills: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error adding tutor skills batch", e);
            return false;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error resetting auto-commit", e);
            }
        }
    }
    
    /**
     * Get all skills for a specific tutor
     */
    public List<TutorSkill> getSkillsByTutorID(int tutorID) {
        List<TutorSkill> skills = new ArrayList<>();
        String sql = "SELECT * FROM vw_TutorSkillsWithCategory WHERE TutorID = ? ORDER BY SkillName";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tutorID);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                TutorSkill skill = new TutorSkill();
                skill.setSkillID(rs.getInt("SkillID"));
                skill.setTutorID(rs.getInt("TutorID"));
                skill.setSkillName(rs.getString("SkillName"));
                skill.setSkillLevel(rs.getString("SkillLevel"));
                skill.setYearsOfExperience(rs.getInt("YearsOfExperience"));
                skill.setDescription(rs.getString("SkillDescription"));
                skill.setCategoryID(rs.getInt("CategoryID"));
                skill.setCategoryName(rs.getString("CategoryName"));
                skill.setCategoryDescription(rs.getString("CategoryDescription"));
                skill.setTutorName(rs.getString("TutorName"));
                skill.setCreatedAt(rs.getTimestamp("CreatedAt"));
                skill.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                
                skills.add(skill);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting skills for tutor " + tutorID, e);
        }
        
        return skills;
    }
    
    /**
     * Get all skill categories
     */
    public List<SkillCategory> getAllSkillCategories() {
        List<SkillCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM SkillCategories ORDER BY CategoryName";
        
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                SkillCategory category = new SkillCategory();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                category.setDescription(rs.getString("Description"));
                category.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                categories.add(category);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting skill categories", e);
        }
        
        return categories;
    }
    
    /**
     * Update tutor skill
     */
    public boolean updateTutorSkill(TutorSkill skill) {
        String sql = "UPDATE TutorSkills SET SkillName = ?, SkillLevel = ?, YearsOfExperience = ?, Description = ?, CategoryID = ?, UpdatedAt = GETDATE() WHERE SkillID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, skill.getSkillName());
            stmt.setString(2, skill.getSkillLevel());
            stmt.setInt(3, skill.getYearsOfExperience());
            stmt.setString(4, skill.getDescription());
            
            if (skill.getCategoryID() > 0) {
                stmt.setInt(5, skill.getCategoryID());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }
            
            stmt.setInt(6, skill.getSkillID());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating tutor skill", e);
            return false;
        }
    }
    
    /**
     * Delete tutor skill
     */
    public boolean deleteTutorSkill(int skillID) {
        String sql = "DELETE FROM TutorSkills WHERE SkillID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, skillID);
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting tutor skill", e);
            return false;
        }
    }
    
    /**
     * Search tutors by skills using stored procedure
     */
    public List<Object[]> filterTutorsBySkills(String skillNames, String minSkillLevel, Integer categoryID, int minYearsExperience) {
        List<Object[]> results = new ArrayList<>();
        String sql = "EXEC sp_FilterTutorsBySkills ?, ?, ?, ?";
        
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            
            if (skillNames != null && !skillNames.trim().isEmpty()) {
                stmt.setString(1, skillNames);
            } else {
                stmt.setNull(1, Types.NVARCHAR);
            }
            
            if (minSkillLevel != null && !minSkillLevel.trim().isEmpty()) {
                stmt.setString(2, minSkillLevel);
            } else {
                stmt.setNull(2, Types.NVARCHAR);
            }
            
            if (categoryID != null && categoryID > 0) {
                stmt.setInt(3, categoryID);
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            
            stmt.setInt(4, minYearsExperience);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Object[] row = new Object[11];
                row[0] = rs.getInt("UserID");
                row[1] = rs.getString("FullName");
                row[2] = rs.getString("Email");
                row[3] = rs.getString("Phone");
                row[4] = rs.getString("Avatar");
                row[5] = rs.getInt("TutorID");
                row[6] = rs.getFloat("Rating");
                row[7] = rs.getFloat("Price");
                row[8] = rs.getString("Education");
                row[9] = rs.getString("Skills");
                row[10] = rs.getInt("TotalSkills");
                
                results.add(row);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error filtering tutors by skills", e);
        }
        
        return results;
    }
    
    /**
     * Get popular skills (most used by tutors)
     */
    public List<String> getPopularSkills(int limit) {
        List<String> skills = new ArrayList<>();
        String sql = "SELECT TOP (?) SkillName, COUNT(*) as SkillCount FROM TutorSkills GROUP BY SkillName ORDER BY SkillCount DESC";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                skills.add(rs.getString("SkillName"));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting popular skills", e);
        }
        
        return skills;
    }
}

