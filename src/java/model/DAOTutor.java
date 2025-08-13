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
    public List<Tutor> getTopTutors(int limit) {
        List<Tutor> tutors = new ArrayList<>();
        String sql
                = "SELECT TOP (" + limit + ") t.TutorID, t.Rating,t.Price, "
                + "c.CVID, c.Desciption, "
                + "u.UserID, u.Email, u.FullName, u.Phone, u.Avatar "
                + "FROM Tutor t "
                + "JOIN CV c ON t.CVID = c.CVID "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "ORDER BY t.Rating DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
           DAOTutorRating dao= new DAOTutorRating();
            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setEmail(rs.getString("Email"));
                user.setFullName(rs.getString("FullName"));
                user.setPhone(rs.getString("Phone"));
                user.setAvatar(rs.getString("Avatar"));

                Cv cv = new Cv();
                cv.setCvId(rs.getInt("CVID"));
                cv.setDescription(rs.getString("Desciption"));
                cv.setUser(user);

                Tutor tutor = new Tutor();
                tutor.setTutorID(rs.getInt("TutorID"));
                tutor.setCVID(rs.getInt("CVID"));
                tutor.setRating(dao.getAvgRating(rs.getInt("TutorID")));
                tutor.setPrice(rs.getFloat("Price"));
                tutor.setCv(cv);

                tutors.add(tutor);
            }
        } catch (SQLException e) {
            System.out.println("lỗi khi lấy 5 tutors");
            e.printStackTrace();
        }
        return tutors;
    }
}
