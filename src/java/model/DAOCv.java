/*
 * Click nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import entity.Cv;
import entity.User;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.ResultSet;

public class DAOCv extends DBConnect {

    public int sendCv(Cv cv) {
        int n = 0;
        String sql = "INSERT INTO CV (UserID, Education, Experience, Certificates, Status, SubjectId, Desciption,Skill ,Price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cv.getUserId());
            stmt.setString(2, cv.getEducation());
            stmt.setString(3, cv.getExperience());
            stmt.setString(4, cv.getCertificates());
            stmt.setString(5, cv.getStatus());
            stmt.setInt(6, cv.getSubjectId());
            stmt.setString(7, cv.getDescription());
            stmt.setString(8, cv.getSkill());
            stmt.setFloat(9, cv.getPrice());
            n = stmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    public void updateCVStatus(int cvId, String newStatus) {
        String sql = "UPDATE [dbo].[CV] SET [Status] = ? WHERE [CVID] = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, cvId);
            int rowsUpdated = pstmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Cv getCVbyId(int cvId) {
        String sql = "SELECT CVID, UserID, Education, Experience, Certificates, Status, SubjectId, Desciption, Skill, Price FROM CV WHERE CVID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cvId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Cv(
                        rs.getInt("CVID"),
                        rs.getInt("UserID"),
                        rs.getString("Education"),
                        rs.getString("Experience"),
                        rs.getString("Certificates"),
                        rs.getString("Status"),
                        rs.getInt("SubjectId"),
                        rs.getString("Desciption"),
                        rs.getString("Skill"),
                        rs.getFloat("Price")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
        public Cv getCVbyUserId(int cvId) {
        String sql = "SELECT CVID, UserID, Education, Experience, Certificates, Status, SubjectId, Desciption, Skill, Price FROM CV WHERE UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cvId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Cv(
                        rs.getInt("CVID"),
                        rs.getInt("UserID"),
                        rs.getString("Education"),
                        rs.getString("Experience"),
                        rs.getString("Certificates"),
                        rs.getString("Status"),
                        rs.getInt("SubjectId"),
                        rs.getString("Desciption"),
                        rs.getString("Skill"),
                        rs.getFloat("Price")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean hasPendingOrApprovedCv(int userId) {
        String sql = "SELECT COUNT(*) FROM CV WHERE UserID = ? AND Status IN ('Pending', 'Approved')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public List<User> getApprovedTutors() {
        List<User> tutorList = new ArrayList<>();
        String sql = "SELECT u.*, c.CVID, c.Education, c.Experience, c.Certificates, s.SubjectName "
                + "FROM Users u "
                + "INNER JOIN [dbo].[CV] c ON u.UserID = c.UserID "
                + "LEFT JOIN Subject s ON c.SubjectId = s.SubjectID "
                + "WHERE u.RoleID = 3 AND c.Status = 'Approved'";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setAvatar(rs.getString("Avatar"));
                user.setCreateAt(rs.getDate("CreatedAt"));
                user.setPhone(rs.getString("Phone"));
                user.setIsActive(rs.getInt("isActive"));
                user.setDob(rs.getDate("Dob"));
                user.setAddress(rs.getString("Address"));
                user.setUserName(rs.getString("UserName"));
                user.setPassword(rs.getString("Password"));
                user.setSubjectName(rs.getString("SubjectName"));
                user.setCvID(rs.getInt("CVID"));
                user.setEducation(rs.getString("Education"));
                user.setExperience(rs.getString("Experience"));
                user.setCertificates(rs.getString("Certificates"));
                tutorList.add(user);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, null, ex);
        }
        return tutorList;
    }

    public ResultSet getCVByCVId(int cvId) {
        String sql = "SELECT u.FullName, u.Email, u.Phone, u.Address, u.Dob, "
                + "c.Education, c.Experience, c.Desciption, u.Avatar, s.SubjectName "
                + "FROM Users u "
                + "INNER JOIN CV c ON u.UserID = c.UserID "
                + "LEFT JOIN Subject s ON c.SubjectId = s.SubjectID "
                + "WHERE c.CVID = ? AND c.Status = 'Approved'";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cvId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                System.out.println("No CV found for CVID: " + cvId);
                return null;
            }
            rs.beforeFirst();
            return rs;
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, "SQL Error for CVID: " + cvId, ex);
            return null;
        }
    }

    public ResultSet getCVByCVIdSimple(int cvId) {
        String sql = "SELECT * FROM [dbo].[CV] "
                + "JOIN Subject ON CV.SubjectId = Subject.SubjectID "
                + "JOIN Users ON Users.UserID = CV.UserID "
                + "WHERE [CVID] = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cvId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                System.out.println("No CV found for CVID: " + cvId);
                return null;
            }
            rs.beforeFirst();
            return rs;
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, "SQL Error for CVID: " + cvId, ex);
            return null;
        }
    }
    public int UpdateCV(int userID, String education, String experience, String certificates, String description, String skill, float price)
    {
        int n=0;
        String sql = "UPDATE [dbo].[CV] SET [Education] = ?, [Experience] = ?, [Certificates] = ?, [Desciption] = ?, [Skill] = ?, [Price] = ? WHERE [UserID] = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, education);
            pstmt.setString(2, experience);
            pstmt.setString(3, certificates);
            pstmt.setString(4, description);
            pstmt.setString(5, skill);
            pstmt.setFloat(6, price);
            pstmt.setInt(7, userID);
            int rowsUpdated = pstmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }
    public float getPriceById(int cvid){
        float n=0;
        String sql = "SELECT Price  FROM [dbo].[CV] WHERE CVID ="+cvid;
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                n = rs.getFloat(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutorRating.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }
    
    /**
     * Lấy tất cả CV có trạng thái 'Pending' từ bảng CV
     * @return List<Cv> danh sách CV đang chờ xử lý
     */
    public List<Cv> getPendingCVs() {
        List<Cv> pendingCVs = new ArrayList<>();
        String sql = "SELECT CVID, UserID, Education, Experience, Certificates, Status, SubjectId, Desciption, Skill, Price FROM CV WHERE Status = 'Pending'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Cv cv = new Cv(
                    rs.getInt("CVID"),
                    rs.getInt("UserID"),
                    rs.getString("Education"),
                    rs.getString("Experience"),
                    rs.getString("Certificates"),
                    rs.getString("Status"),
                    rs.getInt("SubjectId"),
                    rs.getString("Desciption"),
                    rs.getString("Skill"),
                    rs.getFloat("Price")
                );
                pendingCVs.add(cv);
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, "Error getting pending CVs", ex);
        }
        
        return pendingCVs;
    }
    
    /**
     * Lấy CV theo trạng thái cụ thể từ bảng CV
     * @param status trạng thái cần lấy (Pending, Approved, Rejected, etc.)
     * @return List<Cv> danh sách CV theo trạng thái
     */
    public List<Cv> getCVsByStatus(String status) {
        List<Cv> cvsByStatus = new ArrayList<>();
        String sql = "SELECT CVID, UserID, Education, Experience, Certificates, Status, SubjectId, Desciption, Skill, Price FROM CV WHERE Status = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Cv cv = new Cv(
                    rs.getInt("CVID"),
                    rs.getInt("UserID"),
                    rs.getString("Education"),
                    rs.getString("Experience"),
                    rs.getString("Certificates"),
                    rs.getString("Status"),
                    rs.getInt("SubjectId"),
                    rs.getString("Desciption"),
                    rs.getString("Skill"),
                    rs.getFloat("Price")
                );
                cvsByStatus.add(cv);
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(DAOCv.class.getName()).log(Level.SEVERE, "Error getting CVs by status: " + status, ex);
        }
        
        return cvsByStatus;
    }
}
