package AdminController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOTutorEarning;
import entity.User;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SystemRevenueServlet", urlPatterns = {"/admin/systemRevenue"})
public class SystemRevenueServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SystemRevenueServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRoleID() != 1) {
            LOGGER.log(Level.WARNING, "Unauthorized access attempt by user: {0}",
                    user != null ? user.getUserID() : "null");
            resp.sendRedirect(req.getContextPath() + "/error-403.jsp");
            return;
        }

        DAOTutorEarning daoTutorEarning = new DAOTutorEarning();

        String searchField = req.getParameter("searchField");
        String search = req.getParameter("search");
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");

        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "Month";
        }
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "desc";
        }
        if (searchField == null || searchField.isEmpty()) {
            searchField = "Month";
        }

        String error = null;
        if (search != null && !search.trim().isEmpty()) {
            if (searchField.equals("Month")) {
                if (search.matches("\\d{1,2}")) { // Tháng: 1-12
                    int month = Integer.parseInt(search);
                    if (month < 1 || month > 12) {
                        error = "Tháng phải từ 1 đến 12.";
                        search = null;
                    }
                } else if (search.matches("\\d{4}")) { // Năm: 2024
                    // Hợp lệ, không cần kiểm tra thêm
                } else if (search.matches("\\d{4}-\\d{2}|\\d{4}/\\d{2}")) { // Định dạng: 2025-01 hoặc 2025/01
                    String[] parts = search.replace("/", "-").split("-");
                    int month = Integer.parseInt(parts[1]);
                    if (month < 1 || month > 12) {
                        error = "Tháng phải từ 1 đến 12.";
                        search = null;
                    }
                } else {
                    error = "Nhập tháng (VD: 3), năm (VD: 2024), hoặc định dạng yyyy-MM (VD: 2025-01, 2025/01).";
                    search = null;
                }
            } else {
                try {
                    Double.parseDouble(search);
                } catch (NumberFormatException e) {
                    error = "Nhập số cho " + searchField + " (VD: 1000000).";
                    search = null;
                }
            }
        }

        double totalRevenue = daoTutorEarning.getSystemTotalRevenue();
        double tutorPayments = daoTutorEarning.getSystemTutorPayments();
        double totalProfit = daoTutorEarning.getSystemProfit();
        Map<String, Map<String, Double>> monthlyDetails = daoTutorEarning.getMonthlyRevenueDetails(searchField, search, sortBy, sortOrder);

        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("tutorPayments", tutorPayments);
        req.setAttribute("totalProfit", totalProfit);
        req.setAttribute("monthlyDetails", monthlyDetails);
        req.setAttribute("searchField", searchField);
        req.setAttribute("search", search);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortOrder", sortOrder);
        if (error != null) {
            req.setAttribute("error", error);
        }

        req.getRequestDispatcher("/admin/systemRevenue.jsp").forward(req, resp);
    }
}
