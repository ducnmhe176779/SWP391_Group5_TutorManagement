package controller.Staff;

import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DBConnect;

@WebServlet(name = "TutorManagementServlet", urlPatterns = {"/staff/tutor-management"})
public class TutorManagementServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(TutorManagementServlet.class.getName());
    private static final String TUTOR_MANAGEMENT_JSP = "/staff/tutor-management.jsp";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập
        if (currentUser == null || currentUser.getRoleID() != 4) { // RoleID = 4 là Staff
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        try {
            // Load tutors đã approve từ database
            List<TutorInfo> approvedTutors = loadApprovedTutors();
            
            // Load statistics
            TutorStats stats = loadTutorStats();
            
            request.setAttribute("approvedTutors", approvedTutors);
            request.setAttribute("tutorStats", stats);
            
            request.getRequestDispatcher(TUTOR_MANAGEMENT_JSP).forward(request, response);
            
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error loading approved tutors", ex);
            request.setAttribute("error", "Lỗi khi tải danh sách tutor: " + ex.getMessage());
            request.getRequestDispatcher(TUTOR_MANAGEMENT_JSP).forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập
        if (currentUser == null || currentUser.getRoleID() != 4) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String action = request.getParameter("action");
        int tutorId = Integer.parseInt(request.getParameter("tutorId"));
        String reason = request.getParameter("reason");
        
        try {
            boolean success = false;
            String message = "";
            
            switch (action) {
                case "deactivate":
                    success = deactivateTutor(tutorId, reason);
                    message = success ? "Tutor đã được deactivate thành công" : "Lỗi khi deactivate tutor";
                    break;
                case "suspend":
                    success = suspendTutor(tutorId, reason);
                    message = success ? "Tutor đã được suspend thành công" : "Lỗi khi suspend tutor";
                    break;
                case "activate":
                    success = activateTutor(tutorId, reason);
                    message = success ? "Tutor đã được activate thành công" : "Lỗi khi activate tutor";
                    break;
                default:
                    message = "Hành động không hợp lệ";
                    break;
            }
            
            if (success) {
                session.setAttribute("success", message);
            } else {
                session.setAttribute("error", message);
            }
            
            response.sendRedirect(request.getContextPath() + "/staff/tutor-management");
            
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error processing tutor action", ex);
            session.setAttribute("error", "Lỗi khi xử lý hành động: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/tutor-management");
        }
    }
    
    private List<TutorInfo> loadApprovedTutors() throws SQLException {
        List<TutorInfo> tutors = new ArrayList<>();
        
        String sql = """
            SELECT 
                u.UserID,
                u.FullName,
                u.Email,
                u.Phone,
                u.Avatar,
                u.CreatedDate,
                c.Education,
                c.Experience,
                c.Skill,
                c.Price,
                c.Status as CVStatus,
                t.IsActive,
                t.Rating,
                t.TotalHours,
                t.StudentCount
            FROM Users u
            INNER JOIN CV c ON u.UserID = c.UserID
            INNER JOIN Tutor t ON c.CVID = t.CVID
            WHERE u.RoleID = 2 
            AND c.Status = 'Approved'
            AND t.IsActive = 1
            ORDER BY t.Rating DESC, t.TotalHours DESC
            """;
        
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                TutorInfo tutor = new TutorInfo();
                tutor.setUserID(rs.getInt("UserID"));
                tutor.setFullName(rs.getString("FullName"));
                tutor.setEmail(rs.getString("Email"));
                tutor.setPhone(rs.getString("Phone"));
                tutor.setAvatar(rs.getString("Avatar"));
                tutor.setCreatedDate(rs.getTimestamp("CreatedDate"));
                tutor.setEducation(rs.getString("Education"));
                tutor.setExperience(rs.getString("Experience"));
                tutor.setSkill(rs.getString("Skill"));
                tutor.setPrice(rs.getFloat("Price"));
                tutor.setCVStatus(rs.getString("CVStatus"));
                tutor.setIsActive(rs.getInt("IsActive"));
                tutor.setRating(rs.getFloat("Rating"));
                tutor.setTotalHours(rs.getInt("TotalHours"));
                tutor.setStudentCount(rs.getInt("StudentCount"));
                
                tutors.add(tutor);
            }
        }
        
        return tutors;
    }
    
    private TutorStats loadTutorStats() throws SQLException {
        TutorStats stats = new TutorStats();
        
        String sql = """
            SELECT 
                COUNT(*) as totalTutors,
                SUM(CASE WHEN t.IsActive = 1 THEN 1 ELSE 0 END) as activeTutors,
                AVG(COALESCE(t.Rating, 0)) as avgRating,
                SUM(COALESCE(t.TotalHours, 0)) as totalHours
            FROM Users u
            INNER JOIN CV c ON u.UserID = c.UserID
            INNER JOIN Tutor t ON c.CVID = t.CVID
            WHERE u.RoleID = 2 AND c.Status = 'Approved'
            """;
        
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                stats.setTotalTutors(rs.getInt("totalTutors"));
                stats.setActiveTutors(rs.getInt("activeTutors"));
                stats.setAverageRating(rs.getFloat("avgRating"));
                stats.setTotalHours(rs.getInt("totalHours"));
            }
        }
        
        return stats;
    }
    
    private boolean deactivateTutor(int tutorId, String reason) throws SQLException {
        String sql = "UPDATE Tutor SET IsActive = 0 WHERE CVID = (SELECT CVID FROM CV WHERE UserID = ?)";
        
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tutorId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private boolean suspendTutor(int tutorId, String reason) throws SQLException {
        String sql = "UPDATE Tutor SET IsActive = 0, Status = 'Suspended' WHERE CVID = (SELECT CVID FROM CV WHERE UserID = ?)";
        
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tutorId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private boolean activateTutor(int tutorId, String reason) throws SQLException {
        String sql = "UPDATE Tutor SET IsActive = 1, Status = 'Active' WHERE CVID = (SELECT CVID FROM CV WHERE UserID = ?)";
        
        try (Connection conn = new DBConnect().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tutorId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Inner classes for data transfer
    public static class TutorInfo {
        private int userID;
        private String fullName;
        private String email;
        private String phone;
        private String avatar;
        private java.sql.Timestamp createdDate;
        private String education;
        private String experience;
        private String skill;
        private float price;
        private String cvStatus;
        private int isActive;
        private float rating;
        private int totalHours;
        private int studentCount;
        
        // Getters and Setters
        public int getUserID() { return userID; }
        public void setUserID(int userID) { this.userID = userID; }
        
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        
        public String getAvatar() { return avatar; }
        public void setAvatar(String avatar) { this.avatar = avatar; }
        
        public java.sql.Timestamp getCreatedDate() { return createdDate; }
        public void setCreatedDate(java.sql.Timestamp createdDate) { this.createdDate = createdDate; }
        
        public String getEducation() { return education; }
        public void setEducation(String education) { this.education = education; }
        
        public String getExperience() { return experience; }
        public void setExperience(String experience) { this.experience = experience; }
        
        public String getSkill() { return skill; }
        public void setSkill(String skill) { this.skill = skill; }
        
        public float getPrice() { return price; }
        public void setPrice(float price) { this.price = price; }
        
        public String getCVStatus() { return cvStatus; }
        public void setCVStatus(String cvStatus) { this.cvStatus = cvStatus; }
        
        public int getIsActive() { return isActive; }
        public void setIsActive(int isActive) { this.isActive = isActive; }
        
        public float getRating() { return rating; }
        public void setRating(float rating) { this.rating = rating; }
        
        public int getTotalHours() { return totalHours; }
        public void setTotalHours(int totalHours) { this.totalHours = totalHours; }
        
        public int getStudentCount() { return studentCount; }
        public void setStudentCount(int studentCount) { this.studentCount = studentCount; }
    }
    
    public static class TutorStats {
        private int totalTutors;
        private int activeTutors;
        private float averageRating;
        private int totalHours;
        
        // Getters and Setters
        public int getTotalTutors() { return totalTutors; }
        public void setTotalTutors(int totalTutors) { this.totalTutors = totalTutors; }
        
        public int getActiveTutors() { return activeTutors; }
        public void setActiveTutors(int activeTutors) { this.activeTutors = activeTutors; }
        
        public float getAverageRating() { return averageRating; }
        public void setAverageRating(float averageRating) { this.averageRating = averageRating; }
        
        public int getTotalHours() { return totalHours; }
        public void setTotalHours(int totalHours) { this.totalHours = totalHours; }
    }
}
