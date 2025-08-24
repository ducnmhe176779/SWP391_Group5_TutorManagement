package AdminController;

import model.*;
import entity.MonthlyWithdrawalRequest;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOMonthlyWithdrawalRequest;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

@WebServlet(name = "AdminWithdrawalApprovalController", urlPatterns = {"/admin/approveWithdrawal"})
public class AdminWithdrawalApprovalController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminWithdrawalApprovalController.class.getName());
    private static final Pattern DATE_SEARCH_PATTERN = Pattern.compile("^((\\d{1,2})|(\\d{1,2}/\\d{4})|(\\d{4}))$");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra quyền truy cập
        if (user == null || user.getRoleID() != 1) { // Giả sử RoleID 1 là admin
            LOGGER.log(Level.WARNING, "Unauthorized access attempt by user: {0}", 
                      user != null ? user.getUserID() : "null");
            resp.sendRedirect(req.getContextPath() + "/error-403.jsp");
            return;
        }

        // Lấy tham số tìm kiếm, sắp xếp và phân trang
        String searchField = req.getParameter("searchField");
        String search = req.getParameter("search");
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");
        int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
        int pageSize = 10;

        // Thiết lập giá trị mặc định
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "RequestDate";
        }
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "desc";
        }
        if (searchField == null || searchField.isEmpty()) {
            searchField = "WithdrawStatus";
        }

        // Validation giá trị tìm kiếm theo ngày
        if ("RequestDate".equalsIgnoreCase(searchField) && search != null && !search.trim().isEmpty()) {
            if (!DATE_SEARCH_PATTERN.matcher(search.trim()).matches()) {
                req.setAttribute("error", "Giá trị tìm kiếm ngày không hợp lệ. Vui lòng nhập theo dạng: ngày (VD: 15), tháng/năm (VD: 03/2025), hoặc năm (VD: 2025)");
                req.setAttribute("searchField", searchField);
                req.setAttribute("search", search);
                req.setAttribute("sortBy", sortBy);
                req.setAttribute("sortOrder", sortOrder);
                req.getRequestDispatcher("/admin/approveWithdrawal.jsp").forward(req, resp);
                return;
            }
        }

        // Lưu các tham số để sử dụng trong JSP
        req.setAttribute("searchField", searchField);
        req.setAttribute("search", search);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortOrder", sortOrder);
        req.setAttribute("currentPage", page);

        // Lấy danh sách yêu cầu với tìm kiếm, sắp xếp và phân trang
        try {
            DAOMonthlyWithdrawalRequest requestDAO = new DAOMonthlyWithdrawalRequest();
            List<MonthlyWithdrawalRequest> requests = requestDAO.getAllRequestsWithTutorName(searchField, search, sortBy, sortOrder, page, pageSize);
            int totalRecords = requestDAO.getTotalRequestCount(searchField, search);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            req.setAttribute("requests", requests);
            req.setAttribute("totalPages", totalPages);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving withdrawal requests", e);
            req.setAttribute("error", "Có lỗi xảy ra khi lấy danh sách yêu cầu rút tiền: " + e.getMessage());
        }

        // Chuyển hướng đến trang JSP để hiển thị danh sách
        req.getRequestDispatcher("/admin/approveWithdrawal.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra quyền truy cập
        if (user == null || user.getRoleID() != 1) {
            LOGGER.log(Level.WARNING, "Unauthorized access attempt by user: {0}", 
                      user != null ? user.getUserID() : "null");
            resp.sendRedirect(req.getContextPath() + "/error-403.jsp");
            return;
        }

        // Lấy requestID từ form
        int requestID;
        try {
            requestID = Integer.parseInt(req.getParameter("requestID"));
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID yêu cầu không hợp lệ.");
            doGet(req, resp);
            return;
        }

        int adminID = user.getUserID(); // Lấy adminID từ user session
        String action = req.getParameter("action");
        DAOMonthlyWithdrawalRequest requestDAO = new DAOMonthlyWithdrawalRequest();

        // Lấy thông tin yêu cầu để kiểm tra
        MonthlyWithdrawalRequest request = requestDAO.getRequestById(requestID);
        if (request == null) {
            req.setAttribute("error", "Không tìm thấy yêu cầu rút tiền với ID: " + requestID);
            doGet(req, resp);
            return;
        }

        // Kiểm tra trạng thái hiện tại của yêu cầu
        if (!"Pending".equalsIgnoreCase(request.getWithdrawStatus())) {
            req.setAttribute("error", "Yêu cầu rút tiền với ID: " + requestID + " đã được xử lý trước đó.");
            doGet(req, resp);
            return;
        }

        if ("approve".equals(action)) {
            boolean updated = requestDAO.updateWithdrawalRequestStatus(requestID, adminID, "Paid");
            if (updated) {
                // Cập nhật các yêu cầu khác trong cùng tháng, nhưng không hiển thị lỗi nếu không có gì để cập nhật
                requestDAO.updateAllRequestsInMonth(request.getTutorID(), request.getMonth(), "Paid");
                req.setAttribute("message", "Yêu cầu rút tiền ID " + requestID + " đã được phê duyệt thành công.");
            } else {
                req.setAttribute("error", "Không thể phê duyệt yêu cầu rút tiền ID " + requestID + ". Vui lòng thử lại.");
            }
        } else if ("reject".equals(action)) {
            boolean updated = requestDAO.updateWithdrawalRequestStatus(requestID, adminID, "Rejected");
            if (updated) {
                req.setAttribute("message", "Yêu cầu rút tiền ID " + requestID + " đã bị từ chối.");
            } else {
                req.setAttribute("error", "Không thể từ chối yêu cầu rút tiền ID " + requestID + ". Vui lòng thử lại.");
            }
        } else {
            req.setAttribute("error", "Hành động không hợp lệ.");
        }

        doGet(req, resp);
    }
}