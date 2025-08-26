package controller.Staff;

import entity.CVAssignment;
import entity.User;
import model.DAOCVAssignment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CVReviewServlet", urlPatterns = {"/staff/cv-review"})
public class CVReviewServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CVReviewServlet.class.getName());
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập (Chỉ RoleID = 4 là Staff)
        if (currentUser == null || currentUser.getRoleID() != 4) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Only Staff can review CVs.");
            return;
        }
        
        try {
            // Lấy thông tin từ form
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            String status = request.getParameter("status");
            String reviewNotes = request.getParameter("reviewNotes");
            
            LOGGER.info("Staff " + currentUser.getUserID() + " reviewing CV assignment " + assignmentId + " with status: " + status);
            
            // Cập nhật trạng thái CV
            DAOCVAssignment daoCVAssignment = new DAOCVAssignment();
            boolean success = daoCVAssignment.updateCVStatus(assignmentId, status, reviewNotes);
            
            if (success) {
                session.setAttribute("success", "CV review submitted successfully. Status updated to: " + status);
                LOGGER.info("CV assignment " + assignmentId + " status updated to " + status + " by staff " + currentUser.getUserID());
            } else {
                session.setAttribute("error", "Failed to update CV status. Please try again.");
                LOGGER.warning("Failed to update CV assignment " + assignmentId + " status to " + status);
            }
            
        } catch (NumberFormatException ex) {
            LOGGER.log(Level.SEVERE, "Invalid assignment ID format", ex);
            session.setAttribute("error", "Invalid assignment ID format.");
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error processing CV review", ex);
            session.setAttribute("error", "Error processing CV review: " + ex.getMessage());
        }
        
        // Redirect back to tutor reviews page
        response.sendRedirect(request.getContextPath() + "/staff/tutor-reviews");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to POST
        doPost(request, response);
    }
}




