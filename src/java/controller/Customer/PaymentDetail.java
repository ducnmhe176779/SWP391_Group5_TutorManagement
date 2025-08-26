/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Customer;

import entity.Schedule;
import entity.Subject;
import entity.Tutor;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DAOSchedule;
import model.DAOSubject;
import model.DAOTutor;
import model.DAOUser;

/**
 *
 * @author minht
 */
@WebServlet(name = "PaymentDetail", urlPatterns = {"/PaymentDetail"})
public class PaymentDetail extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PaymentDetail</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PaymentDetail at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        // Xử lý giống như doPost để hiển thị chi tiết thanh toán
        doPost(request, response);
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
        HttpSession session = request.getSession();
        DAOUser daoUser = new DAOUser();
        User user = (User) session.getAttribute("user");
        int id = user.getUserID();

        // Kiểm tra người dùng đã đăng nhập chưa
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy dữ liệu từ form hoặc từ forward
        String[] scheduleIds = request.getParameterValues("scheduleIds");
        String tutorId = request.getParameter("tutorId");
        String subjectId = request.getParameter("subjectId");
        
        // Nếu không có trong parameters, lấy từ attributes (từ forward)
        if (scheduleIds == null) {
            scheduleIds = (String[]) request.getAttribute("scheduleIds");
        }
        if (tutorId == null) {
            tutorId = (String) request.getAttribute("tutorId");
        }
        if (subjectId == null) {
            subjectId = (String) request.getAttribute("subjectId");
        }

        // Kiểm tra dữ liệu đầu vào
        if (scheduleIds == null || tutorId == null || subjectId == null) {
            response.sendRedirect("bookschedule?subjectId=" + subjectId + "&tutorId=" + tutorId + "&error=Missing information");
            return;
        }

        // Lấy thông tin từ cơ sở dữ liệu
        DAOTutor daoTutor = new DAOTutor();
        DAOSubject daoSubject = new DAOSubject();
        DAOSchedule daoSchedule = new DAOSchedule();

        // Lấy thông tin gia sư
        String fullName = daoTutor.getFullNameByTutorId(Integer.parseInt(tutorId));
        int tutorID = Integer.parseInt(tutorId);
        Tutor tutor = daoTutor.getTutorById(Integer.parseInt(tutorId));

        if (tutor == null) {
            response.sendRedirect("bookschedule?subjectId=" + subjectId + "&tutorId=" + tutorId + "&error=Invalid tutor");
            return;
        }

        // Lấy thông tin môn học
        Subject subject = null;
        try {
            subject = daoSubject.getSubjectById(Integer.parseInt(subjectId));
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDetail.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (subject == null) {
            response.sendRedirect("bookschedule?subjectId=" + subjectId + "&tutorId=" + tutorId + "&error=Invalid subject");
            return;
        }

        // Lấy danh sách lịch học đã chọn
        List<Schedule> selectedSchedules = new ArrayList<>();
        for (String scheduleId : scheduleIds) {
            Schedule schedule = daoSchedule.getScheduleById(Integer.parseInt(scheduleId));
            if (schedule != null) {
                selectedSchedules.add(schedule);
            }
        }

        // Kiểm tra nếu không có lịch học nào hợp lệ
        if (selectedSchedules.isEmpty()) {
            response.sendRedirect("bookschedule?subjectId=" + subjectId + "&tutorId=" + tutorId + "&error=No valid schedules selected");
            return;
        }

        // Tính tổng giá (giả định mỗi slot 200,000 VNĐ)
        float pricePerSlot = daoTutor.getPriceByTutorId(tutorID);

        // Lưu thông tin vào session để sử dụng trong payment.jsp và sau khi thanh toán
        session.setAttribute("scheduleIds", scheduleIds);
        session.setAttribute("tutorId", tutorId);
        session.setAttribute("subjectId", subjectId);
        session.setAttribute("totalAmount", pricePerSlot);
        session.setAttribute("tutorName", fullName);
        session.setAttribute("subjectName", subject.getSubjectName());
        session.setAttribute("selectedSchedules", selectedSchedules);

        // Chuyển tiếp đến payment.jsp
        request.getRequestDispatcher("payment.jsp").forward(request, response);

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
