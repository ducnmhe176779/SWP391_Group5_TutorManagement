/*
 * Click nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Tutor;

import entity.Cv;
import entity.User;
import model.DAOUser;
import model.DAOTutor;
import model.DAOCv;
import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.Date;
import model.DAOCv;

/**
 * Servlet xử lý hồ sơ của tutor.
 */
@WebServlet(name = "TutorProfileServlet", urlPatterns = {"/tutor/tutorprofile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class TutorProfileServlet extends HttpServlet {

    private static final String TUTOR_PROFILE_PAGE = "/tutor/tutor-profile.jsp";
    private static final String LOGIN_PAGE = "login.jsp";
    private static final int MIN_PASSWORD_LENGTH = 8;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || currentUser.getRoleID() != 3) {
            response.sendRedirect(LOGIN_PAGE);
            return;
        }
        DAOCv dao=new DAOCv();
        Cv cv= dao.getCVbyUserId(currentUser.getUserID());
        request.setAttribute("cv", cv);
        request.setAttribute("user", currentUser);
        
        // Load current tutor price
        DAOTutor daoTutor = new DAOTutor();
        int tutorId = daoTutor.getTutorIdByUserId(currentUser.getUserID());
        if (tutorId != -1) {
            float currentPrice = daoTutor.getPriceByTutorId(tutorId);
            request.setAttribute("currentPrice", currentPrice);
        }
        
        request.getRequestDispatcher(TUTOR_PROFILE_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || currentUser.getRoleID() != 3) {
            response.sendRedirect(LOGIN_PAGE);
            return;
        }

        String action = request.getParameter("action");
        DAOUser daoUser = new DAOUser();

        if ("changePassword".equals(action)) {
            handleChangePassword(request, response, session, currentUser, daoUser);
        } else if ("tutorCV".equals(action)) {
            handleUpdateCV(request, response, session, currentUser, daoUser);
        } else if ("updatePrice".equals(action)) {
            handleUpdatePrice(request, response, session, currentUser);
        } else {
            handleUpdateProfile(request, response, session, currentUser, daoUser);
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, User currentUser, DAOUser daoUser) throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            // Mã hóa mật khẩu hiện tại để so sánh
            String encryptedCurrentPassword = util.MD5Util.getMD5Hash(currentPassword);
            if (!currentUser.getPassword().equals(encryptedCurrentPassword)) {
                setError(session, "Mật khẩu hiện tại không đúng.");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                setError(session, "Mật khẩu mới và xác nhận mật khẩu không khớp.");
                return;
            }

            if (newPassword.length() < MIN_PASSWORD_LENGTH) {
                setError(session, "Mật khẩu mới phải có ít nhất " + MIN_PASSWORD_LENGTH + " ký tự.");
                return;
            }

            // Mã hóa mật khẩu mới trước khi lưu
            String encryptedNewPassword = util.MD5Util.getMD5Hash(newPassword);
            currentUser.setPassword(encryptedNewPassword);
            if (daoUser.updateUser(currentUser)) {
                session.setAttribute("user", currentUser);
                setMessage(session, "Đổi mật khẩu thành công!");
            } else {
                setError(session, "Đổi mật khẩu thất bại.");
            }
        } catch (Exception e) {
            setError(session, "Lỗi khi xử lý mật khẩu: " + e.getMessage());
        } finally {
            response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, User currentUser, DAOUser daoUser) throws IOException, ServletException {
        int userId = currentUser.getUserID();
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String dobParam = request.getParameter("dob");
        String address = request.getParameter("address");
        java.sql.Date sqlDob = parseDateOfBirth(dobParam, session);

        if (sqlDob == null && session.getAttribute("error") != null) {
            response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
            return;
        }

        if (phone != null && !phone.trim().isEmpty() && !phone.equals(currentUser.getPhone())) {
            try {
                if (daoUser.isPhoneExist(phone, userId)) {
                    setError(session, "Số điện thoại đã được sử dụng bởi người dùng khác.");
                    response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
                    return;
                }
            } catch (Exception e) {
                setError(session, "Lỗi khi kiểm tra số điện thoại: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
                return;
            }
        }

        String avatarPath = handleFileUpload(request, currentUser.getAvatar());
        User updatedUser = new User(userId, currentUser.getRoleID(), currentUser.getEmail(), fullName, phone,
                currentUser.getCreateAt(), currentUser.getIsActive(), sqlDob, address,
                avatarPath, currentUser.getUserName(), currentUser.getPassword());

        if (daoUser.updateUser(updatedUser)) {
            session.setAttribute("user", updatedUser);
            setMessage(session, "Cập nhật hồ sơ thành công!");
        } else {
            setError(session, "Cập nhật hồ sơ thất bại.");
        }
        response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
    }
    private void handleUpdateCV(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, User currentUser, DAOUser daoUser) throws IOException, ServletException {
        int userId = currentUser.getUserID();
        String Education = request.getParameter("Education");
        String Experience = request.getParameter("Experience");
        String Certificates = request.getParameter("Certificates");
        String Description = request.getParameter("Description");
        String Skill = request.getParameter("Skill");
        float Price = Float.parseFloat(request.getParameter("Price"));
        int n=0;
        DAOCv dao=new DAOCv();
        n=dao.UpdateCV(userId, Education, Experience, Certificates, Description, Skill, Price);
        Cv cv= dao.getCVbyUserId(userId);
        request.setAttribute("cv",cv);
        response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
    }
    

    private java.sql.Date parseDateOfBirth(String dobParam, HttpSession session) {
        if (dobParam == null || dobParam.trim().isEmpty()) {
            return null;
        }
        try {
            LocalDate localDate = LocalDate.parse(dobParam);
            return java.sql.Date.valueOf(localDate);
        } catch (java.time.format.DateTimeParseException e) {
            setError(session, "Ngày sinh không hợp lệ. Vui lòng nhập theo định dạng yyyy-MM-dd.");
            return null;
        }
    }

    private String handleFileUpload(HttpServletRequest request, String currentAvatar) throws IOException, ServletException {
        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);
            if (fileName != null && isImageFile(fileName)) {
                String uploadPath = getServletContext().getRealPath("") + "uploads/";
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                filePart.write(uploadPath + fileName);
                return "uploads/" + fileName;
            } else {
                return currentAvatar; // Giữ nguyên avatar hiện tại nếu file không hợp lệ
            }
        }
        return currentAvatar;
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

    private void setError(HttpSession session, String errorMessage) {
        session.setAttribute("error", errorMessage);
    }

    private void setMessage(HttpSession session, String message) {
        session.setAttribute("message", message);
    }
    
    private void handleUpdatePrice(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, User currentUser) throws IOException {
        
        try {
            String newPriceStr = request.getParameter("newPrice");
            String priceReason = request.getParameter("priceReason");
            
            if (newPriceStr == null || newPriceStr.trim().isEmpty()) {
                setError(session, "Vui lòng nhập giá mới.");
                response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
                return;
            }
            
            float newPrice = Float.parseFloat(newPriceStr);
            
            // Validate giá
            if (newPrice < 10000) {
                setError(session, "Giá phải từ 10,000 VND trở lên.");
                response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
                return;
            }
            
            if (newPrice > 1000000) {
                setError(session, "Giá không được vượt quá 1,000,000 VND/giờ.");
                response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
                return;
            }
            
            DAOTutor daoTutor = new DAOTutor();
            int tutorId = daoTutor.getTutorIdByUserId(currentUser.getUserID());
            
            if (tutorId == -1) {
                setError(session, "Không tìm thấy thông tin tutor.");
                response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
                return;
            }
            
            // Lấy giá cũ để so sánh
            float oldPrice = daoTutor.getPriceByTutorId(tutorId);
            
            // Cập nhật giá
            boolean success = daoTutor.updateTutorPrice(tutorId, newPrice);
            
            if (success) {
                String message = String.format("Cập nhật giá thành công! Giá cũ: %,.0f VND → Giá mới: %,.0f VND", 
                                              oldPrice, newPrice);
                if (priceReason != null && !priceReason.trim().isEmpty()) {
                    message += " (Lý do: " + priceReason.trim() + ")";
                }
                setMessage(session, message);
                
                System.out.println("Tutor " + tutorId + " (" + currentUser.getFullName() + 
                                 ") updated price from " + oldPrice + " to " + newPrice);
                if (priceReason != null && !priceReason.trim().isEmpty()) {
                    System.out.println("Reason: " + priceReason);
                }
            } else {
                setError(session, "Có lỗi xảy ra khi cập nhật giá. Vui lòng thử lại.");
            }
            
        } catch (NumberFormatException e) {
            setError(session, "Giá không hợp lệ. Vui lòng nhập số.");
        } catch (Exception e) {
            e.printStackTrace();
            setError(session, "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/tutor/tutorprofile");
    }
}
