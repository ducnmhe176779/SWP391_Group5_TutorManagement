/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import entity.Subject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *

 * @author Admin
 */
public class DAOSubject extends DBConnect{
        public List<Subject> getAllSubjects() {
        List<Subject> subjects = new ArrayList<>();
        // Sửa đổi: Thêm cột Status vào câu lệnh SELECT
        String sql = "SELECT SubjectID, SubjectName, Description, Status FROM Subject";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                // Sửa đổi: Sử dụng constructor mới có status
                subjects.add(new Subject(
                        rs.getInt("SubjectID"),
                        rs.getString("SubjectName"),
                        rs.getString("Description"),
                        rs.getString("Status")
                ));
            }
        } catch (SQLException e) {


public class DAOSubject extends DBConnect{
    
    public int addSubject(Subject subject) throws SQLException{
        int result =0;
        String sql = "INSERT INTO Subject(SubjectName, Description, Status) VALUES(?,?,?)";
        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1,subject.getSubjectName());
            ps.setString(2,subject.getDescription());
            // Sửa đổi: sử dụng getStatus() để lấy giá trị status, mặc định là "Active" nếu null
            ps.setString(3,subject.getStatus()!=null?subject.getStatus():"Active");
            result = ps.executeUpdate();
        }catch(SQLException e){
            e.printStackTrace();
        }
        return result;
    }
    
    public int updateSubject(Subject subject) throws SQLException{
        int result =0;
        String sql = "UPDATE Subject set SubjectName = ?, Description = ?, Status = ? Where SubjectID =?";
        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1,subject.getSubjectName());
            ps.setString(2,subject.getDescription());
            ps.setString(3,subject.getStatus()!=null?subject.getStatus():"Active");
            ps.setInt(4,subject.getSubjectID());
            result = ps.executeUpdate();
        }catch(SQLException e){
            e.printStackTrace();
        }
        return result;
    }
    
    public List<Subject> getAllSubjects(){
        List<Subject> subjects = new ArrayList<>();
        String sql = "Select SubjectID, SubjectName, Description, Status from Subject";
        try(Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(sql)){
            while(rs.next()){
                subjects.add(new Subject(
                rs.getInt("SubjectID"),
                rs.getString("SubjectName"),
                rs.getString("Description"),
                        rs.getString("Status")
                ));             
            }
        }catch(SQLException e){

            e.printStackTrace();
        }
        return subjects;
    }
}
