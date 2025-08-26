package AdminController;

import entity.Cv;
import entity.User;
import model.DAOCv;
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

/**
 * Servlet xử lý hiển thị CV có trạng thái 'Pending' cho admin
 * URL: /admin/RequestCV
 * Sử dụng trực tiếp bảng CV, không phải Assignment
 */
@WebServlet(name = "AdminRequestCVServlet", urlPatterns = {"/admin/RequestCV"})
public class AdminRequestCVServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(AdminRequestCVServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập (Chỉ RoleID = 1 là Admin)
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Only Admin can view pending CVs.");
            return;
        }
        
        try {
            DAOCv daoCV = new DAOCv();
            List<Cv> pendingCVs = daoCV.getPendingCVs();
            
            LOGGER.info("Found " + pendingCVs.size() + " pending CVs from CV table for admin " + currentUser.getUserID());
            
            request.setAttribute("pendingCVs", pendingCVs);
            request.setAttribute("totalPendingCVs", pendingCVs.size());
            request.setAttribute("isAdmin", true);
            
            request.getRequestDispatcher("/admin/request-cv.jsp").forward(request, response);
            
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error loading pending CVs page", ex);
            request.setAttribute("error", "Error loading pending CVs page: " + ex.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Only Admin can modify CV status.");
            return;
        }

        String action = request.getParameter("action");
        String cvIdParam = request.getParameter("cvId");
        if (action == null || cvIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/RequestCV");
            return;
        }

        try {
            int cvId = Integer.parseInt(cvIdParam);
            DAOCv daoCv = new DAOCv();
            if ("approve".equalsIgnoreCase(action)) {
                daoCv.updateCVStatus(cvId, "Approved");
            } else if ("reject".equalsIgnoreCase(action)) {
                daoCv.updateCVStatus(cvId, "Rejected");
            }
        } catch (NumberFormatException ex) {
            LOGGER.log(Level.WARNING, "Invalid cvId: " + cvIdParam, ex);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error updating CV status", ex);
        }

        // Quay lại trang danh sách
        response.sendRedirect(request.getContextPath() + "/admin/RequestCV");
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet for admin to view/update pending CVs from CV table";
    }
}
