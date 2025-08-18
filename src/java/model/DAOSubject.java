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
        System.out.println("DEBUG: getAllSubjects executing SQL: " + sql);
        
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
            System.out.println("DEBUG: getAllSubjects SQL error: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: getAllSubjects returned " + subjects.size() + " subjects");
        return subjects;
    }
    
    // Lấy tổng số môn học
    public int getTotalSubjects() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM Subject";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL trong getTotalSubjects: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: getTotalSubjects() returned: " + total);
        return total;
    }
    
    // Method test để kiểm tra database connection
    public boolean testConnection() {
        try {
            String testSql = "SELECT 1";
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(testSql)) {
                if (rs.next()) {
                    System.out.println("DEBUG: Database connection test successful");
                    return true;
                }
            }
        } catch (SQLException e) {
            System.out.println("DEBUG: Database connection test failed: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Method kiểm tra bảng Subject
    public boolean checkSubjectTable() {
        try {
            String checkSql = "SELECT COUNT(*) FROM Subject";
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(checkSql)) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("DEBUG: Subject table exists with " + count + " records");
                    return true;
                }
            }
        } catch (SQLException e) {
            System.out.println("DEBUG: Subject table check failed: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy danh sách môn học theo trang
    public List<Subject> getSubjectsByPage(int page, int pageSize) {
        List<Subject> subjects = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        // Sử dụng cú pháp SQL Server
        String sql = "SELECT SubjectID, SubjectName, Description, Status FROM Subject ORDER BY SubjectID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            System.out.println("DEBUG: Executing SQL: " + sql + " with offset=" + offset + ", pageSize=" + pageSize);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                subjects.add(new Subject(
                    rs.getInt("SubjectID"),
                    rs.getString("SubjectName"),
                    rs.getString("Description"),
                    rs.getString("Status")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL trong getSubjectsByPage: " + e.getMessage());
            e.printStackTrace();
            
            // Fallback: sử dụng cú pháp SQL Server cũ hơn
            try {
                String fallbackSql = "SELECT SubjectID, SubjectName, Description, Status FROM Subject ORDER BY SubjectID OFFSET ? ROWS";
                try (PreparedStatement fallbackPs = conn.prepareStatement(fallbackSql)) {
                    fallbackPs.setInt(1, offset);
                    System.out.println("DEBUG: Trying fallback SQL: " + fallbackSql + " with offset=" + offset);
                    
                    ResultSet fallbackRs = fallbackPs.executeQuery();
                    
                    int count = 0;
                    while (fallbackRs.next() && count < pageSize) {
                        subjects.add(new Subject(
                            fallbackRs.getInt("SubjectID"),
                            fallbackRs.getString("SubjectName"),
                            fallbackRs.getString("Description"),
                            fallbackRs.getString("Status")
                        ));
                        count++;
                    }
                }
            } catch (SQLException fallbackEx) {
                System.out.println("Lỗi SQL fallback: " + fallbackEx.getMessage());
                fallbackEx.printStackTrace();
                
                // Cuối cùng, thử lấy tất cả và cắt theo trang
                try {
                    String simpleSql = "SELECT SubjectID, SubjectName, Description, Status FROM Subject ORDER BY SubjectID";
                    try (Statement simpleSt = conn.createStatement();
                         ResultSet simpleRs = simpleSt.executeQuery(simpleSql)) {
                        
                        int currentRow = 0;
                        while (simpleRs.next() && currentRow < offset + pageSize) {
                            if (currentRow >= offset) {
                                subjects.add(new Subject(
                                    simpleRs.getInt("SubjectID"),
                                    simpleRs.getString("SubjectName"),
                                    simpleRs.getString("Description"),
                                    simpleRs.getString("Status")
                                ));
                            }
                            currentRow++;
                        }
                    }
                } catch (SQLException simpleEx) {
                    System.out.println("Lỗi SQL đơn giản: " + simpleEx.getMessage());
                    simpleEx.printStackTrace();
                }
            }
        }
        
        System.out.println("getSubjectsByPage: page=" + page + ", pageSize=" + pageSize + ", offset=" + offset + ", resultCount=" + subjects.size());
        return subjects;
    }
    
    public Subject getSubjectById(int subjectId) throws SQLException {
        String sql = "SELECT SubjectID, SubjectName, Description, Status FROM Subject WHERE SubjectID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Subject(
                    rs.getInt("SubjectID"),
                    rs.getString("SubjectName"),
                    rs.getString("Description"),
                    rs.getString("Status")
                );
            }
        }
        return null;
    }
    
    public List<Subject> getAllTutorSubjects() throws SQLException {
        List<Subject> subjects = new ArrayList<>();
        String sql = """
            SELECT DISTINCT s.SubjectID, s.SubjectName, s.Description, s.Status
            FROM Subject s
            JOIN CV c ON s.SubjectID = c.SubjectId
            JOIN Tutor t ON c.CVID = t.CVID
            WHERE s.Status = 'Active'
            ORDER BY s.SubjectName
            """;
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                subjects.add(new Subject(
                    rs.getInt("SubjectID"),
                    rs.getString("SubjectName"),
                    rs.getString("Description"),
                    rs.getString("Status")
                ));
            }
        }
        return subjects;
    }
    
    public ResultSet getData(String sql) {
        ResultSet rs = null;
        try {
            Statement st = conn.createStatement();
            rs = st.executeQuery(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rs;
    }
    
    public List<Subject> getTopSubjectsByBooking(int limit) {
        List<Subject> subjects = new ArrayList<>();
        // Sửa đổi: Thêm cột Status vào câu lệnh SELECT và lọc chỉ lấy Subject có Status = 'Active'
        String sql = """
                     SELECT TOP (?) s.SubjectID, s.SubjectName, s.Description, s.Status, COUNT(b.SubjectID) AS BookingCount
                     FROM Subject s
                     JOIN Booking b ON s.SubjectID = b.SubjectID
                     WHERE b.Status IN ('Confirmed', 'Completed', 'Pending') AND s.Status = 'Active'
                     GROUP BY s.SubjectID, s.SubjectName, s.Description, s.Status
                     ORDER BY BookingCount DESC
                     """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Sửa đổi: Sử dụng constructor mới có status
                Subject subject = new Subject(
                        rs.getInt("SubjectID"),
                        rs.getString("SubjectName"),
                        rs.getString("Description"),
                        rs.getString("Status")
                );
                subject.setBookingCount(rs.getInt("BookingCount"));
                subjects.add(subject);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy các Subject.");
            e.printStackTrace();
        }
        return subjects;
    }
}
