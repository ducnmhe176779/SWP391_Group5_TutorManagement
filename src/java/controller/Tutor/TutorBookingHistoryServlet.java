package controller.Tutor;

import entity.TutorEarning;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOTutor;
import model.DAOTutorEarning;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "TutorBookingHistoryServlet", urlPatterns = {"/tutor/bookingHistory"})
public class TutorBookingHistoryServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TutorBookingHistoryServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra quyền truy cập
        if (user == null || user.getRoleID() != 3) {
            LOGGER.log(Level.WARNING, "Unauthorized access attempt by user: {0}", 
                      user != null ? user.getUserID() : "null");
            resp.sendRedirect(req.getContextPath() + "/error-403.jsp");
            return;
        }

        DAOTutor dao = new DAOTutor();
        int tutorID = dao.getTutorIdByUserId(user.getUserID());
        DAOTutorEarning daoTutorEarning = new DAOTutorEarning();

        // Đồng bộ dữ liệu từ Booking sang TutorEarnings
        daoTutorEarning.syncBookingToTutorEarnings(tutorID);

        // Tạo danh sách đầy đủ các tháng từ 1 đến 12
        List<String> availableMonths = new ArrayList<>();
        for (int month = 1; month <= 12; month++) {
            availableMonths.add(String.format("%02d", month));
        }

        // Lấy tham số lọc, tìm kiếm, sorting, phân trang
        String month = req.getParameter("month");
        String search = req.getParameter("search");
        String searchField = req.getParameter("searchField");
        String totalOption = req.getParameter("totalOption");
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");
        int page;
        try {
            page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid page parameter: {0}", req.getParameter("page"));
            page = 1; // Mặc định về trang 1 nếu page không hợp lệ
        }
        int pageSize = 10;

        // Log các tham số để debug
        LOGGER.log(Level.INFO, "Parameters - page: {0}, month: {1}, search: {2}, searchField: {3}, totalOption: {4}, sortBy: {5}, sortOrder: {6}",
                new Object[]{page, month, search, searchField, totalOption, sortBy, sortOrder});

        // Mặc định nếu không có searchField hoặc totalOption
        if (searchField == null || searchField.isEmpty()) {
            searchField = "BookingID";
        }
        if (totalOption == null || totalOption.isEmpty()) {
            totalOption = "filtered";
        }
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "BookingID";
        }
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "asc";
        }

        // Kiểm tra định dạng ngày nếu tìm kiếm theo ngày
        if (searchField.equals("BookingDate") && search != null && !search.isEmpty()) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            dateFormat.setLenient(false);
            try {
                dateFormat.parse(search);
            } catch (Exception e) {
                req.setAttribute("error", "Vui lòng nhập ngày theo định dạng dd/MM/yyyy (ví dụ: 04/01/2025)");
                search = null; // Bỏ qua giá trị tìm kiếm không hợp lệ
            }
        }

        // Lấy tổng số bản ghi trước khi lấy danh sách earnings
        int totalRecords = daoTutorEarning.getTotalRecords(tutorID, search, searchField, month);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Điều chỉnh page nếu vượt quá totalPages
        if (page > totalPages && totalPages > 0) {
            page = totalPages; // Đặt lại page về trang cuối cùng
        } else if (page < 1) {
            page = 1; // Đặt lại page về trang đầu tiên
        }

        // Log thông tin phân trang
        LOGGER.log(Level.INFO, "Total records: {0}, Total pages: {1}, Current page: {2}", 
                new Object[]{totalRecords, totalPages, page});

        // Lấy danh sách thu nhập với lọc theo tháng và tìm kiếm
        List<TutorEarning> earnings = daoTutorEarning.getEarningsByTutorId(tutorID, search, searchField, month, sortBy, sortOrder, page, pageSize);

        // Log số lượng earnings trả về
        LOGGER.log(Level.INFO, "Number of earnings retrieved: {0}", earnings.size());

        // Tính tổng thu nhập theo tùy chọn
        double totalEarnings;
        switch (totalOption) {
            case "all":
                totalEarnings = daoTutorEarning.getTotalEarningsAfterCommission(tutorID, null, null, null);
                break;
            case "currentMonth":
                totalEarnings = daoTutorEarning.getTotalEarningsAfterCommission(tutorID, null, null, month);
                break;
            case "filtered":
            default:
                totalEarnings = daoTutorEarning.getTotalEarningsAfterCommission(tutorID, search, searchField, month);
                break;
        }

        // Truyền dữ liệu vào JSP
        req.setAttribute("earnings", earnings);
        req.setAttribute("totalEarnings", totalEarnings);
        req.setAttribute("totalRecords", totalRecords);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("search", search);
        req.setAttribute("searchField", searchField);
        req.setAttribute("totalOption", totalOption);
        req.setAttribute("selectedMonth", month);
        req.setAttribute("availableMonths", availableMonths);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortOrder", sortOrder);

        req.getRequestDispatcher("/tutor/bookingHistory.jsp").forward(req, resp);
    }
}