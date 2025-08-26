package model;

import entity.TutorExperience;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO for managing TutorExperience
 */
public class DAOTutorExperience extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOTutorExperience.class.getName());
    
    public DAOTutorExperience() {
        super();
    }
    
    /**
     * Add a single experience for tutor
     */
    public boolean addTutorExperience(TutorExperience experience) {
        String sql = "INSERT INTO TutorExperience (TutorID, JobTitle, Company, Location, StartDate, EndDate, IsCurrent, Description, Achievements, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, experience.getTutorID());
            stmt.setString(2, experience.getJobTitle());
            stmt.setString(3, experience.getCompany());
            stmt.setString(4, experience.getLocation());
            stmt.setDate(5, experience.getStartDate());
            
            if (experience.getEndDate() != null) {
                stmt.setDate(6, experience.getEndDate());
            } else {
                stmt.setNull(6, Types.DATE);
            }
            
            stmt.setBoolean(7, experience.isCurrent());
            stmt.setString(8, experience.getDescription());
            stmt.setString(9, experience.getAchievements());
            
            int result = stmt.executeUpdate();
            System.out.println("DEBUG: Added experience '" + experience.getJobTitle() + "' for TutorID " + experience.getTutorID());
            return result > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding tutor experience", e);
            return false;
        }
    }
    
    /**
     * Add multiple experiences for tutor (batch operation)
     */
    public boolean addTutorExperiences(int tutorID, List<TutorExperience> experiences) {
        if (experiences == null || experiences.isEmpty()) {
            System.out.println("DEBUG: No experiences to add for TutorID " + tutorID);
            return true; // Nothing to add
        }
        
        String sql = "INSERT INTO TutorExperience (TutorID, JobTitle, Company, Location, StartDate, EndDate, IsCurrent, Description, Achievements, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false); // Start transaction
            
            System.out.println("DEBUG: Executing TutorExperience batch insert for TutorID " + tutorID + " with " + experiences.size() + " experiences");
            
            for (TutorExperience experience : experiences) {
                stmt.setInt(1, tutorID);
                stmt.setString(2, experience.getJobTitle());
                stmt.setString(3, experience.getCompany());
                stmt.setString(4, experience.getLocation());
                stmt.setDate(5, experience.getStartDate());
                
                if (experience.getEndDate() != null) {
                    stmt.setDate(6, experience.getEndDate());
                } else {
                    stmt.setNull(6, Types.DATE);
                }
                
                stmt.setBoolean(7, experience.isCurrent());
                stmt.setString(8, experience.getDescription());
                stmt.setString(9, experience.getAchievements());
                
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            conn.commit();
            
            System.out.println("DEBUG: Added " + results.length + " experiences for TutorID " + tutorID);
            return true;
            
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
            }
            System.out.println("ERROR: SQL Exception in addTutorExperiences: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error adding tutor experiences batch", e);
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
     * Get all experiences for a specific tutor
     */
    public List<TutorExperience> getExperiencesByTutorID(int tutorID) {
        List<TutorExperience> experiences = new ArrayList<>();
        String sql = "SELECT * FROM vw_TutorExperienceDetails WHERE TutorID = ? ORDER BY StartDate DESC";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tutorID);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                TutorExperience experience = new TutorExperience();
                experience.setExperienceID(rs.getInt("ExperienceID"));
                experience.setTutorID(rs.getInt("TutorID"));
                experience.setJobTitle(rs.getString("JobTitle"));
                experience.setCompany(rs.getString("Company"));
                experience.setLocation(rs.getString("Location"));
                experience.setStartDate(rs.getDate("StartDate"));
                experience.setEndDate(rs.getDate("EndDate"));
                experience.setCurrent(rs.getBoolean("IsCurrent"));
                experience.setDescription(rs.getString("Description"));
                experience.setAchievements(rs.getString("Achievements"));
                experience.setTutorName(rs.getString("TutorName"));
                experience.setDuration(rs.getString("Duration"));
                experience.setCreatedAt(rs.getTimestamp("CreatedAt"));
                experience.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                
                experiences.add(experience);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting experiences for tutor " + tutorID, e);
        }
        
        return experiences;
    }
    
    /**
     * Update tutor experience
     */
    public boolean updateTutorExperience(TutorExperience experience) {
        String sql = "UPDATE TutorExperience SET JobTitle = ?, Company = ?, Location = ?, StartDate = ?, EndDate = ?, IsCurrent = ?, Description = ?, Achievements = ?, UpdatedAt = GETDATE() WHERE ExperienceID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, experience.getJobTitle());
            stmt.setString(2, experience.getCompany());
            stmt.setString(3, experience.getLocation());
            stmt.setDate(4, experience.getStartDate());
            
            if (experience.getEndDate() != null) {
                stmt.setDate(5, experience.getEndDate());
            } else {
                stmt.setNull(5, Types.DATE);
            }
            
            stmt.setBoolean(6, experience.isCurrent());
            stmt.setString(7, experience.getDescription());
            stmt.setString(8, experience.getAchievements());
            stmt.setInt(9, experience.getExperienceID());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating tutor experience", e);
            return false;
        }
    }
    
    /**
     * Delete tutor experience
     */
    public boolean deleteTutorExperience(int experienceID) {
        String sql = "DELETE FROM TutorExperience WHERE ExperienceID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, experienceID);
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting tutor experience", e);
            return false;
        }
    }
    
    /**
     * Get current experiences for tutor (IsCurrent = true)
     */
    public List<TutorExperience> getCurrentExperiences(int tutorID) {
        List<TutorExperience> experiences = new ArrayList<>();
        String sql = "SELECT * FROM vw_TutorExperienceDetails WHERE TutorID = ? AND IsCurrent = 1 ORDER BY StartDate DESC";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tutorID);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                TutorExperience experience = new TutorExperience();
                experience.setExperienceID(rs.getInt("ExperienceID"));
                experience.setTutorID(rs.getInt("TutorID"));
                experience.setJobTitle(rs.getString("JobTitle"));
                experience.setCompany(rs.getString("Company"));
                experience.setLocation(rs.getString("Location"));
                experience.setStartDate(rs.getDate("StartDate"));
                experience.setEndDate(rs.getDate("EndDate"));
                experience.setCurrent(rs.getBoolean("IsCurrent"));
                experience.setDescription(rs.getString("Description"));
                experience.setAchievements(rs.getString("Achievements"));
                experience.setTutorName(rs.getString("TutorName"));
                experience.setDuration(rs.getString("Duration"));
                
                experiences.add(experience);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting current experiences for tutor " + tutorID, e);
        }
        
        return experiences;
    }
    
    /**
     * Get total years of experience for a tutor
     */
    public int getTotalYearsOfExperience(int tutorID) {
        String sql = "SELECT SUM(CASE WHEN IsCurrent = 1 THEN DATEDIFF(YEAR, StartDate, GETDATE()) WHEN EndDate IS NOT NULL THEN DATEDIFF(YEAR, StartDate, EndDate) ELSE 0 END) as TotalYears FROM TutorExperience WHERE TutorID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tutorID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("TotalYears");
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total years of experience for tutor " + tutorID, e);
        }
        
        return 0;
    }
    
    /**
     * Search tutors by experience criteria
     */
    public List<Object[]> filterTutorsByExperience(String jobTitle, String company, int minYearsExperience) {
        List<Object[]> results = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DISTINCT u.UserID, u.FullName, u.Email, u.Phone, u.Avatar, ");
        sql.append("t.TutorID, t.Rating, t.Price, cv.Education, cv.Status as CVStatus ");
        sql.append("FROM Users u ");
        sql.append("INNER JOIN CV cv ON u.UserID = cv.UserID ");
        sql.append("INNER JOIN Tutor t ON cv.CVID = t.CVID ");
        sql.append("INNER JOIN TutorExperience te ON t.TutorID = te.TutorID ");
        sql.append("WHERE cv.Status = 'Approved' ");
        
        List<Object> params = new ArrayList<>();
        
        if (jobTitle != null && !jobTitle.trim().isEmpty()) {
            sql.append("AND te.JobTitle LIKE ? ");
            params.add("%" + jobTitle + "%");
        }
        
        if (company != null && !company.trim().isEmpty()) {
            sql.append("AND te.Company LIKE ? ");
            params.add("%" + company + "%");
        }
        
        if (minYearsExperience > 0) {
            sql.append("AND (SELECT SUM(CASE WHEN te2.IsCurrent = 1 THEN DATEDIFF(YEAR, te2.StartDate, GETDATE()) WHEN te2.EndDate IS NOT NULL THEN DATEDIFF(YEAR, te2.StartDate, te2.EndDate) ELSE 0 END) FROM TutorExperience te2 WHERE te2.TutorID = t.TutorID) >= ? ");
            params.add(minYearsExperience);
        }
        
        sql.append("ORDER BY t.Rating DESC");
        
        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Object[] row = new Object[10];
                row[0] = rs.getInt("UserID");
                row[1] = rs.getString("FullName");
                row[2] = rs.getString("Email");
                row[3] = rs.getString("Phone");
                row[4] = rs.getString("Avatar");
                row[5] = rs.getInt("TutorID");
                row[6] = rs.getFloat("Rating");
                row[7] = rs.getFloat("Price");
                row[8] = rs.getString("Education");
                row[9] = rs.getString("CVStatus");
                
                results.add(row);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error filtering tutors by experience", e);
        }
        
        return results;
    }
}

