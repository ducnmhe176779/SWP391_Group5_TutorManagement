/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Staff;

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
 * @author DatAnh
 */
@WebServlet(name = "SubjectController", urlPatterns = {"/staff/SubjectController"})
public class SubjectController extends HttpServlet {

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

        DAOSubject dao = new DAOSubject();
        
        // Test database connection
        if (!dao.testConnection()) {
            System.out.println("ERROR: Database connection failed!");
            HttpSession session = request.getSession();
            session.setAttribute("error", "Không thể kết nối database. Vui lòng kiểm tra kết nối.");
            response.sendRedirect("error-404.jsp");
            return;
        }
        
        // Check Subject table
        if (!dao.checkSubjectTable()) {
            System.out.println("ERROR: Subject table check failed!");
            HttpSession session = request.getSession();
            session.setAttribute("error", "Bảng Subject không tồn tại hoặc không thể truy cập.");
            response.sendRedirect("error-404.jsp");
            return;
        }

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
                response.sendRedirect("error-404.jsp");
        }
    }

    // Xử lý thêm subject
    private void handleAddSubject(HttpServletRequest request, HttpServletResponse response, DAOSubject dao)
            throws ServletException, IOException {
        String submit = request.getParameter("submit");
        if (submit == null) {
            // Hiển thị form thêm subject
            response.sendRedirect(request.getContextPath() + "/staff/addSubject.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String subjectName = request.getParameter("subjectName");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        Subject subject = new Subject(0, subjectName, description, status);

        try {
            int newId = dao.addSubject(subject);
            HttpSession session = request.getSession();
            if (newId > 0) {
                // Thành công -> redirect về list với thông báo thành công
                session.setAttribute("message", "Thêm subject thành công");
                response.sendRedirect(request.getContextPath() + "/staff/SubjectController?service=listSubject");
            } else {
                // Thất bại -> redirect với thông báo lỗi
                session.setAttribute("error", "Tạo mới subject thất bại, hãy để ý tên không được trùng với những subject khác");
                response.sendRedirect(request.getContextPath() + "/staff/addSubject.jsp?error=AddFailed");
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectController.class.getName()).log(Level.SEVERE, "Database error", ex);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/addSubject.jsp");
        }
    }

    // Xử lý hiển thị danh sách subject với pagination và search
    private void handleListSubject(HttpServletRequest request, HttpServletResponse response, DAOSubject dao)
            throws ServletException, IOException {
        try {
            // Lấy tham số pagination và search
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("size");
            String searchTerm = request.getParameter("search");
            String sortField = request.getParameter("sortField");
            String sortOrder = request.getParameter("sortOrder");
            
            int currentPage = 1;
            int pageSize = 5; // Mỗi trang hiển thị 5 môn học
            boolean isSearchMode = false; // Flag để biết có đang search không
            
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
            
            // Kiểm tra xem có đang search không
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                isSearchMode = true;
                // Khi search, reset về trang 1 để hiển thị kết quả
                currentPage = 1;
                System.out.println("DEBUG: Search mode activated with term: " + searchTerm + ", reset to page 1");
            }
            
            List<Subject> subjectList;
            int totalSubjects;
            int totalPages;
            
            if (isSearchMode) {
                // CHẾ ĐỘ SEARCH: Lấy tất cả subjects và filter theo search term
                System.out.println("DEBUG: Search mode - getting all subjects for filtering");
                subjectList = dao.getAllSubjects();
                
                if (subjectList != null && !subjectList.isEmpty()) {
                    // Filter theo search term (tìm theo tên môn học và mô tả)
                    List<Subject> filteredList = new ArrayList<>();
                    String searchLower = searchTerm.toLowerCase().trim();
                    
                    for (Subject subject : subjectList) {
                        if (subject.getSubjectName() != null && 
                            subject.getSubjectName().toLowerCase().contains(searchLower)) {
                            filteredList.add(subject);
                        } else if (subject.getDescription() != null && 
                                   subject.getDescription().toLowerCase().contains(searchLower)) {
                            filteredList.add(subject);
                        }
                    }
                    
                    subjectList = filteredList;
                    System.out.println("DEBUG: Search results: " + subjectList.size() + " subjects found");
                }
                
                // Trong chế độ search, không phân trang
                totalSubjects = subjectList != null ? subjectList.size() : 0;
                totalPages = 1;
                currentPage = 1;
                
            } else {
                // CHẾ ĐỘ BÌNH THƯỜNG: Sử dụng pagination
                System.out.println("DEBUG: Normal mode - using pagination");
                
                // Lấy tổng số môn học
                totalSubjects = dao.getTotalSubjects();
                totalPages = (int) Math.ceil((double) totalSubjects / pageSize);
                
                // Đảm bảo currentPage không vượt quá totalPages
                if (currentPage > totalPages && totalPages > 0) {
                    currentPage = totalPages;
                }
                
                // Lấy danh sách môn học theo trang
                subjectList = dao.getSubjectsByPage(currentPage, pageSize);
                
                // Nếu pagination không hoạt động, lấy tất cả subjects
                if (subjectList == null || subjectList.isEmpty()) {
                    System.out.println("DEBUG: Pagination failed, trying to get all subjects");
                    subjectList = dao.getAllSubjects();
                    
                    // Nếu vẫn không có dữ liệu, set default values
                    if (subjectList == null || subjectList.isEmpty()) {
                        totalSubjects = 0;
                        totalPages = 0;
                        currentPage = 1;
                    } else {
                        totalSubjects = subjectList.size();
                        totalPages = 1;
                        currentPage = 1;
                    }
                }
            }
            
            System.out.println("DEBUG: Final result - totalSubjects=" + totalSubjects + 
                             ", totalPages=" + totalPages + ", currentPage=" + currentPage + 
                             ", subjectList size=" + (subjectList != null ? subjectList.size() : "null"));
            
            // Truyền tất cả parameters để JSP có thể giữ nguyên search và sort
            request.setAttribute("subjectList", subjectList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("sortField", sortField);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("isSearchMode", isSearchMode); // Flag để JSP biết có đang search không

            // Lấy danh sách Tutor-Subject
            List<Subject> tutorSubjectList = dao.getAllTutorSubjects();
            request.setAttribute("tutorSubjectList", tutorSubjectList);

            request.getRequestDispatcher("/staff/manageSubject.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(SubjectController.class.getName()).log(Level.SEVERE, "Database error", ex);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            response.sendRedirect("error-404.jsp");
        }
    }

    private void handleUpdateSubject(HttpServletRequest request, HttpServletResponse response, DAOSubject dao)
            throws ServletException, IOException {
        String subjectIDStr = request.getParameter("subjectID");
        if (subjectIDStr == null || subjectIDStr.isEmpty()) {
            response.sendRedirect("error-404.jsp");
            return;
        }

        int subjectID;
        try {
            subjectID = Integer.parseInt(subjectIDStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("error-404.jsp");
            return;
        }

        try {
            Subject subject = dao.getSubjectById(subjectID);
            if (subject == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Subject không tồn tại");
                response.sendRedirect(request.getContextPath() + "/staff/SubjectController?service=listSubject");
                return;
            }

            String submit = request.getParameter("submit");
            if (submit == null) {
                // Hiển thị form cập nhật
                request.setAttribute("subject", subject);
                request.getRequestDispatcher("/staff/updateSubject.jsp").forward(request, response);
                return;
            }

            // Lấy dữ liệu từ form
            String subjectName = request.getParameter("subjectName");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            // Cập nhật các thuộc tính
            subject.setSubjectName(subjectName);
            subject.setDescription(description);
            subject.setStatus(status);

            int n = dao.updateSubject(subject);
            HttpSession session = request.getSession();

            if (n > 0) {
                // Update thành công
                session.setAttribute("message", "Cập nhật subject thành công");
                response.sendRedirect(request.getContextPath() + "/staff/SubjectController?service=listSubject");
            } else {
                // Lỗi → lưu vào session rồi redirect
                session.setAttribute("error", "Cập nhật lỗi!");
                response.sendRedirect(request.getContextPath() + "/staff/SubjectController?service=listSubject");
            }

        } catch (SQLException ex) {
            Logger.getLogger(SubjectController.class.getName()).log(Level.SEVERE, "Database error", ex);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/SubjectController?service=listSubject");
        }
    }

    private void handleDeleteSubject(HttpServletRequest request, HttpServletResponse response, DAOSubject dao)
            throws ServletException, IOException {
        String subjectIDStr = request.getParameter("subjectID");
        if (subjectIDStr == null || subjectIDStr.isEmpty()) {
            response.sendRedirect("error-404.jsp");
            return;
        }

        int subjectID;
        try {
            subjectID = Integer.parseInt(subjectIDStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("error-404.jsp");
            return;
        }

        try {
            Subject subject = dao.getSubjectById(subjectID);
            if (subject == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Subject không tồn tại");
                response.sendRedirect(request.getContextPath() + "/staff/SubjectController?service=listSubject");
                return;
            }

            // Đổi trạng thái thành "Inactive" thay vì xóa
            subject.setStatus("Inactive");
            int n = dao.updateSubject(subject);
            HttpSession session = request.getSession();

            if (n > 0) {
                session.setAttribute("message", "Đã đổi trạng thái subject thành Inactive");
                response.sendRedirect(request.getContextPath() + "/staff/SubjectController?service=listSubject");
            } else {
                session.setAttribute("error", "Không thể đổi trạng thái subject");
                response.sendRedirect(request.getContextPath() + "/staff/SubjectController?service=listSubject");
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectController.class.getName()).log(Level.SEVERE, "Database error", ex);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/SubjectController?service=listSubject");
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
        return "Subject Controller Servlet";
    }
}
