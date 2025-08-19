/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Staff;

import entity.User;
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
@WebServlet(name = "StaffController", urlPatterns = {"/staff/dashboard"})
public class StaffController extends HttpServlet {

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
        
        try {
            // Lấy danh sách tutor mới (RoleID = 2)
            List<User> newTutors = getNewTutors();
            request.setAttribute("newUsers", newTutors);
            
            // Forward đến staff dashboard
            request.getRequestDispatcher("/staff/index_staff.jsp").forward(request, response);
            
        } catch (Exception e) {
            Logger.getLogger(StaffController.class.getName()).log(Level.SEVERE, "Error in staff dashboard", e);
            request.setAttribute("error", "Lỗi hiển thị dashboard: " + e.getMessage());
            request.getRequestDispatcher("/staff/index_staff.jsp").forward(request, response);
        }
    }

    /**
     * Lấy danh sách tutor mới (RoleID = 2)
     */
    private List<User> getNewTutors() {
        List<User> newTutors = new ArrayList<>();
        
        try {
            // Tạo kết nối database
            model.DBConnect db = new model.DBConnect();
            
            // Query lấy 5 tutor mới nhất với RoleID = 2 (Users là tên bảng đúng)
            String sql = "SELECT TOP 5 u.* FROM Users u "
                       + "WHERE u.RoleID = 2 "
                       + "ORDER BY u.UserID DESC";
            
            java.sql.ResultSet rs = db.getData(sql);
            
            while (rs != null && rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setUserName(rs.getString("UserName"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setPhone(rs.getString("Phone"));
                user.setAvatar(rs.getString("Avatar"));
                user.setIsActive(rs.getInt("IsActive"));
                user.setRoleID(rs.getInt("RoleID"));
                
                newTutors.add(user);
            }
            
            if (rs != null) {
                rs.close();
            }
            
        } catch (SQLException e) {
            Logger.getLogger(StaffController.class.getName()).log(Level.SEVERE, "Database error", e);
        } catch (Exception e) {
            Logger.getLogger(StaffController.class.getName()).log(Level.SEVERE, "Error getting new tutors", e);
        }
        
        return newTutors;
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
        return "Staff Dashboard Controller Servlet";
    }
}
