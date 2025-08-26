/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import entity.TutorSubject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO for TutorSubject - Enhanced for filtering and multiple subject support
 * @author dvdung
 */
public class DAOTutorSubject extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOTutorSubject.class.getName());
    
    /**
     * Add a single tutor subject relationship
     */
    public boolean addTutorSubject(int tutorId, int subjectId) {
        String sql = "INSERT INTO TutorSubject (TutorID, SubjectID) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tutorId);
            pstmt.setInt(2, subjectId);          
            
            System.out.println("DEBUG: Executing TutorSubject SQL: " + sql);
            System.out.println("DEBUG: Parameters - TutorID: " + tutorId + ", SubjectID: " + subjectId);
            
            // Kiểm tra xem TutorID có tồn tại trong bảng Tutor không
            String checkTutorSql = "SELECT COUNT(*) FROM Tutor WHERE TutorID = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkTutorSql)) {
                checkPs.setInt(1, tutorId);
                ResultSet rs = checkPs.executeQuery();
                if (rs.next()) {
                    int tutorCount = rs.getInt(1);
                    System.out.println("DEBUG: Tutor count for TutorID " + tutorId + ": " + tutorCount);
                }
            }
            
            // Kiểm tra xem SubjectID có tồn tại trong bảng Subject không
            String checkSubjectSql = "SELECT COUNT(*) FROM Subject WHERE SubjectID = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSubjectSql)) {
                checkPs.setInt(1, subjectId);
                ResultSet rs = checkPs.executeQuery();
                if (rs.next()) {
                    int subjectCount = rs.getInt(1);
                    System.out.println("DEBUG: Subject count for SubjectID " + subjectId + ": " + subjectCount);
                }
            }
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("DEBUG: TutorSubject SQL execution result: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("ERROR: SQL Exception in addTutorSubject: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error adding tutor subject", e);
            return false;
        }
    }
    
    /**
     * Add multiple subjects for a tutor
     */
    public boolean addTutorSubjects(int tutorId, List<Integer> subjectIds) {
        String sql = "INSERT INTO TutorSubject (TutorID, SubjectID) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            
            for (Integer subjectId : subjectIds) {
                pstmt.setInt(1, tutorId);
                pstmt.setInt(2, subjectId);
                pstmt.addBatch();
            }
            
            int[] results = pstmt.executeBatch();
            conn.commit();
            conn.setAutoCommit(true);
            
            // Check if all inserts were successful
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
            
        } catch (SQLException e) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (SQLException rollbackEx) {
                LOGGER.log(Level.SEVERE, "Error during rollback", rollbackEx);
            }
            LOGGER.log(Level.SEVERE, "Error adding multiple tutor subjects", e);
            return false;
        }
    }
    
    /**
     * Get all subjects taught by a specific tutor
     */
    public List<TutorSubject> getSubjectsByTutorId(int tutorId) {
        List<TutorSubject> tutorSubjects = new ArrayList<>();
        String sql = """
            SELECT ts.TutorID, ts.SubjectID, s.SubjectName
            FROM TutorSubject ts
            INNER JOIN Subject s ON ts.SubjectID = s.SubjectID
            WHERE ts.TutorID = ?
            ORDER BY s.SubjectName
        """;
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tutorId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                TutorSubject tutorSubject = new TutorSubject();
                tutorSubject.setTutorID(rs.getInt("TutorID"));
                tutorSubject.setSubjectID(rs.getInt("SubjectID"));
                tutorSubject.setSubjectName(rs.getString("SubjectName"));
                
                tutorSubjects.add(tutorSubject);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting subjects by tutor ID", e);
        }
        
        return tutorSubjects;
    }
    
    /**
     * Get all tutors who teach a specific subject (for filtering)
     */
    public List<Integer> getTutorIdsBySubjectId(int subjectId) {
        List<Integer> tutorIds = new ArrayList<>();
        String sql = """
            SELECT DISTINCT ts.TutorID
            FROM TutorSubject ts
            INNER JOIN Tutor t ON ts.TutorID = t.TutorID
            INNER JOIN CV cv ON t.CVID = cv.CVID
            WHERE ts.SubjectID = ? 
              AND cv.Status = 'Approved'
            ORDER BY ts.TutorID
        """;
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, subjectId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                tutorIds.add(rs.getInt("TutorID"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting tutor IDs by subject ID", e);
        }
        
        return tutorIds;
    }
    
    /**
     * Get tutors with their subjects for advanced filtering
     */
    public List<Object[]> getTutorsWithSubjects() {
        List<Object[]> results = new ArrayList<>();
        String sql = """
            SELECT DISTINCT t.TutorID, u.FullName, u.Avatar, t.Rating, t.Price,
                   STRING_AGG(s.SubjectName, ', ') as SubjectNames,
                   COUNT(ts.SubjectID) as SubjectCount
            FROM Tutor t
            INNER JOIN CV cv ON t.CVID = cv.CVID
            INNER JOIN Users u ON cv.UserID = u.UserID
            INNER JOIN TutorSubject ts ON t.TutorID = ts.TutorID
            INNER JOIN Subject s ON ts.SubjectID = s.SubjectID
            WHERE cv.Status = 'Approved' AND ts.Status = 'Active'
            GROUP BY t.TutorID, u.FullName, u.Avatar, t.Rating, t.Price
            ORDER BY u.FullName
        """;
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Object[] tutorData = new Object[7];
                tutorData[0] = rs.getInt("TutorID");
                tutorData[1] = rs.getString("FullName");
                tutorData[2] = rs.getString("Avatar");
                tutorData[3] = rs.getFloat("Rating");
                tutorData[4] = rs.getFloat("Price");
                tutorData[5] = rs.getString("SubjectNames");
                tutorData[6] = rs.getInt("SubjectCount");
                
                results.add(tutorData);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting tutors with subjects", e);
        }
        
        return results;
    }
    
    /**
     * Check if a tutor teaches a specific subject
     */
    public boolean tutorTeachesSubject(int tutorId, int subjectId) {
        String sql = "SELECT COUNT(*) FROM TutorSubject WHERE TutorID = ? AND SubjectID = ? AND Status = 'Active'";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tutorId);
            pstmt.setInt(2, subjectId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if tutor teaches subject", e);
        }
        return false;
    }
    
    /**
     * Update tutor subject description and price
     */
    public boolean updateTutorSubject(int tutorSubjectId, String description, float pricePerHour) {
        String sql = "UPDATE TutorSubject SET Description = ?, PricePerHour = ? WHERE TutorSubjectID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, description);
            pstmt.setFloat(2, pricePerHour);
            pstmt.setInt(3, tutorSubjectId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating tutor subject", e);
            return false;
        }
    }
    
    /**
     * Delete tutor subject relationship
     */
    public boolean deleteTutorSubject(int tutorSubjectId) {
        String sql = "DELETE FROM TutorSubject WHERE TutorSubjectID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tutorSubjectId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting tutor subject", e);
            return false;
        }
    }
}
