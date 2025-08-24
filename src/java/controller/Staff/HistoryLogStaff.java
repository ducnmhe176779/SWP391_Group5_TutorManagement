/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.Staff;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOHistoryLog;
import entity.HistoryLog;
import entity.User;

@WebServlet(name = "HistoryLogStaff", urlPatterns = {"/staff/historyLog"})
public class HistoryLogStaff extends HttpServlet {

    private DAOHistoryLog dao;

    @Override
    public void init() throws ServletException {
        dao = new DAOHistoryLog(); // Khởi tạo DAO
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleID() != 4) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        try {
            DAOHistoryLog dao = new DAOHistoryLog(); // Tạo mới mỗi lần
            List<HistoryLog> logs = dao.getUserAndTutorLogs();
            request.setAttribute("logs", logs);
            request.getRequestDispatcher("/staff/historylog.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading user and tutor logs: " + e.getMessage());
            request.getRequestDispatcher("/staff/historylog.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to display history logs of Users and Tutors for Staff";
    }
}