/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package UserController;

import entity.Cv;
import entity.Subject;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DAOCv;
import model.DAOSubject;

@WebServlet(name = "CVController", urlPatterns = {"/cv"})
public class CVController extends HttpServlet {

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

        DAOCv dao = new DAOCv();
        DAOSubject dao2 = new DAOSubject();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra user đã đăng nhập chưa
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int userId = user.getUserID();

        String submit = request.getParameter("submit");

        // Lấy danh sách môn học để hiển thị trong form
        List<Subject> listSub = dao2.getAllSubjects();
        request.setAttribute("listSub", listSub);

        if (submit == null) {
            // Kiểm tra trạng thái CV hiện tại của người dùng
            if (dao.hasPendingOrApprovedCv(userId)) {
                session.setAttribute("message", "You already have a pending or approved CV. Please wait until it is rejected to submit a new one.");
                session.setAttribute("messageType", "warning");
            }
            request.getRequestDispatcher("/sendCV.jsp").forward(request, response);
        } else {
            // Xử lý khi người dùng gửi CV
            if (dao.hasPendingOrApprovedCv(userId)) {
                session.setAttribute("message", "You cannot submit a new CV while your current CV is pending or approved.");
                session.setAttribute("messageType", "error");
                request.getRequestDispatcher("/sendCV.jsp").forward(request, response);
                return;
            }

            // Lấy dữ liệu từ form
            String education = request.getParameter("education");
            String experience = request.getParameter("experience");
            String certificates = request.getParameter("certificates");
            int subjectId = Integer.parseInt(request.getParameter("Subject"));
            String description = request.getParameter("Description");
            String skill = request.getParameter("Skill");
            float price = Float.parseFloat(request.getParameter("Price"));
            

            // Gửi CV mới
            int n = dao.sendCv(new Cv(0, userId, education, experience, certificates, "Pending", subjectId, description,skill,price));
            if (n > 0) {
                session.setAttribute("message", "CV submitted successfully!");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to submit CV. Please try again.");
                session.setAttribute("messageType", "error");
            }
            request.getRequestDispatcher("/sendCV.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "CV submission controller";
    }
}


