package AdminController;

import entity.User;
import model.DAOUser;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StaffListServlet", urlPatterns = {"/admin/StaffList"})
public class StaffListServlet extends HttpServlet {

    private static final String STAFF_LIST_PAGE = "/admin/staff-list.jsp";
    private static final String LOGIN_PAGE = "login.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(LOGIN_PAGE);
            return;
        }

        DAOUser daoUser = new DAOUser();
        List<User> staffList = daoUser.getUsersByRole(4); // RoleID = 4 cho Staff

        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher(STAFF_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(LOGIN_PAGE);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        DAOUser daoUser = new DAOUser();
        int userId;

        try {
            userId = Integer.parseInt(request.getParameter("userId"));
        } catch (NumberFormatException e) {
            out.write("{\"success\": false, \"message\": \"Invalid user ID!\"}");
            out.flush();
            return;
        }

        if ("deactivate".equals(action)) {
            if (daoUser.updateUserStatus(userId, 0)) {
                out.write("{\"success\": true, \"message\": \"Staff deactivated successfully!\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Failed to deactivate staff or staff not found!\"}");
            }
        } else if ("activate".equals(action)) {
            if (daoUser.updateUserStatus(userId, 1)) {
                out.write("{\"success\": true, \"message\": \"Staff activated successfully!\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Failed to activate staff or staff not found!\"}");
            }
        } else {
            out.write("{\"success\": false, \"message\": \"Invalid action!\"}");
        }
        out.flush();
    }
}