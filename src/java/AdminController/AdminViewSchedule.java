/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package AdminController;

import entity.Schedule;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Map;
import model.DAOSchedule;
import model.ScheduleDAO;

/**
 *
 * @author Heizxje
 */
@WebServlet(name = "AdminViewSchedule", urlPatterns = {"/admin/AdminViewSchedule"})
public class AdminViewSchedule extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNumber = 1;
        int pageSize = 5;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                pageNumber = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                pageNumber = 1;
            }
        }

        ScheduleDAO scheduleDAO = new ScheduleDAO();
        Map<String, Object> result = scheduleDAO.getSchedulesWithPaginationStatusPending(pageNumber, pageSize);
        
        System.out.println("Current Page: " + pageNumber);
        System.out.println("Total Pages: " + result.get("totalPages"));
        System.out.println("Schedules: " + result.get("schedules"));
        
        request.setAttribute("schedules", result.get("schedules"));
        request.setAttribute("totalPages", result.get("totalPages"));
        request.setAttribute("currentPage", pageNumber);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/viewschedule.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));

        ScheduleDAO dao = new ScheduleDAO();
        boolean isApproved = dao.approveSchedule(scheduleID);

        if (isApproved) {
            doGet(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error approving schedule");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Admin Schedule Management Servlet";
    }
}