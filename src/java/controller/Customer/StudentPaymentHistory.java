package controller.Customer;

import entity.User;
import entity.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.DAOPayment;

@WebServlet(name = "StudentPaymentHistory", urlPatterns = {"/StudentPaymentHistory"})
public class StudentPaymentHistory extends HttpServlet {

    private static final int PAGE_SIZE = 10; // Số bản ghi mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập và vai trò
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy UserID từ session
        int userID = user.getUserID();
        DAOPayment daoPayment = new DAOPayment();

        // Lấy số trang hiện tại từ tham số request (mặc định là trang 1)
        String pageStr = request.getParameter("page");
        int page = 1;
        try {
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Lấy danh sách thanh toán của học viên theo UserID
        List<Payment> paymentHistory = daoPayment.getPaymentsByUserId(userID);

        // Tính tổng số bản ghi và số trang
        int totalPayments = paymentHistory.size();
        int totalPages = (int) Math.ceil((double) totalPayments / PAGE_SIZE);

        // Lấy danh sách bản ghi cho trang hiện tại
        int start = (page - 1) * PAGE_SIZE;
        int end = Math.min(start + PAGE_SIZE, totalPayments);
        List<Payment> paymentsForPage = paymentHistory.subList(start, end);

        // Đảm bảo page không vượt quá totalPages
        if (page < 1) {
            page = 1;
        } else if (page > totalPages && totalPages > 0) {
            page = totalPages;
            paymentsForPage = paymentHistory.subList((page - 1) * PAGE_SIZE, end);
        }

        // Truyền dữ liệu cho JSP
        request.setAttribute("paymentHistory", paymentsForPage);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/user/studentPaymentHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Displays payment history for student";
    }
}