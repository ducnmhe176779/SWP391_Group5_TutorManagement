package AdminController;

import entity.User;
import model.DAOUser;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
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
import util.MD5Util; // Import MD5Util

@WebServlet(name = "UserManage", urlPatterns = {"/admin/UserManage"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class UserManage extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UserManage.class.getName());
    private static final String USER_ADD_JSP = "/admin/user-add.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOUser dao = new DAOUser();
        String edit = request.getParameter("edit");

        try {
            if (edit != null) {
                int editId = Integer.parseInt(edit);
                User editUser = dao.getUserById(editId);
                if (editUser != null && editUser.getRoleID() == 2) {
                    request.setAttribute("editUser", editUser);
                } else {
                    request.setAttribute("error", "Không tìm thấy người dùng để chỉnh sửa!");
                }
            }
            request.getRequestDispatcher(USER_ADD_JSP).forward(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error in GET request", ex);
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher(USER_ADD_JSP).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        DAOUser dao = new DAOUser();

        if (!dao.isConnected()) {
            LOGGER.log(Level.SEVERE, "Database connection is null");
            request.setAttribute("error", "Không thể kết nối cơ sở dữ liệu.");
            request.getRequestDispatcher(USER_ADD_JSP).forward(request, response);
            return;
        }

        String userID = request.getParameter("UserID");
        String email = request.getParameter("Email");
        String fullName = request.getParameter("FullName");
        String phone = request.getParameter("Phone");
        String dob = request.getParameter("Dob");
        String address = request.getParameter("Address");
        String userName = request.getParameter("UserName");
        String password = request.getParameter("Password");
        String avatarPath = handleFileUpload(request);

        try {
            String error = validateInput(dao, email, fullName, phone, dob, address, userName, password, userID);
            if (!error.isEmpty()) {
                request.setAttribute("error", error);
                request.getRequestDispatcher(USER_ADD_JSP).forward(request, response);
                return;
            }

            if (avatarPath == null && userID != null && !userID.isEmpty()) {
                User existingUser = dao.getUserById(Integer.parseInt(userID));
                avatarPath = existingUser != null ? existingUser.getAvatar() : "uploads/default_avatar.jpg";
            } else if (avatarPath == null) {
                avatarPath = "uploads/default_avatar.jpg";
            }

            // Không mã hóa ở đây, truyền mật khẩu thô vào User
            User user = new User(
                    userID != null && !userID.isEmpty() ? Integer.parseInt(userID) : 0,
                    2, email, fullName, phone, null, 1,
                    Date.valueOf(dob), address, avatarPath, userName, password // Truyền password thô
            );

            int result;
            if (userID != null && !userID.isEmpty()) {
                result = dao.updateUser(user) ? 1 : 0;
            } else {
                result = dao.registerUser(user);
            }

            if (result > 0) {
                session.setAttribute("success", userID != null ? "Cập nhật người dùng thành công!" : "Thêm người dùng thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/UserList");
            } else {
                request.setAttribute("error", "Thao tác thất bại. Vui lòng thử lại.");
                request.getRequestDispatcher(USER_ADD_JSP).forward(request, response);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error processing POST request", ex);
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher(USER_ADD_JSP).forward(request, response);
        }
    }

    private String handleFileUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + extractFileName(filePart);
            if (fileName != null && isImageFile(fileName)) {
                String uploadPath = getServletContext().getRealPath("/WEB-INF/../uploads/");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                    LOGGER.log(Level.INFO, "Created uploads directory at: " + uploadPath);
                }
                String fullPath = uploadPath + fileName;
                LOGGER.log(Level.INFO, "Saving file to: " + fullPath);
                filePart.write(fullPath);
                return "uploads/" + fileName;
            }
        }
        return null;
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return null;
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

    private String validateInput(DAOUser dao, String email, String fullName, String phone, String dob,
            String address, String userName, String password, String userID) throws SQLException {
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "Email không hợp lệ.";
        }
        User existingUser = dao.getUserById(userID != null && !userID.isEmpty() ? Integer.parseInt(userID) : -1);
        if (dao.isEmailExists(email) && (existingUser == null || !existingUser.getEmail().equals(email))) {
            return "Email đã được sử dụng.";
        }
        if (userName == null || userName.trim().isEmpty()) {
            return "Username không được để trống.";
        }
        if (dao.isUsernameExists(userName) && (existingUser == null || !existingUser.getUserName().equals(userName))) {
            return "Username đã tồn tại.";
        }
        if (phone == null || !phone.matches("\\d{10}")) {
            return "Số điện thoại phải là 10 chữ số.";
        }
        if (dao.isPhoneExists(phone) && (existingUser == null || !existingUser.getPhone().equals(phone))) {
            return "Số điện thoại đã được sử dụng.";
        }
        if (password == null || password.length() < 8) {
            return "Mật khẩu phải dài ít nhất 8 ký tự.";
        }
        if (dob == null || dob.trim().isEmpty()) {
            return "Ngày sinh không được để trống.";
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Họ và tên không được để trống.";
        }
        if (address == null || address.trim().isEmpty()) {
            return "Địa chỉ không được để trống.";
        }
        return "";
    }
}