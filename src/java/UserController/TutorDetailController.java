package UserController;

import entity.TutorRating;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.DAOCv;
import model.DAOTutorRating;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "TutorDetailController", urlPatterns = {"/Tutordetail"})
public class TutorDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy tutorID từ request parameter
            String tutorIdStr = request.getParameter("tutorID");
            if (tutorIdStr == null || tutorIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Không có thông tin gia sư");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            int tutorId = Integer.parseInt(tutorIdStr);
            System.out.println("DEBUG - Processing tutor ID: " + tutorId);
            
            DAOTutorRating dao = new DAOTutorRating();
            
            // Lấy thông tin gia sư
            String sqlTutor = "SELECT t.TutorID, u.FullName, s.SubjectName, t.Rating, u.Avatar, t.Price, cv.Desciption, cv.Certificates, s.SubjectID, cv.Skill " +
                             "FROM Users u " +
                             "JOIN CV cv ON u.UserID = cv.UserID " +
                             "JOIN Tutor t ON cv.CVID = t.CVID " +
                             "JOIN Subject s ON cv.SubjectId = s.SubjectID " +
                             "WHERE t.TutorID = ?";
            
            ResultSet rsTutor = null;
            try {
                PreparedStatement ps = dao.getConnection().prepareStatement(sqlTutor);
                ps.setInt(1, tutorId);
                rsTutor = ps.executeQuery();
                
                if (rsTutor != null && rsTutor.next()) {
                    System.out.println("DEBUG - Found tutor: " + rsTutor.getString("FullName"));
                    
                    // Lưu thông tin tutor vào các biến thay vì sử dụng ResultSet trong JSP
                    int tutorID = rsTutor.getInt("TutorID");
                    String fullName = rsTutor.getString("FullName");
                    String subjectName = rsTutor.getString("SubjectName");
                    float rating = rsTutor.getFloat("Rating");
                    String avatarPath = rsTutor.getString("Avatar");
                    int price = rsTutor.getInt("Price");
                    String description = rsTutor.getString("Desciption");
                    String certificates = rsTutor.getString("Certificates");
                    int subjectID = rsTutor.getInt("SubjectID");
                    String skill = rsTutor.getString("Skill");
                    
                    // Xử lý avatar
                    String finalAvatarPath;
                    if (avatarPath != null && !avatarPath.trim().isEmpty() && !avatarPath.equals("null")) {
                        finalAvatarPath = avatarPath;
                        System.out.println("DEBUG - Using database avatar: " + finalAvatarPath);
                    } else {
                        finalAvatarPath = "uploads/default_avatar.jpg";
                        System.out.println("DEBUG - Using default avatar: " + finalAvatarPath);
                        // Auto-update database to set default avatar for this tutor
                        updateTutorAvatar(tutorId, finalAvatarPath);
                    }
                    
                    // Set các attributes cho JSP
                    request.setAttribute("tutorID", tutorID);
                    request.setAttribute("tutorFullName", fullName);
                    request.setAttribute("tutorSubjectName", subjectName);
                    request.setAttribute("tutorRating", rating);
                    request.setAttribute("tutorAvatar", finalAvatarPath);
                    request.setAttribute("tutorPrice", price);
                    request.setAttribute("tutorDescription", description);
                    request.setAttribute("tutorCertificates", certificates);
                    request.setAttribute("tutorSubjectID", subjectID);
                    request.setAttribute("tutorSkill", skill);
                    
                    // Lấy thông tin đánh giá
                    processTutorRatings(request, dao, tutorId);
                    
                    // Forward đến JSP
                    System.out.println("DEBUG - Forwarding to tutor-details.jsp");
                    request.getRequestDispatcher("/tutor-details.jsp").forward(request, response);
                    
                } else {
                    System.out.println("DEBUG - No tutor found with ID: " + tutorId);
                    request.setAttribute("error", "Không tìm thấy gia sư với ID: " + tutorId);
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                }
                
            } catch (SQLException e) {
                System.err.println("SQL Error: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } finally {
                if (rsTutor != null) {
                    try {
                        rsTutor.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid tutor ID format: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "ID gia sư không hợp lệ");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi không mong muốn: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    private void processTutorRatings(HttpServletRequest request, DAOTutorRating dao, int tutorId) throws SQLException {
        // Lấy thông tin đánh giá
        String sqlReviews = "SELECT tr.StudentID, tr.Rating, tr.Comment, tr.RatingDate, u.FullName, u.Avatar " +
                           "FROM TutorRating tr " +
                           "JOIN Users u ON tr.StudentID = u.UserID " +
                           "WHERE tr.TutorID = ? " +
                           "ORDER BY tr.RatingDate DESC";
        
        List<Object[]> reviews = new ArrayList<>();
        int[] ratingDistribution = new int[5]; // For 1 to 5 stars
        double totalRating = 0;
        int reviewCount = 0;
        
        try (PreparedStatement ps = dao.getConnection().prepareStatement(sqlReviews)) {
            ps.setInt(1, tutorId);
            try (ResultSet rsReviews = ps.executeQuery()) {
                while (rsReviews.next()) {
                    int studentId = rsReviews.getInt("StudentID");
                    int rating = rsReviews.getInt("Rating");
                    String comment = rsReviews.getString("Comment");
                    String ratingDate = rsReviews.getString("RatingDate");
                    String reviewerName = rsReviews.getString("FullName");
                    String reviewerAvatar = rsReviews.getString("Avatar");
                    
                    // Cập nhật rating distribution
                    if (rating >= 1 && rating <= 5) {
                        ratingDistribution[rating - 1]++;
                        totalRating += rating;
                        reviewCount++;
                    }
                    
                    // Xử lý comment dài
                    boolean isLongReview = comment != null && comment.length() > 100;
                    String displayText = isLongReview ? comment.substring(0, 100) + "..." : comment;
                    
                    reviews.add(new Object[]{studentId, rating, comment, ratingDate, reviewerName, reviewerAvatar, isLongReview, displayText});
                }
            }
        }
        
        // Tính điểm trung bình
        double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;
        
        // Set attributes
        request.setAttribute("reviews", reviews);
        request.setAttribute("ratingDistribution", ratingDistribution);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("reviewCount", reviewCount);
        
        System.out.println("DEBUG - Processed ratings: count=" + reviewCount + ", avg=" + averageRating);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
    
    /**
     * Auto-update tutor avatar in database to default if null/empty
     */
    private void updateTutorAvatar(int tutorId, String defaultAvatarPath) {
        try {
            // Use the new DAO method to update the database
            DAOTutorRating dao = new DAOTutorRating();
            int rowsUpdated = dao.updateTutorAvatar(tutorId, defaultAvatarPath);
            System.out.println("DEBUG - Successfully updated " + rowsUpdated + " rows for tutor " + tutorId + " with avatar: " + defaultAvatarPath);
        } catch (Exception e) {
            System.out.println("DEBUG - Error updating tutor avatar: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
