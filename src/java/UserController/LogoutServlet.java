package UserController;

import model.DAOHistoryLog;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entity.User;


@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            String redirectUrl = request.getContextPath() + "/login.jsp";

            if (session != null) {
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    // Log thông tin logout trước khi xóa session
                    System.out.println("User " + user.getFullName() + " (Role ID: " + user.getRoleID() + ") is logging out");
                    
                    // Thử ghi log logout (không bắt buộc)
                    try {
                        System.out.println("Attempting to log logout for user ID: " + user.getUserID());
                        DAOHistoryLog logDAO = new DAOHistoryLog();
                        System.out.println("DAOHistoryLog created successfully");
                        
                        // Kiểm tra connection
                        if (logDAO.getConnection() != null) {
                            System.out.println("Database connection is available");
                            logDAO.logLogout(user.getUserID());
                            System.out.println("Logout logged to database successfully");
                        } else {
                            System.out.println("Database connection is null");
                        }
                    } catch (Exception e) {
                        System.err.println("Warning: Could not log logout to database: " + e.getMessage());
                        e.printStackTrace();
                        // Không để lỗi logging làm gián đoạn quá trình logout
                    }
                }
                
                // Xóa session
                session.removeAttribute("userId");
                session.removeAttribute("user");
                session.invalidate();
                System.out.println("Session invalidated successfully");
            }

            // Ngăn caching
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
            
        } catch (Exception e) {
            System.err.println("Critical error in LogoutServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Fallback: chuyển về trang login ngay cả khi có lỗi
            try {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } catch (Exception redirectError) {
                System.err.println("Failed to redirect after error: " + redirectError.getMessage());
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Logout Servlet";
    }
}