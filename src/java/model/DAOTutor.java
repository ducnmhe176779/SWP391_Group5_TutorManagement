/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import entity.Cv;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import entity.Tutor;
import entity.User;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author Admin
 */
public class DAOTutor extends DBConnect{
    public List<Tutor> getAllTutors() {
        List<Tutor> tutors = new ArrayList<>();
        String sql = """
        SELECT t.tutorID, t.CVID, t.rating, u.FullName, u.Email
        FROM Tutor t
        JOIN CV c ON t.CVID = c.CVID
        JOIN Users u ON c.UserID = u.UserID
    """;
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                User user = new User();
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));

                Cv cv = new Cv();
                cv.setUser(user);

                Tutor tutor = new Tutor();
                tutor.setTutorID(rs.getInt("tutorID"));
                tutor.setCVID(rs.getInt("CVID"));
                tutor.setRating(rs.getFloat("rating"));
                tutor.setCv(cv);
                tutors.add(tutor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tutors;
    }
}
