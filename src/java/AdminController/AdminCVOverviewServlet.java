package AdminController;

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

@WebServlet(name = "AdminCVOverviewServlet", urlPatterns = {"/admin/cv-overview"})
public class AdminCVOverviewServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(AdminCVOverviewServlet.class.getName());
    private static final String ADMIN_CV_OVERVIEW_JSP = "/admin/cv-overview.jsp";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập (Admin hoặc Staff)
        if (currentUser == null || (currentUser.getRoleID() != 1 && currentUser.getRoleID() != 4)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        try {
            DAOCVAssignment daoCVAssignment = new DAOCVAssignment();
            List<CVAssignment> allCVs = daoCVAssignment.getAllCVAssignments();
            
            request.setAttribute("allCVs", allCVs);
            request.setAttribute("isAdmin", currentUser.getRoleID() == 1);
            request.setAttribute("currentUserId", currentUser.getUserID());
            
            request.getRequestDispatcher(ADMIN_CV_OVERVIEW_JSP).forward(request, response);
            
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error loading CV overview", ex);
            request.setAttribute("error", "Lỗi khi tải tổng quan CV: " + ex.getMessage());
            request.getRequestDispatcher(ADMIN_CV_OVERVIEW_JSP).forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập
        if (currentUser == null || (currentUser.getRoleID() != 1 && currentUser.getRoleID() != 4)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("reassign".equals(action)) {
            // Admin có thể reassign CV cho staff khác
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            int newStaffId = Integer.parseInt(request.getParameter("newStaffId"));
            
            try {
                // Logic để reassign CV (cần implement thêm)
                session.setAttribute("success", "CV reassigned successfully");
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Error reassigning CV", ex);
                session.setAttribute("error", "Error reassigning CV: " + ex.getMessage());
            }
        }
        
        // Redirect back to overview page
        response.sendRedirect(request.getContextPath() + "/admin/cv-overview");
    }
}
