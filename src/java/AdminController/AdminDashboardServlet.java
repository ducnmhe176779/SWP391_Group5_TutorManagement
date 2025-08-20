package AdminController;

import entity.User;
import entity.HistoryLog;
import entity.Payment;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOUser;
import model.DAOHistoryLog;
import model.DAOPayment;
import model.DAOTutorRating;
import model.DAOBooking;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== AdminDashboardServlet START ===");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập
        if (currentUser == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Kiểm tra quyền Admin (RoleID = 1)
        if (currentUser.getRoleID() != 1) {
            System.out.println("User not admin, redirecting to home");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        System.out.println("Admin user: " + currentUser.getFullName() + " (ID: " + currentUser.getUserID() + ")");

        // Khởi tạo các danh sách dữ liệu với giá trị mặc định
        List<User> newUsers = new ArrayList<>();
        List<HistoryLog> recentLogs = new ArrayList<>();
        List<Payment> recentPayments = new ArrayList<>();
        double totalProfit = 0.0;
        int totalRatings = 0;
        int totalUsers = 0;
        int totalBookings = 0;

        try {
            System.out.println("Initializing DAOs...");
            
            // Khởi tạo các DAO một cách an toàn
            DAOUser daoUser = new DAOUser();
            System.out.println("DAOUser initialized");
            
            DAOHistoryLog daoHistoryLog = new DAOHistoryLog();
            System.out.println("DAOHistoryLog initialized");
            
            DAOPayment daoPayment = new DAOPayment();
            System.out.println("DAOPayment initialized");
            
            DAOTutorRating daoTutorRating = new DAOTutorRating();
            System.out.println("DAOTutorRating initialized");
            
            DAOBooking daoBooking = new DAOBooking();
            System.out.println("DAOBooking initialized");

            // Lấy danh sách new users
            try {
                System.out.println("Getting new users...");
                newUsers = daoUser.getNewUsers();
                if (newUsers == null) newUsers = new ArrayList<>();
                System.out.println("New users count: " + newUsers.size());
            } catch (Exception e) {
                System.out.println("Error getting new users: " + e.getMessage());
                e.printStackTrace();
                newUsers = new ArrayList<>();
            }

            // Lấy danh sách history logs
            try {
                System.out.println("Getting recent logs...");
                recentLogs = daoHistoryLog.getRecentLogs();
                if (recentLogs == null) recentLogs = new ArrayList<>();
                System.out.println("Recent logs count: " + recentLogs.size());
            } catch (Exception e) {
                System.out.println("Error getting recent logs: " + e.getMessage());
                e.printStackTrace();
                recentLogs = new ArrayList<>();
            }

            // Lấy tổng profit từ Payment với trạng thái Completed
            try {
                System.out.println("Getting total profit...");
                totalProfit = daoPayment.getTotalProfit();
                System.out.println("Total profit: " + totalProfit);
            } catch (Exception e) {
                System.out.println("Error getting total profit: " + e.getMessage());
                e.printStackTrace();
                totalProfit = 0.0;
            }

            // Lấy tổng số rating từ TutorRating
            try {
                System.out.println("Getting total ratings...");
                totalRatings = daoTutorRating.getTotalRatings();
                System.out.println("Total ratings: " + totalRatings);
            } catch (Exception e) {
                System.out.println("Error getting total ratings: " + e.getMessage());
                e.printStackTrace();
                totalRatings = 0;
            }

            // Lấy tổng số user từ Users
            try {
                System.out.println("Getting total users...");
                totalUsers = daoUser.getTotalUsers();
                System.out.println("Total users: " + totalUsers);
            } catch (Exception e) {
                System.out.println("Error getting total users: " + e.getMessage());
                e.printStackTrace();
                totalUsers = 0;
            }

            // Lấy tổng số booking từ Booking với trạng thái Confirmed và Completed
            try {
                System.out.println("Getting total bookings...");
                totalBookings = daoBooking.getTotalConfirmedAndCompletedBookings();
                System.out.println("Total bookings: " + totalBookings);
            } catch (Exception e) {
                System.out.println("Error getting total bookings: " + e.getMessage());
                e.printStackTrace();
                totalBookings = 0;
            }

            // Lấy 5 giao dịch gần nhất từ Payment
            try {
                System.out.println("Getting recent payments...");
                recentPayments = daoPayment.getRecentPayments();
                if (recentPayments == null) recentPayments = new ArrayList<>();
                System.out.println("Recent payments count: " + recentPayments.size());
            } catch (Exception e) {
                System.out.println("Error getting recent payments: " + e.getMessage());
                e.printStackTrace();
                recentPayments = new ArrayList<>();
            }

        } catch (Exception e) {
            System.out.println("Critical error in AdminDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            // Không set error attribute để tránh crash JSP
        }

        // Set tất cả attributes
        System.out.println("Setting attributes...");
        request.setAttribute("newUsers", newUsers);
        request.setAttribute("logs", recentLogs);
        request.setAttribute("totalProfit", totalProfit);
        request.setAttribute("totalRatings", totalRatings);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("recentPayments", recentPayments);

        System.out.println("Attributes set successfully");
        System.out.println("Forwarding to /admin/index.jsp");

        request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
        
        System.out.println("=== AdminDashboardServlet END ===");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
