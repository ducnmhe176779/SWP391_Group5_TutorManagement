package UserController;

import controller.Customer.*;
import entity.Blog;
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
import model.DAOBlog;

@WebServlet(name = "ViewBlog", urlPatterns = {"/ViewBlog"})
public class ViewBlog extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String service = request.getParameter("service");

        if (service == null) {
            service = "listBlog"; // Mặc định hiển thị danh sách blog
        }

        switch (service) {
            case "listBlog":
                handleListBlog(request, response);
                break;
            case "detailBlog":
                handleDetailBlog(request, response);
                break;
            case "searchBlog":
                handleSearchBlog(request, response);
                break;
            default:
                response.sendRedirect("error-404.html");
        }
    }

    // 📝 Xử lý hiển thị danh sách blog và recent blogs
    private void handleListBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOBlog dao = new DAOBlog();
        try {
            int pageSize = 6; // 6 blog mỗi trang
            String pageStr = request.getParameter("page");
            int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
            List<Blog> recentBlogs = dao.getRecentBlogs(3); // Lấy 3 blog cho Recent Posts
            // Lấy 6 blog gần nhất với đầy đủ thông tin thumbnail
            List<Blog> galleryBlogs = dao.getRecentThumbnails(8);

            int totalBlogs = dao.getTotalBlogs(); // Giả sử trả về 7
            int totalPages = (int) Math.ceil((double) totalBlogs / pageSize); // 7 / 5 = 1.4 -> 2 trang

            // Giới hạn page trong khoảng 1 đến totalPages
            if (page < 1) {
                page = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            List<Blog> blogList = dao.getBlogsByPage(page, pageSize);
            request.setAttribute("blogList", blogList);
            request.setAttribute("totalPages", totalPages); // 2
            request.setAttribute("currentPage", page);
            request.setAttribute("recentBlogs", recentBlogs); // Recent Posts
            request.setAttribute("galleryBlogs", galleryBlogs); // Gallery thumbnails
            request.getRequestDispatcher("blog-classic-sidebar.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(ViewBlog.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "error: " + ex.getMessage());
            response.sendRedirect("error-404.jsp"); // Redirect nếu không có bài viết hoặc lỗi
        }
    }

    private void handleDetailBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOBlog dao = new DAOBlog();
        String blogIDStr = request.getParameter("blogID");

        if (blogIDStr != null && !blogIDStr.isEmpty()) {
            try {
                int blogID = Integer.parseInt(blogIDStr);
                Blog blog = dao.getBlogById(blogID);
                List<Blog> recentBlogs = dao.getRecentBlogs(3); // Lấy 3 blog cho Recent Posts
                // Lấy 6 blog gần nhất với đầy đủ thông tin thumbnail
                List<Blog> galleryBlogs = dao.getRecentThumbnails(8);

                if (blog != null) {
                    request.setAttribute("blog", blog); // Blog chi tiết
                    request.setAttribute("recentBlogs", recentBlogs); // Recent Posts
                    request.setAttribute("galleryBlogs", galleryBlogs); // Gallery thumbnails
                    request.getRequestDispatcher("blog-details.jsp").forward(request, response);
                    return;
                }
            } catch (SQLException ex) {
                Logger.getLogger(ViewBlog.class.getName()).log(Level.SEVERE, "Database error", ex);
            } catch (NumberFormatException ex) {
                Logger.getLogger(ViewBlog.class.getName()).log(Level.SEVERE, "Invalid blogID", ex);
            }
        }
        response.sendRedirect("error-404.jsp"); // Redirect nếu không có bài viết hoặc lỗi
    }

    // Xử lý tìm kiếm blog và lọc trong blogList
    private void handleSearchBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOBlog dao = new DAOBlog();
        String keyword = request.getParameter("text");
        try {
            List<Blog> blogList;
            if (keyword == null || keyword.trim().isEmpty()) {
                blogList = dao.getAllBlogs();
            } else {
                blogList = dao.searchBlogs(keyword);
            }
            // Thêm recent blogs
            List<Blog> recentBlogs = dao.getRecentBlogs(3); // Lấy top 3 recent blogs
            List<Blog> galleryBlogs = dao.getRecentThumbnails(8);
            request.setAttribute("blogList", blogList);
            request.setAttribute("recentBlogs", recentBlogs); // Đảm bảo recentBlogs được set
            request.setAttribute("keyword", keyword);
            request.setAttribute("galleryBlogs", galleryBlogs); // Gallery thumbnails

            request.getRequestDispatcher("blog-classic-sidebar.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(ViewBlog.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect("error-404.jsp");
        }
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
        return "Blog Viewer Servlet";
    }
}
