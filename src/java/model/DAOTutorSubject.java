/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.*;
/**
 *
 * @author dvdung
 */
public class DAOTutorSubject extends DBConnect{
    public boolean addTutorSubject(int tutorId, int subjectId) {
        String sql = "INSERT INTO TutorSubject (TutorID, SubjectID) VALUES (?, ?)";
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tutorId);
            pstmt.setInt(2, subjectId);          
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
