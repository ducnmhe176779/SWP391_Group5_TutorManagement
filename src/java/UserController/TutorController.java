/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package UserController;

import entity.Subject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.ResultSet;
import java.util.List;
import model.DAOSubject;

/**
 *
 * @author Admin
 */
@WebServlet(name = "TutorController", urlPatterns = {"/Tutor"})
public class TutorController extends HttpServlet {
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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            DAOSubject dao= new DAOSubject();
            List<Subject> list= dao.getAllSubjects();
            String name = request.getParameter("dzName");
            String subjectName = request.getParameter("Subjectname");
            String sql="select TutorID, FullName, SubjectName, rating, Avatar, Tutor.Price from users\n"
                        + "join CV on users.UserID=Cv.UserID\n"
                        + "join tutor on CV.CVID=tutor.CVID\n"
                        + "join Subject on CV.SubjectId=Subject.SubjectID";
            ResultSet rs=null;
            if (name != null) {
                 sql += " Where FullName='"+name+"'";
                 if(subjectName!=null){
                     sql+= " and SubjectName='"+subjectName+"'";
                 }
            }else{
                if(subjectName!=null){
                     sql+= " Where SubjectName='"+subjectName+"'";
                 }
            }
            
            rs=dao.getData(sql);
            request.setAttribute("list", list);
            request.setAttribute("rs", rs);
            request.getRequestDispatcher("/tutor.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}


