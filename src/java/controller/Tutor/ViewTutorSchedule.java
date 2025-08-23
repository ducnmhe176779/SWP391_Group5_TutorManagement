package controller.Tutor;

import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.DAOSchedule;
import model.DAOTutor;
import model.DAOBooking; // Thêm import để sử dụng DAOBooking

@WebServlet(name = "ViewTutorSchedule", urlPatterns = {"/tutor/ViewTutorSchedule"})
public class ViewTutorSchedule extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String service = request.getParameter("service");

        // Kiểm tra service để gọi phương thức tương ứng
        if ("confirmCompletion".equals(service)) {
            confirmCompletion(request, response);
        } else {
            // Mặc định: Hiển thị lịch trình
            displaySchedule(request, response);
        }
    }

    // Phương thức hiển thị lịch trình (logic hiện tại)
    private void displaySchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        DAOTutor dao = new DAOTutor();
        DAOSchedule daoSchedule = new DAOSchedule();
        // Lấy tham số search từ request, nếu không có thì mặc định là chuỗi rỗng
        String search = request.getParameter("search") != null ? request.getParameter("search") : "";
        int id = dao.getTutorIdByUserId(user.getUserID());
        // Lấy danh sách lịch trình của giáo viên, có lọc theo search
        List<Map<String, Object>> schedules = daoSchedule.getSchedulesByTutorIdd(id, search);
        System.out.println("Schedules retrieved for Tutor ID " + id + " with search '" + search + "': " + schedules);
        request.setAttribute("schedules", schedules);
        request.setAttribute("search", search);

        // Chuyển tiếp đến trang JSP để hiển thị
        request.getRequestDispatcher("/tutor/viewTutorSchedule.jsp").forward(request, response);
    }

    // Phương thức xử lý confirmCompletion
    private void confirmCompletion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DAOBooking daoBooking = new DAOBooking();

        // Lấy bookingId từ tham số URL
        int bookingId;
        try {
            bookingId = Integer.parseInt(request.getParameter("bookingId"));
        } catch (NumberFormatException e) {
            // Nếu bookingId không hợp lệ, lưu thông báo lỗi và làm mới trang
            session.setAttribute("errorMessage", "Invalid Booking ID.");
            response.sendRedirect("ViewTutorSchedule");
            return;
        }

        // Gọi hàm changeBookingStatusToCompleted từ DAOBooking
        int result = daoBooking.changeBookingStatusToCompleted(bookingId);
        if (result > 0) {
            session.setAttribute("successMessage", "Session confirmed as completed successfully!");
        } else {
            session.setAttribute("errorMessage", "Failed to confirm session: Booking not found.");
        }

        // Chuyển hướng về chính trang này để làm mới lịch
        response.sendRedirect("ViewTutorSchedule");
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
        return "Displays tutor's schedule";
    }
}