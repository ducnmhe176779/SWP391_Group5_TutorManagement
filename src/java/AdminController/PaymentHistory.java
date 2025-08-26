package AdminController;

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

@WebServlet(name = "PaymentHistory", urlPatterns = {"/admin/PaymentHistory"})
public class PaymentHistory extends HttpServlet {

    private static final int PAGE_SIZE = 20; // Số bản ghi mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
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

        // Lấy danh sách bản ghi cho trang hiện tại
        List<Payment> paymentHistory = daoPayment.getPaymentsByPageForAdmin(page, PAGE_SIZE);

        // Tính tổng số bản ghi và số trang
        int totalPayments = daoPayment.getTotalPayments();
        int totalPages = (int) Math.ceil((double) totalPayments / PAGE_SIZE);

        // Đảm bảo page không vượt quá totalPages
        if (page < 1) {
            page = 1;
        } else if (page > totalPages && totalPages > 0) {
            page = totalPages;
            paymentHistory = daoPayment.getPaymentsByPageForAdmin(page, PAGE_SIZE);
        }

        // Truyền dữ liệu cho JSP
        request.setAttribute("paymentHistory", paymentHistory);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/admin/viewPayment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Displays payment history for admin";
    }
}