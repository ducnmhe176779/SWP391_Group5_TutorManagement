package model;

import entity.CVAssignment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOCVAssignment extends DBConnect {

    public DAOCVAssignment() {
        super(); // Call parent constructor to initialize connection
    }

    
    private static final Logger LOGGER = Logger.getLogger(DAOCVAssignment.class.getName());
    
    /**
     * Tự động phân công CV cho staff
     */
    public boolean autoAssignCV(int cvId) {
        String sql = "EXEC sp_AutoAssignCV ?";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            
            stmt.setInt(1, cvId);
            boolean result = stmt.execute();
            
            LOGGER.info("CV " + cvId + " auto-assigned successfully");
            return true;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error auto-assigning CV " + cvId, ex);
            return false;
        }
    }
    
    /**
     * Lấy tất cả CV assignments cho admin
     */
    public List<CVAssignment> getAllCVAssignments() {
        List<CVAssignment> assignments = new ArrayList<>();
        String sql = "EXEC sp_GetAllCVsForAdmin";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                CVAssignment assignment = new CVAssignment();
                assignment.setCvID(rs.getInt("CVID"));
                assignment.setStatus(rs.getString("Status"));
                assignment.setAssignedStaffID(rs.getInt("AssignedStaffID"));
                assignment.setAssignedDate(rs.getTimestamp("AssignedDate"));
                assignment.setAssignmentStatus(rs.getString("AssignmentStatus"));
                assignment.setTutorName(rs.getString("TutorFullName"));
                assignment.setTutorEmail(rs.getString("TutorEmail"));
                assignment.setStaffName(rs.getString("StaffName"));
                assignment.setStaffEmail(rs.getString("StaffEmail"));
                assignment.setEducation(rs.getString("Education"));
                assignment.setExperience(rs.getString("Experience"));
                assignment.setSkill(rs.getString("Skill"));
                assignment.setPrice(rs.getFloat("Price"));
                
                assignments.add(assignment);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting all CV assignments", ex);
        }
        
        return assignments;
    }
    
    /**
     * Lấy CV assignments cho staff cụ thể
     */
    public List<CVAssignment> getAssignedCVsForStaff(int staffId) {
        List<CVAssignment> assignments = new ArrayList<>();
        String sql = "EXEC sp_GetAssignedCVsForStaff ?";
        
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            
            stmt.setInt(1, staffId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                CVAssignment assignment = new CVAssignment();
                assignment.setAssignmentID(rs.getInt("AssignmentID"));
                assignment.setCvID(rs.getInt("CVID"));
                assignment.setStatus(rs.getString("AssignmentStatus"));
                assignment.setPriority(rs.getInt("Priority"));
                assignment.setAssignedDate(rs.getTimestamp("AssignedDate"));
                
                // CV Information
                assignment.setEducation(rs.getString("Education"));
                assignment.setExperience(rs.getString("Experience"));
                assignment.setSkill(rs.getString("Skill"));
                assignment.setPrice(rs.getFloat("Price"));
                
                // Tutor Information
                assignment.setTutorName(rs.getString("TutorFullName"));
                assignment.setTutorEmail(rs.getString("TutorEmail"));
                assignment.setTutorPhone(rs.getString("TutorPhone"));
                
                assignments.add(assignment);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting assigned CVs for staff " + staffId, ex);
        }
        
        return assignments;
    }
    
    /**
     * Staff update CV status
     */
    public boolean updateCVStatus(int assignmentId, String status, String reviewNotes) {
        String sql = "EXEC sp_UpdateCVStatusByStaff ?, ?, ?";
        
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            
            stmt.setInt(1, assignmentId);
            stmt.setString(2, status);
            stmt.setString(3, reviewNotes);
            
            boolean result = stmt.execute();
            
            LOGGER.info("CV status updated to " + status + " for assignment " + assignmentId);
            return true;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating CV status for assignment " + assignmentId, ex);
            return false;
        }
    }
    
    /**
     * Lấy thông tin assignment theo CV ID
     */
    public CVAssignment getAssignmentByCVID(int cvId) {
        String sql = "SELECT * FROM CVAssignment WHERE CVID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cvId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                CVAssignment assignment = new CVAssignment();
                assignment.setAssignmentID(rs.getInt("AssignmentID"));
                assignment.setCvID(rs.getInt("CVID"));
                assignment.setAssignedStaffID(rs.getInt("AssignedStaffID"));
                assignment.setStatus(rs.getString("Status"));
                assignment.setPriority(rs.getInt("Priority"));
                assignment.setAssignedDate(rs.getTimestamp("AssignedDate"));
                assignment.setReviewDate(rs.getTimestamp("ReviewDate"));
                assignment.setReviewNotes(rs.getString("ReviewNotes"));
                
                return assignment;
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting assignment for CV " + cvId, ex);
        }
        
        return null;
    }
    
    /**
     * Kiểm tra xem CV đã được phân công chưa
     */
    public boolean isCVAssigned(int cvId) {
        String sql = "SELECT COUNT(*) FROM CVAssignment WHERE CVID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cvId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking if CV " + cvId + " is assigned", ex);
        }
        
        return false;
    }
}
