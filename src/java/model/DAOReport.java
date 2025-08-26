/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import entity.Report;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author dvdung
 */
public class DAOReport extends DBConnect {

    public int addReport(Report report) {
        int n = 0;
        String sql = "INSERT INTO Report (BookID, UserID, Reason, Status, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, report.getBookID());
            stmt.setInt(2, report.getUserID());
            stmt.setString(3, report.getReason());
            stmt.setString(4, report.getStatus());
            n = stmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOReport.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    public List<Report> getAllReports() {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT ReportID, BookID, UserID, Reason, Status, CreatedAt FROM Report";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Report report = new Report(
                        rs.getInt("ReportID"),
                        rs.getInt("BookID"),
                        rs.getInt("UserID"),
                        rs.getString("Reason"),
                        rs.getString("Status"),
                        rs.getDate("CreatedAt")
                );
                reports.add(report);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOReport.class.getName()).log(Level.SEVERE, null, ex);
        }
        return reports;
    }
    
    public boolean updateStatus(int reportID, String newStatus) {
        String sql = "UPDATE Report SET Status = ? WHERE ReportID = ?";
        
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql) ;
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, reportID);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOReport.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
