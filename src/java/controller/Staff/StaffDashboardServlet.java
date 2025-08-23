/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Staff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOUser;
import entity.User;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet xử lý dashboard cho staff, hiển thị 5 người dùng mới nhất.
 * @author Heizxje
 */
@WebServlet(name = "StaffDashboardServlet", urlPatterns = {"/staff/dashboard"})
public class StaffDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StaffDashboardServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "StaffDashboardServlet: Processing GET request");

        // Kiểm tra phiên đăng nhập
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            LOGGER.log(Level.WARNING, "No user session found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if (user.getRoleID() != 4) { // RoleID = 4 cho Staff
                LOGGER.log(Level.WARNING, "Unauthorized access attempt by UserID: {0}, RoleID: {1}", 
                        new Object[]{user.getUserID(), user.getRoleID()});
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        } catch (NullPointerException e) {
            LOGGER.log(Level.SEVERE, "User object is malformed: {0}", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Khởi tạo DAOUser
        DAOUser userDAO = new DAOUser();

        try {
            // Kiểm tra kết nối DB
            if (!userDAO.isConnected()) {
                throw new ServletException("Database connection failed.");
            }

            // Lấy 5 người dùng mới nhất (Tutor, RoleID = 2)
            List<User> newUsers = userDAO.getNewUsers();
            request.setAttribute("newUsers", newUsers);
            LOGGER.log(Level.INFO, "Retrieved {0} new users.", 
                    newUsers != null ? newUsers.size() : 0);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving new users: {0}", e.getMessage());
            request.setAttribute("error", "An error occurred while loading new users: " + e.getMessage());
        } catch (ServletException e) {
            LOGGER.log(Level.SEVERE, "Servlet exception: {0}", e.getMessage());
            request.setAttribute("error", "Database connection error: " + e.getMessage());
        }

        // Chuyển hướng đến trang dashboard
        try {
            LOGGER.log(Level.INFO, "Forwarding to /staff/index_staff.jsp");
            request.getRequestDispatcher("/staff/index_staff.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            LOGGER.log(Level.SEVERE, "Error forwarding to JSP: {0}", e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to load dashboard: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "StaffDashboardServlet: Processing POST request");
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Staff Dashboard Servlet for G4 SmartTutor";
    }
}