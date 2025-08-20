package controller.Customer;

import com.google.gson.Gson;
import entity.Schedule;
import entity.Subject;
import entity.User;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import model.DAOSchedule;
import model.DAOSubject;
import model.ScheduleDAO;

@WebServlet(name = "ViewScheduleServlet", urlPatterns = {"/myschedule"})
public class ViewScheduleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        DAOSchedule daoSchedule = new DAOSchedule();
        User user = (User) request.getSession().getAttribute("user");
        String search = request.getParameter("search") != null ? request.getParameter("search") : "";
        
        List<Map<String, Object>> schedules = daoSchedule.getSchedulesByUserId(user.getUserID(), search);
        System.out.println(schedules);
        request.setAttribute("schedules", schedules);
        request.setAttribute("search", search);
        request.getRequestDispatcher("user/myschedule.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        processRequest(request, response);
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
        
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
