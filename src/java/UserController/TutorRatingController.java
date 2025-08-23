/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package UserController;

import entity.TutorRating;
import entity.User;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOTutorRating;

/**
 *
 * @author minht
 */



@WebServlet(name = "TutorRatingController", urlPatterns = {"/TutorRatingController"})
public class TutorRatingController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String service = request.getParameter("service");

        if (service == null) {
            service = "listRating"; // Mặc định hiển thị danh sách đánh giá
        }

        switch (service) {
            case "addRating":
                handleAddRating(request, response);
                break;
            case "listRating":
                handleListRating(request, response);
                break;
            case "detailRating":
                handleDetailRating(request, response);
                break;
            default:
                response.sendRedirect("error-404.jsp");
        }
    }

    // Xử lý thêm đánh giá
    private void handleAddRating(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("text/html;charset=UTF-8");
    HttpSession session = request.getSession();
    DAOTutorRating dao = new DAOTutorRating();
    User user = (User) session.getAttribute("user");

    // Kiểm tra quyền (chỉ học sinh RoleID = 2 được thêm đánh giá)
    if (user == null || user.getRoleID() != 2) {
        response.sendRedirect("error-403.jsp");
        return;
    }

    String submit = request.getParameter("submit");
    if (submit == null) {
        // Hiển thị form nếu chưa submit
        request.getRequestDispatcher("/submitRating.jsp").forward(request, response);
        return;
    }

    // Lấy dữ liệu từ form
    String bookingIdStr = request.getParameter("bookingId");
    String ratingStr = request.getParameter("rating");
    String comment = request.getParameter("comment");

    // Kiểm tra dữ liệu đầu vào
    if (bookingIdStr == null || bookingIdStr.trim().isEmpty() || !bookingIdStr.matches("\\d+")) {
        request.setAttribute("error", "Booking ID không hợp lệ.");
        request.getRequestDispatcher("/submitRating.jsp").forward(request, response);
        return;
    }
    if (ratingStr == null || ratingStr.trim().isEmpty() || !ratingStr.matches("\\d+")) {
        request.setAttribute("error", "Điểm đánh giá không hợp lệ.");
        request.getRequestDispatcher("/submitRating.jsp").forward(request, response);
        return;
    }

    try {
        int bookingId = Integer.parseInt(bookingIdStr);
        int rating = Integer.parseInt(ratingStr);

        // Kiểm tra Booking hợp lệ và quyền đánh giá
        TutorRating eligibility = dao.checkBookingEligibility(bookingId, user.getUserID());
        if (eligibility == null) {
            request.setAttribute("error", "Bạn không có quyền đánh giá buổi học này hoặc buổi học chưa hoàn tất.");
            request.getRequestDispatcher("/submitRating.jsp").forward(request, response);
            return;
        }

        // Kiểm tra đánh giá trùng lặp
        if (dao.isBookingRated(bookingId)) {
            request.setAttribute("error", "Buổi học này đã được đánh giá.");
            request.getRequestDispatcher("/submitRating.jsp").forward(request, response);
            return;
        }

        // Lấy thời gian hiện tại
        Timestamp ratingDate = new Timestamp(System.currentTimeMillis());

        // Tạo đối tượng TutorRating
        TutorRating newRating = new TutorRating(0, bookingId, user.getUserID(), eligibility.getTutorId(), rating, comment, ratingDate);

        // Thêm vào database
        int n = dao.insertTutorRating(newRating);

        if (n > 0) {
            response.sendRedirect(request.getContextPath() + "/TutorRatingController?service=listRating");
        } else {
            request.setAttribute("error", "Thêm đánh giá thất bại!");
            request.getRequestDispatcher("/submitRating.jsp").forward(request, response);
        }
    } catch (SQLException ex) {
        Logger.getLogger(TutorRatingController.class.getName()).log(Level.SEVERE, "Database error", ex);
        request.setAttribute("error", "Database may have problems: " + ex.getMessage());
        request.getRequestDispatcher("/submitRating.jsp").forward(request, response);
    }
}

    // Xử lý hiển thị danh sách đánh giá
    private void handleListRating(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOTutorRating dao = new DAOTutorRating();
        try {
            List<TutorRating> ratingList = dao.getAllTutorRatings(); // Lấy danh sách tất cả đánh giá
            request.setAttribute("ratingList", ratingList);
            request.getRequestDispatcher("/tutorRatingList.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(TutorRatingController.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect("error-404.jsp");
        }
    }

    // Xử lý hiển thị chi tiết đánh giá
    private void handleDetailRating(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOTutorRating dao = new DAOTutorRating();
        String ratingIdStr = request.getParameter("ratingId");

        if (ratingIdStr != null && !ratingIdStr.isEmpty()) {
            try {
                int ratingId = Integer.parseInt(ratingIdStr);
                TutorRating rating = dao.getTutorRatingById(ratingId);
                if (rating != null) {
                    request.setAttribute("rating", rating);
                    request.getRequestDispatcher("/tutorRatingDetail.jsp").forward(request, response);
                    return;
                }
            } catch (SQLException ex) {
                Logger.getLogger(TutorRatingController.class.getName()).log(Level.SEVERE, "Database error", ex);
            } catch (NumberFormatException ex) {
                Logger.getLogger(TutorRatingController.class.getName()).log(Level.SEVERE, "Invalid ratingId", ex);
            }
        }
        response.sendRedirect("error-404.jsp");
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
        return "Tutor Rating Controller Servlet";
    }
}