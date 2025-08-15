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
        HttpSession session = request.getSession(false);
        String redirectUrl = request.getContextPath() + "/login.jsp";

        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                try {
                    DAOHistoryLog logDAO = new DAOHistoryLog();
                    logDAO.logLogout(user.getUserID());
                } catch (SQLException e) {
                    e.printStackTrace();
                    System.err.println("Error logging logout for user " + user.getUserID() + ": " + e.getMessage());
                }
                if (user.getRoleID() == 1) { // Admin
                    redirectUrl = request.getContextPath() + "/login.jsp";
                } else {
                    redirectUrl = request.getContextPath() + "/login.jsp"; // Hoặc "/indextutor.jsp" tùy yêu cầu
                }
            }
            session.removeAttribute("userId");
            session.removeAttribute("user");
            session.invalidate();
        }

        // Ngăn caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        response.sendRedirect(redirectUrl);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Logout Servlet";
    }
}