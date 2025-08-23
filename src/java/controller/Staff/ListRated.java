package controller.Staff;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DAOTutorRating;
import entity.TutorRating;

@WebServlet(name = "ListRated", urlPatterns = {"/staff/ListRated"})
public class ListRated extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ListRated.class.getName());
    private static final String DEFAULT_SERVICE = "listRating";
    private static final String DEFAULT_ORDER = "DESC";
    private static final String LIST_JSP = "/staff/tutorRatingList.jsp";
    private static final String ERROR_JSP = "/staff/error.jsp";
    private static final String ERROR_404 = "error-404.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String service = request.getParameter("service") != null ? request.getParameter("service") : DEFAULT_SERVICE;

        DAOTutorRating dao = new DAOTutorRating();
        try {
            switch (service) {
                case "listRating":
                    handleListRating(request, dao);
                    break;
                case "listTutorsByRating":
                    handleListTutorsByRating(request, dao);
                    break;
                case "searchTutors":
                    handleSearchTutors(request, dao);
                    break;
                case "searchRatingList":
                    handleSearchRatingList(request, dao);
                    break;
                case "detailRating":
                    handleDetailRating(request, response);
                    return; // Tránh forward tiếp vì handleDetailRating đã xử lý response
                case "deleteRating": // Thêm case mới để xử lý xóa đánh giá
                    handleDeleteRating(request, response, dao);
                    return; // Tránh forward tiếp vì đã redirect sau khi xóa
                default:
                    response.sendRedirect(ERROR_404);
                    return;
            }
            request.getRequestDispatcher(LIST_JSP).forward(request, response);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error", ex);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            request.getRequestDispatcher(ERROR_JSP).forward(request, response);
        }
    }

    // Hiển thị danh sách tất cả đánh giá
    private void handleListRating(HttpServletRequest request, DAOTutorRating dao) throws SQLException {
        List<TutorRating> ratingList = dao.getAllTutorRatings();
        request.setAttribute("ratingList", ratingList);
    }

    // Lấy danh sách gia sư theo điểm trung bình
    private void handleListTutorsByRating(HttpServletRequest request, DAOTutorRating dao) throws SQLException {
        String order = request.getParameter("order");
        if (order == null || (!"ASC".equals(order) && !"DESC".equals(order))) {
            order = DEFAULT_ORDER;
        }
        List<Object[]> tutorList = dao.getTutorsWithAverageRating(order);
        request.setAttribute("tutorList", tutorList);
    }

    // Tìm kiếm gia sư theo từ khóa
    private void handleSearchTutors(HttpServletRequest request, DAOTutorRating dao) throws SQLException {
        String keyword = request.getParameter("keyword");
        List<Object[]> tutorList;
        if (keyword == null || keyword.trim().isEmpty()) {
            tutorList = dao.getTutorsWithAverageRating(DEFAULT_ORDER);
        } else {
            tutorList = dao.searchTutorsByIdOrName(keyword);
        }
        request.setAttribute("tutorList", tutorList);
        request.setAttribute("keyword", keyword);
    }

    // Tìm kiếm danh sách đánh giá theo tiêu chí
    private void handleSearchRatingList(HttpServletRequest request, DAOTutorRating dao) throws SQLException {
        String ratingId = request.getParameter("ratingId");
        String tutorId = request.getParameter("tutorId");
        String ratingDate = request.getParameter("ratingDate");

        List<TutorRating> searchResult = dao.searchTutorRatings(ratingId, tutorId, ratingDate);
        request.setAttribute("ratingList", searchResult);
        request.setAttribute("ratingId", ratingId);
        request.setAttribute("tutorId", tutorId);
        request.setAttribute("ratingDate", ratingDate);
    }

    // Xem chi tiết một đánh giá
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
                    request.getRequestDispatcher("/staff/tutorRatingDetail.jsp").forward(request, response);
                    return;
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Database error", ex);
            } catch (NumberFormatException ex) {
                LOGGER.log(Level.SEVERE, "Invalid ratingId", ex);
            }
        }
        response.sendRedirect(ERROR_404);
    }

    // Xử lý xóa một đánh giá
    private void handleDeleteRating(HttpServletRequest request, HttpServletResponse response, DAOTutorRating dao)
            throws ServletException, IOException, SQLException {
        String ratingIdStr = request.getParameter("ratingId");

        if (ratingIdStr != null && !ratingIdStr.isEmpty()) {
            try {
                int ratingId = Integer.parseInt(ratingIdStr);
                // Gọi phương thức xóa từ DAO
                boolean deleted = dao.deleteTutorRating(ratingId);
                if (deleted) {
                    // Nếu xóa thành công, set thông báo thành công
                    request.getSession().setAttribute("message", "Xóa đánh giá thành công!");
                } else {
                    // Nếu không tìm thấy đánh giá để xóa
                    request.getSession().setAttribute("error", "Không tìm thấy đánh giá để xóa!");
                }
            } catch (NumberFormatException ex) {
                LOGGER.log(Level.SEVERE, "Invalid ratingId", ex);
                request.getSession().setAttribute("error", "ID đánh giá không hợp lệ!");
            }
        } else {
            request.getSession().setAttribute("error", "ID đánh giá không được để trống!");
        }
        // Sau khi xóa, redirect về trang danh sách đánh giá
        response.sendRedirect(request.getContextPath() + "/staff/ListRated?service=listRating");
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