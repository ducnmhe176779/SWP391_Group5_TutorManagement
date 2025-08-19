/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package AdminController;

import entity.Subject;
import model.DAOSubject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Heizxje
 */
@WebServlet(name = "AdminSubjectController", urlPatterns = {"/admin/AdminSubjectController"})
public class AdminSubjectController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String service = request.getParameter("service");

        if (service == null) {
            service = "listSubject"; // Mặc định hiển thị danh sách subject
        }

        try {
            DAOSubject dao = new DAOSubject();

            switch (service) {
                case "addSubject":
                    handleAddSubject(request, response, dao);
                    break;
                case "listSubject":
                    handleListSubject(request, response, dao);
                    break;
                case "updateSubject":
                    handleUpdateSubject(request, response, dao);
                    break;
                case "deleteSubject":
                    handleDeleteSubject(request, response, dao);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/error-404.jsp");
            }
        } catch (Exception e) {
            Logger.getLogger(AdminSubjectController.class.getName()).log(Level.SEVERE, "Error initializing DAO", e);
            request.setAttribute("error", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/admin/manageSubject.jsp").forward(request, response);
        }
    }

    // Xử lý thêm subject
    private void handleAddSubject(HttpServletRequest request, HttpServletResponse response, DAOSubject dao)
            throws ServletException, IOException {
        String submit = request.getParameter("submit");
        if (submit == null) {
            // Hiển thị form thêm subject
            response.sendRedirect(request.getContextPath() + "/admin/addSubject.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String subjectName = request.getParameter("subjectName");
        String description = request.getParameter("description");
        String status = request.getParameter("status"); // Lấy trạng thái từ form

        // Tạo đối tượng Subject với trạng thái
        Subject subject = new Subject(0, subjectName, description, status);

        try {
            int newId = dao.addSubject(subject);
            HttpSession session = request.getSession();
            if (newId > 0) {
                // Thành công -> redirect về list với thông báo thành công
                session.setAttribute("message", "Thêm subject thành công");
                response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
            } else {
                // Thất bại -> redirect với thông báo lỗi
                session.setAttribute("error", "Thêm subject thất bại! Tên subject có thể đã tồn tại.");
                response.sendRedirect(request.getContextPath() + "/admin/addSubject.jsp?error=AddFailed");
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminSubjectController.class.getName()).log(Level.SEVERE, "Database error", ex);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/addSubject.jsp");
        }
    }

    // Xử lý hiển thị danh sách subject với pagination và search
    private void handleListSubject(HttpServletRequest request, HttpServletResponse response, DAOSubject dao)
            throws ServletException, IOException {
        try {
            // Tham số pagination và search
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("size");
            String searchTerm = request.getParameter("search");

            int currentPage = 1;
            int pageSize = 5; // Mỗi trang hiển thị 5 môn học

            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            if (sizeStr != null && !sizeStr.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(sizeStr);
                    if (pageSize < 1) pageSize = 5;
                } catch (NumberFormatException e) {
                    pageSize = 5;
                }
            }

            boolean isSearchMode = searchTerm != null && !searchTerm.trim().isEmpty();

            // Kiểm tra kết nối và bảng khi ở chế độ bình thường
            if (!isSearchMode) {
                if (!dao.testConnection()) {
                    request.setAttribute("error", "Không thể kết nối đến cơ sở dữ liệu");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }

                if (!dao.checkSubjectTable()) {
                    request.setAttribute("error", "Bảng Subject không tồn tại hoặc không có dữ liệu");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }
            }

            List<Subject> subjectList;
            int totalSubjects;
            int totalPages;

            if (isSearchMode) {
                // Chế độ search: hiển thị toàn bộ kết quả tìm kiếm không phân trang
                subjectList = dao.searchSubjects(searchTerm.trim());
                if (subjectList == null) subjectList = new ArrayList<>();
                totalSubjects = subjectList.size();
                totalPages = 1;
                currentPage = 1;
            } else {
                // Chế độ bình thường: Sử dụng pagination
                totalSubjects = dao.getTotalSubjects();
                if (totalSubjects == 0) {
                    totalPages = 0;
                    subjectList = new ArrayList<>();
                } else {
                    totalPages = (int) Math.ceil((double) totalSubjects / pageSize);
                    if (currentPage > totalPages) currentPage = totalPages;

                    subjectList = dao.getSubjectsByPage(currentPage, pageSize);
                    if (subjectList == null || subjectList.isEmpty()) {
                        // Fallback nếu paging không trả dữ liệu
                        subjectList = dao.getAllSubjects();
                        if (subjectList == null) subjectList = new ArrayList<>();
                    }
                }
            }

            // Thuộc tính cho JSP
            request.setAttribute("subjectList", subjectList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("isSearchMode", isSearchMode);
            request.setAttribute("searchTerm", searchTerm);

            // Tutor-Subject list (không phân trang)
            String tutorSearchTerm = request.getParameter("tutorSearch");
            List<Subject> tutorSubjectList;
            if (tutorSearchTerm != null && !tutorSearchTerm.trim().isEmpty()) {
                tutorSubjectList = dao.searchTutorSubjects(tutorSearchTerm.trim());
            } else {
                tutorSubjectList = dao.getAllTutorSubjects();
            }
            if (tutorSubjectList == null) tutorSubjectList = new ArrayList<>();
            request.setAttribute("tutorSubjectList", tutorSubjectList);

            request.getRequestDispatcher("/admin/manageSubject.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(AdminSubjectController.class.getName()).log(Level.SEVERE, "Database error", ex);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());

            // Giá trị mặc định khi lỗi
            request.setAttribute("subjectList", new ArrayList<>());
            request.setAttribute("tutorSubjectList", new ArrayList<>());
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalSubjects", 0);
            request.setAttribute("pageSize", 5);
            request.setAttribute("isSearchMode", false);
            request.setAttribute("searchTerm", "");
            request.getRequestDispatcher("/admin/manageSubject.jsp").forward(request, response);
        }
    }

    private void handleUpdateSubject(HttpServletRequest request, HttpServletResponse response, DAOSubject dao)
            throws ServletException, IOException {
        String subjectIDStr = request.getParameter("subjectID");
        if (subjectIDStr == null || subjectIDStr.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Không tìm thấy ID subject!");
            response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
            return;
        }

        int subjectID;
        try {
            subjectID = Integer.parseInt(subjectIDStr);
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID subject không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
            return;
        }

        try {
            Subject subject = dao.getSubjectById(subjectID);
            if (subject == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Subject không tồn tại!");
                response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
                return;
            }

            String submit = request.getParameter("submit");
            if (submit == null) {
                // Hiển thị form cập nhật
                request.setAttribute("subject", subject);
                request.getRequestDispatcher("/admin/updateSubject.jsp").forward(request, response);
                return;
            }

            // Lấy dữ liệu từ form
            String subjectName = request.getParameter("subjectName");
            String description = request.getParameter("description");
            String status = request.getParameter("status"); // Lấy trạng thái từ form

            subject.setSubjectName(subjectName);
            subject.setDescription(description);
            subject.setStatus(status); // Cập nhật trạng thái

            int n = dao.updateSubject(subject);
            HttpSession session = request.getSession();

            if (n > 0) {
                // Update thành công
                session.setAttribute("message", "Cập nhật subject thành công");
                response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
            } else {
                // Lỗi → lưu vào session rồi redirect
                session.setAttribute("error", "Cập nhật subject thất bại!");
                response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=updateSubject&subjectID=" + subjectID);
            }

        } catch (SQLException ex) {
            Logger.getLogger(AdminSubjectController.class.getName()).log(Level.SEVERE, "Database error", ex);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
        }
    }

    private void handleDeleteSubject(HttpServletRequest request, HttpServletResponse response, DAOSubject dao)
            throws ServletException, IOException {
        String subjectIDStr = request.getParameter("subjectID");
        if (subjectIDStr == null || subjectIDStr.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Không tìm thấy ID subject!");
            response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
            return;
        }

        int subjectID;
        try {
            subjectID = Integer.parseInt(subjectIDStr);
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID subject không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
            return;
        }

        try {
            // Lấy subject theo ID
            Subject subject = dao.getSubjectById(subjectID);
            if (subject == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Subject không tồn tại!");
                response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
                return;
            }

            // Kiểm tra trạng thái hiện tại của subject
            if ("Inactive".equals(subject.getStatus())) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Subject đã ở trạng thái Inactive!");
                response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
                return;
            }

            // Đổi trạng thái thành "Inactive" thay vì xóa
            subject.setStatus("Inactive");
            int n = dao.updateSubject(subject);
            HttpSession session = request.getSession();

            if (n > 0) {
                session.setAttribute("message", "Đã đổi trạng thái subject thành Inactive");
                response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
            } else {
                session.setAttribute("error", "Không thể đổi trạng thái subject!");
                response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminSubjectController.class.getName()).log(Level.SEVERE, "Database error", ex);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/AdminSubjectController?service=listSubject");
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
        return "Admin Subject Controller Servlet";
    }
}
