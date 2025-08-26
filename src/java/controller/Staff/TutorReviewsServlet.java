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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "TutorReviewsServlet", urlPatterns = {"/staff/tutor-reviews"})
public class TutorReviewsServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(TutorReviewsServlet.class.getName());
    private static final String TUTOR_REVIEWS_JSP = "/staff/tutor-reviews.jsp";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập (Chỉ RoleID = 4 là Staff)
        if (currentUser == null || currentUser.getRoleID() != 4) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Only Staff (RoleID = 4) can access. Your RoleID: " + currentUser.getRoleID());
            return;
        }
        
        try {
            DAOCVAssignment daoCVAssignment = new DAOCVAssignment();
            List<CVAssignment> assignedCVs = daoCVAssignment.getAssignedCVsForStaff(currentUser.getUserID());
            
            LOGGER.info("Staff " + currentUser.getUserID() + " has " + assignedCVs.size() + " assigned CVs");
            
            request.setAttribute("assignedCVs", assignedCVs);
            request.setAttribute("staffId", currentUser.getUserID());
            
            request.getRequestDispatcher(TUTOR_REVIEWS_JSP).forward(request, response);
            
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error loading CV assignments for staff", ex);
            request.setAttribute("error", "Lỗi khi tải danh sách CV: " + ex.getMessage());
            request.getRequestDispatcher(TUTOR_REVIEWS_JSP).forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
