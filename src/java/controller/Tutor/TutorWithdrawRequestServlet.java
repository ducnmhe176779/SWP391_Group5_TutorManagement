package controller.Tutor;

import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOTutor;
import model.DAOTutorEarning;
import model.DAOMonthlyWithdrawalRequest;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

@WebServlet(name = "TutorWithdrawRequestServlet", urlPatterns = {"/tutor/withdrawRequest"})
public class TutorWithdrawRequestServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TutorWithdrawRequestServlet.class.getName());
    private static final Pattern BANK_INFO_PATTERN = Pattern.compile("^(STK:\\s*)?\\d+\\s*-\\s*[A-Za-zÀ-ỹ\\s]+");
    private static final Pattern DATE_SEARCH_PATTERN = Pattern.compile("^((\\d{1,2})|(\\d{1,2}/\\d{4})|(\\d{4}))$");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if (path.equals("/tutor/getTotalEarnings")) {
            handleGetTotalEarnings(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRoleID() != 3) {
            LOGGER.log(Level.WARNING, "Unauthorized access attempt by user: {0}", 
                      user != null ? user.getUserID() : "null");
            resp.sendRedirect(req.getContextPath() + "/error-403.jsp");
            return;
        }

        DAOTutor dao = new DAOTutor();
        int tutorID = dao.getTutorIdByUserId(user.getUserID());
        DAOTutorEarning daoTutorEarning = new DAOTutorEarning();
        DAOMonthlyWithdrawalRequest daoWithdrawalRequest = new DAOMonthlyWithdrawalRequest();

        String searchField = req.getParameter("searchField");
        String search = req.getParameter("search");
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");

        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "RequestDate";
        }
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "desc";
        }
        if (searchField == null || searchField.isEmpty()) {
            searchField = "WithdrawStatus";
        }

        if ("RequestDate".equalsIgnoreCase(searchField) && search != null && !search.trim().isEmpty()) {
            if (!DATE_SEARCH_PATTERN.matcher(search.trim()).matches()) {
                req.setAttribute("error", "Giá trị tìm kiếm ngày không hợp lệ. Vui lòng nhập theo dạng: ngày (VD: 15), tháng/năm (VD: 03/2025), hoặc năm (VD: 2025)");
            }
        }

        req.setAttribute("searchField", searchField);
        req.setAttribute("search", search);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortOrder", sortOrder);

        Map<String, Double> monthEarnings = daoTutorEarning.getEarningMonthsWithTotalByTutorId(tutorID);
        req.setAttribute("monthEarnings", monthEarnings);
        req.setAttribute("months", monthEarnings.keySet());
        req.setAttribute("requests", daoWithdrawalRequest.getWithdrawalRequestsByTutorId(tutorID, searchField, search, sortBy, sortOrder));
        req.getRequestDispatcher("/tutor/withdrawRequest.jsp").forward(req, resp);
    }

    private void handleGetTotalEarnings(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRoleID() != 3) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("0");
            return;
        }

        String month = req.getParameter("month");
        if (month == null || month.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("0");
            return;
        }

        DAOTutor dao = new DAOTutor();
        int tutorID = dao.getTutorIdByUserId(user.getUserID());
        DAOTutorEarning daoTutorEarning = new DAOTutorEarning();

        Map<String, Double> monthEarnings = daoTutorEarning.getEarningMonthsWithTotalByTutorId(tutorID);
        Double totalEarnings = monthEarnings.getOrDefault(month, 0.0);
        resp.setContentType("text/plain");
        resp.getWriter().write(totalEarnings.toString());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRoleID() != 3) {
            LOGGER.log(Level.WARNING, "Unauthorized access attempt by user: {0}", 
                      user != null ? user.getUserID() : "null");
            resp.sendRedirect(req.getContextPath() + "/error-403.jsp");
            return;
        }

        DAOTutor dao = new DAOTutor();
        DAOTutorEarning daoTutorEarning = new DAOTutorEarning();
        DAOMonthlyWithdrawalRequest daoWithdrawalRequest = new DAOMonthlyWithdrawalRequest();

        int tutorID = dao.getTutorIdByUserId(user.getUserID());

        String month = req.getParameter("month");
        String content = req.getParameter("content");

        if (month == null || month.isEmpty()) {
            req.setAttribute("error", "Vui lòng chọn tháng để rút tiền.");
            Map<String, Double> monthEarnings = daoTutorEarning.getEarningMonthsWithTotalByTutorId(tutorID);
            req.setAttribute("monthEarnings", monthEarnings);
            req.setAttribute("months", monthEarnings.keySet());
            req.setAttribute("requests", daoWithdrawalRequest.getWithdrawalRequestsByTutorId(tutorID));
            req.getRequestDispatcher("/tutor/withdrawRequest.jsp").forward(req, resp);
            return;
        }

        LocalDate currentDate = LocalDate.now();
        String currentMonth = String.format("%d-%02d", currentDate.getYear(), currentDate.getMonthValue());
        if (month.compareTo(currentMonth) >= 0) {
            req.setAttribute("error", "Bạn chỉ có thể rút tiền của các tháng trước tháng hiện tại (" + currentMonth + ").");
            Map<String, Double> monthEarnings = daoTutorEarning.getEarningMonthsWithTotalByTutorId(tutorID);
            req.setAttribute("monthEarnings", monthEarnings);
            req.setAttribute("months", monthEarnings.keySet());
            req.setAttribute("requests", daoWithdrawalRequest.getWithdrawalRequestsByTutorId(tutorID));
            req.getRequestDispatcher("/tutor/withdrawRequest.jsp").forward(req, resp);
            return;
        }

        Map<String, Double> monthEarnings = daoTutorEarning.getEarningMonthsWithTotalByTutorId(tutorID);
        if (!monthEarnings.containsKey(month)) {
            req.setAttribute("error", "Tháng " + month + " không hợp lệ hoặc đã được thanh toán.");
            req.setAttribute("monthEarnings", monthEarnings);
            req.setAttribute("months", monthEarnings.keySet());
            req.setAttribute("requests", daoWithdrawalRequest.getWithdrawalRequestsByTutorId(tutorID));
            req.getRequestDispatcher("/tutor/withdrawRequest.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra trạng thái "Pending" để tránh gửi nhiều request
        if (daoWithdrawalRequest.hasPendingWithdrawalRequest(tutorID, month)) {
            req.setAttribute("error", "Tháng " + month + " đã có yêu cầu rút tiền đang chờ xử lý.");
            req.setAttribute("monthEarnings", monthEarnings);
            req.setAttribute("months", monthEarnings.keySet());
            req.setAttribute("requests", daoWithdrawalRequest.getWithdrawalRequestsByTutorId(tutorID));
            req.getRequestDispatcher("/tutor/withdrawRequest.jsp").forward(req, resp);
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập thông tin tài khoản ngân hàng.");
            req.setAttribute("monthEarnings", monthEarnings);
            req.setAttribute("months", monthEarnings.keySet());
            req.setAttribute("requests", daoWithdrawalRequest.getWithdrawalRequestsByTutorId(tutorID));
            req.getRequestDispatcher("/tutor/withdrawRequest.jsp").forward(req, resp);
            return;
        }

        content = content.trim();
        if (!BANK_INFO_PATTERN.matcher(content).matches()) {
            req.setAttribute("error", "Thông tin tài khoản ngân hàng không đúng định dạng. Vui lòng nhập theo mẫu: [số tài khoản] - [tên ngân hàng] (VD: 0912392235 - MB Bank)");
            req.setAttribute("monthEarnings", monthEarnings);
            req.setAttribute("months", monthEarnings.keySet());
            req.setAttribute("requests", daoWithdrawalRequest.getWithdrawalRequestsByTutorId(tutorID));
            req.getRequestDispatcher("/tutor/withdrawRequest.jsp").forward(req, resp);
            return;
        }

        String[] parts = content.split("\\s*-\\s*");
        String accountNumber = parts[0].replaceAll("STK:\\s*", "");
        String bankName = parts[1];
        content = "STK: " + accountNumber + " - Ngân hàng " + bankName;

        double amount = monthEarnings.get(month);
        boolean success = daoWithdrawalRequest.createWithdrawalRequest(tutorID, month, amount, content);
        if (success) {
            req.setAttribute("message", "Yêu cầu rút tiền cho tháng " + month + " đã được gửi thành công.");
        } else {
            req.setAttribute("error", "Có lỗi xảy ra khi gửi yêu cầu rút tiền. Vui lòng thử lại.");
        }

        monthEarnings = daoTutorEarning.getEarningMonthsWithTotalByTutorId(tutorID);
        req.setAttribute("monthEarnings", monthEarnings);
        req.setAttribute("months", monthEarnings.keySet());
        req.setAttribute("requests", daoWithdrawalRequest.getWithdrawalRequestsByTutorId(tutorID));
        req.getRequestDispatcher("/tutor/withdrawRequest.jsp").forward(req, resp);
    }
}