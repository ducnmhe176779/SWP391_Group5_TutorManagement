/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import entity.TutorRating;
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
 * @author Admin
 */
public class DAOTutorRating extends DBConnect{
    
        public int getAvgRating(int tutorid) {
        int avg = 0;
        String sql = "SELECT sum(rating)/COUNT(rating)  FROM [dbo].[TutorRating] WHERE TutorID =" + tutorid;
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                avg = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return avg;
    }
        
        
    public int numberReview(int tutorid) {
        int count = 0;
        String sql = "SELECT COUNT(rating)  FROM [dbo].[TutorRating] WHERE TutorID =" + tutorid;
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }
}
