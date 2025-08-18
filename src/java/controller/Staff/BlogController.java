package controller.Staff;

import entity.Blog;
import entity.User;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.DAOBlog;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@WebServlet(name = "BlogController", urlPatterns = {"/staff/BlogController"})
public class BlogController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String service = request.getParameter("service");

        if (service == null) {
            service = "listBlog"; // Mặc định hiển thị danh sách blog
        }

        switch (service) {
            case "addBlog":
                handleAddBlog(request, response);
                break;
            case "listBlog":
                handleListBlog(request, response);
                break;
            case "detailBlog":
                handleDetailBlog(request, response);
                break;
            case "searchBlog":
                handleSearchBlog(request, response);
                break;
            case "updateBlog":
                handleUpdateBlog(request, response);
                break;
            case "deleteBlog":
                handleDeleteBlog(request, response);
                break;
            case "uploadImage": // Thêm nhánh xử lý upload ảnh từ CKEditor
                handleImageUploadForCKEditor(request, response);
                break;
            default:
                String contextPath = request.getContextPath();
                response.sendRedirect(contextPath + "/error-404.jsp");
        }
    }

    private void handleAddBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        DAOBlog dao = new DAOBlog();
        User user = (User) session.getAttribute("user");
        String submit = request.getParameter("submit");
        if (submit == null) {
            // Hiển thị form thêm blog
            request.getRequestDispatcher("/staff/addBlog.jsp").forward(request, response);
            return;
        }

        // Lấy dữ liệu từ form
        String title = request.getParameter("title");
        String summary = request.getParameter("summary");
        String content = request.getParameter("content");

        // Kiểm tra dữ liệu đầu vào
        if (title == null || title.trim().isEmpty() || summary == null || summary.trim().isEmpty()
                || content == null || content.trim().isEmpty()) {
            session.setAttribute("error", "All fields (Title, Summary, Content) are required!");
            response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=addBlog");
            return;
        }

        String thumbnail = handleFileUpload(request, "thumbnail"); // Xử lý upload file thumbnail
        if (thumbnail == null) {
            session.setAttribute("error", "Thumbnail upload failed or invalid file type. Please upload a valid image (jpg, jpeg, png, gif).");
            response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=addBlog");
            return;
        }

        try {
            // Lấy thông tin từ session
            String authorName = user.getFullName();
            int staffID = user.getUserID(); // Lấy staffID trực tiếp từ userID trong session

            // Kiểm tra staffID hợp lệ
            if (staffID <= 0) {
                session.setAttribute("error", "Invalid User ID retrieved from session.");
                response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=addBlog");
                return;
            }

            // Lấy thời gian hiện tại
            Timestamp createdAt = new Timestamp(System.currentTimeMillis());

            // Tạo đối tượng Blog
            Blog blog = new Blog(0, staffID, authorName, thumbnail, title, content, createdAt, summary);

            // Thêm vào database bằng insertBlog
            int n = dao.insertBlog(blog);

            if (n > 0) {
                session.removeAttribute("error"); // Xóa lỗi nếu thành công
                response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=listBlog&message=addSuccess");
            } else {
                session.setAttribute("error", "Add Fail! Please try again.");
                response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=addBlog");
            }
        } catch (SQLException ex) {
            Logger.getLogger(BlogController.class.getName()).log(Level.SEVERE, "Database error", ex);
            session.setAttribute("error", "Database error: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=addBlog");
        }
    }

    private void handleUpdateBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DAOBlog dao = new DAOBlog();
        User user = (User) session.getAttribute("user");
        String blogIDStr = request.getParameter("blogID");
        if (blogIDStr == null || blogIDStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/error-404.jsp");
            return;
        }

        int blogID;
        try {
            blogID = Integer.parseInt(blogIDStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/error-404.jsp");
            return;
        }

        try {
            Blog blog = dao.getBlogById(blogID);
            if (blog == null) {
                response.sendRedirect(request.getContextPath() + "/error-404.jsp");
                return;
            }

            String submit = request.getParameter("submit");
            if (submit == null) {
                // Hiển thị form cập nhật
                request.setAttribute("blog", blog);
                request.getRequestDispatcher("/staff/updateBlog.jsp").forward(request, response);
                return;
            }

            // Lấy dữ liệu từ form
            String title = request.getParameter("title");
            String summary = request.getParameter("summary");
            String content = request.getParameter("content");

            // Xử lý upload file thumbnail (nếu có)
            String thumbnail = handleFileUpload(request, "thumbnail"); // Thử upload file mới
            if (thumbnail == null) {
                // Nếu không upload file mới, giữ nguyên thumbnail cũ
                thumbnail = blog.getThumbnail();
            }

            // Kiểm tra dữ liệu đầu vào
            if (title == null || title.trim().isEmpty() || summary == null || summary.trim().isEmpty()
                    || content == null || content.trim().isEmpty()) {
                session.setAttribute("error", "All fields (Title, Summary, Content) are required!");
                response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=updateBlog&blogID=" + blogID);
                return;
            }

            Timestamp updatedAt = new Timestamp(System.currentTimeMillis());

            // Cập nhật đối tượng Blog
            blog.setTitle(title);
            blog.setSummary(summary);
            blog.setContent(content);
            blog.setThumbnail(thumbnail);
            blog.setCreatedAt(updatedAt); // Sử dụng updatedAt thay vì createdAt

            // Cập nhật vào database
            int n = dao.updateBlog(blog);

            if (n > 0) {
                session.removeAttribute("error"); // Xóa lỗi nếu thành công
                response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=listBlog&message=updateSuccess");
            } else {
                session.setAttribute("error", "Update Fail!");
                response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=updateBlog&blogID=" + blogID);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BlogController.class.getName()).log(Level.SEVERE, "Database error", ex);
            session.setAttribute("error", "Database error: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=updateBlog&blogID=" + blogID);
        }
    }

    private void handleDeleteBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DAOBlog dao = new DAOBlog();
        User user = (User) session.getAttribute("user");
        String blogIDStr = request.getParameter("blogID");
        if (blogIDStr == null || blogIDStr.isEmpty()) {
            String contextPath = request.getContextPath();
            response.sendRedirect(contextPath + "/error-404.jsp");
            return;
        }
        int blogID;
        try {
            blogID = Integer.parseInt(blogIDStr);
        } catch (NumberFormatException e) {
            String contextPath = request.getContextPath();
            response.sendRedirect(contextPath + "/error-404.jsp");
            return;
        }

        try {
            int n = dao.deleteBlog(blogID);
            if (n > 0) {
                response.sendRedirect(request.getContextPath() + "/staff/BlogController?service=listBlog&message=deleteSuccess");
            } else {
                request.setAttribute("error", "Xóa bài viết thất bại!");
                request.getRequestDispatcher("/staff/blog.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BlogController.class.getName()).log(Level.SEVERE, "Database error", ex);
        }
    }

    private void handleListBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOBlog dao = new DAOBlog();
        try {
            int pageSize = 6; // 6 blog mỗi trang
            String pageStr = request.getParameter("page");
            int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
            List<Blog> recentBlogs = dao.getRecentBlogs(3); // Lấy 3 blog cho Recent Posts
            List<Blog> galleryBlogs = dao.getRecentThumbnails(8); // Lấy 8 blog cho Gallery

            int totalBlogs = dao.getTotalBlogs();
            int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);

            // Giới hạn page trong khoảng 1 đến totalPages
            if (page < 1) {
                page = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            List<Blog> blogList = dao.getBlogsByPage(page, pageSize);
            request.setAttribute("blogList", blogList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("recentBlogs", recentBlogs);
            request.setAttribute("galleryBlogs", galleryBlogs);
            request.getRequestDispatcher("/staff/blog.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(BlogController.class.getName()).log(Level.SEVERE, "Database error", ex);
            request.setAttribute("error", "error: " + ex.getMessage());
            String contextPath = request.getContextPath();
            response.sendRedirect(contextPath + "/error-404.jsp");
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
                List<Blog> recentBlogs = dao.getRecentBlogs(3);
                List<Blog> galleryBlogs = dao.getRecentThumbnails(8);

                if (blog != null) {
                    request.setAttribute("blog", blog);
                    request.setAttribute("recentBlogs", recentBlogs);
                    request.setAttribute("galleryBlogs", galleryBlogs);
                    request.getRequestDispatcher("/staff/blog-details-staff.jsp").forward(request, response);
                    return;
                }
            } catch (SQLException ex) {
                Logger.getLogger(BlogController.class.getName()).log(Level.SEVERE, "Database error", ex);
            } catch (NumberFormatException ex) {
                Logger.getLogger(BlogController.class.getName()).log(Level.SEVERE, "Invalid blogID", ex);
            }
        }
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + "/error-404.jsp");
    }

    private void handleSearchBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOBlog dao = new DAOBlog();
        String keyword = request.getParameter("text");
        try {
            List<Blog> blogList = (keyword == null || keyword.trim().isEmpty())
                    ? dao.getAllBlogs()
                    : dao.searchBlogs(keyword);
            List<Blog> recentBlogs = dao.getRecentBlogs(3);
            List<Blog> galleryBlogs = dao.getRecentThumbnails(8);

            request.setAttribute("blogList", blogList);
            request.setAttribute("recentBlogs", recentBlogs);
            request.setAttribute("galleryBlogs", galleryBlogs);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/staff/blog.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(BlogController.class.getName()).log(Level.SEVERE, "Database error", ex);
            String contextPath = request.getContextPath();
            response.sendRedirect(contextPath + "/error-404.jsp");
        }
    }

    // Thêm phương thức xử lý upload ảnh từ CKEditor
    private void handleImageUploadForCKEditor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        // Lấy file từ CKEditor (tên field mặc định là "upload")
        String filePath = handleFileUpload(request, "upload");
        if (filePath == null) {
            sendCKEditorError(response, "Upload ảnh thất bại! Vui lòng kiểm tra định dạng hoặc kích thước file.");
            return;
        }

        // Trả về phản hồi JSON cho CKEditor
        String fileName = Paths.get(filePath).getFileName().toString();
        String fileUrl = request.getContextPath() + "/" + filePath;
        String jsonResponse = String.format("{\"uploaded\": 1, \"fileName\": \"%s\", \"url\": \"%s\"}",
                fileName, fileUrl);
        response.getWriter().write(jsonResponse);
    }

    // Phương thức upload file tổng quát, tái sử dụng cho cả thumbnail và CKEditor
    private String handleFileUpload(HttpServletRequest request, String partName)
            throws IOException, ServletException {
        Part filePart = request.getPart(partName);
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        if (!isImageFile(fileName)) {
            return null;
        }

        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        String fullPath = uploadPath + File.separator + uniqueFileName;

        try (InputStream inputStream = filePart.getInputStream(); FileOutputStream outputStream = new FileOutputStream(fullPath)) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            Logger.getLogger(BlogController.class.getName()).log(Level.SEVERE, "Error uploading file: " + fullPath, e);
            return null;
        }

        return "uploads/" + uniqueFileName;
    }

    private boolean isImageFile(String fileName) {
        String[] allowedExtensions = {".jpg", ".jpeg", ".png", ".gif"};
        for (String ext : allowedExtensions) {
            if (fileName.toLowerCase().endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    private void sendCKEditorError(HttpServletResponse response, String message) throws IOException {
        String jsonResponse = String.format("{\"uploaded\": 0, \"error\": {\"message\": \"%s\"}}", message);
        response.getWriter().write(jsonResponse);
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
        return "Blog Controller Servlet";
    }
}
