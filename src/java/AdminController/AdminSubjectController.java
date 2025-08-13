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

    // Xử lý hiển thị danh sách subject
    private void handleListSubject(HttpServletRequest request, HttpServletResponse response, DAOSubject dao)
            throws ServletException, IOException {
        try {
            // Lấy danh sách từ bảng Subject
            List<Subject> subjectList = dao.getAllSubjects();
            if (subjectList == null) {
                subjectList = new ArrayList<>();
            }
            request.setAttribute("subjectList", subjectList);

            // Lấy danh sách Tutor-Subject
            List<Subject> tutorSubjectList = dao.getAllTutorSubjects();
            if (tutorSubjectList == null) {
                tutorSubjectList = new ArrayList<>();
            }
            request.setAttribute("tutorSubjectList", tutorSubjectList);

            request.getRequestDispatcher("/admin/manageSubject.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(AdminSubjectController.class.getName()).log(Level.SEVERE, "Database error", ex);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            // Nếu có lỗi, vẫn hiển thị trang với danh sách rỗng
            request.setAttribute("subjectList", new ArrayList<>());
            request.setAttribute("tutorSubjectList", new ArrayList<>());
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
                response.sendRedirect(request.getContextPath() + "/admin/updateSubject.jsp?service=updateSubject&subjectID=" + subjectID);
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
