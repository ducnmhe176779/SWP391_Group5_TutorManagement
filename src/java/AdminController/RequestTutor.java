/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package AdminController;

import entity.Cv;
import entity.Tutor;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.DAOCv;
import model.DAOTutor;
import model.DAOTutorRating;
import model.DAOTutorSubject;
import model.DAOUser;

/**
 *
 * @author dvdung
 */
@WebServlet(name = "RequestTutor", urlPatterns = {"/admin/RequestCV"})
public class RequestTutor extends HttpServlet {

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
            DAOCv dao = new DAOCv();
            DAOTutor dao2 = new DAOTutor();
            DAOTutorSubject dao3 = new DAOTutorSubject();
            DAOUser dao4 = new DAOUser();
            DAOTutorRating dao5= new DAOTutorRating();
            String error = "";
            int CvID = 0;
            String cvid = request.getParameter("cvid");
            String cvId = request.getParameter("cvId");
            String submit = request.getParameter("submit");
            String subject = request.getParameter("subject");
            String status = request.getParameter("status");
            ResultSet rsCv = null;
            if (cvId != null && status != null) {
                CvID = Integer.parseInt(cvId);
                int subjectId = Integer.parseInt(subject);
                if (!dao2.isCVExists(CvID)) {
                    dao.updateCVStatus(CvID, status);
                    if (status.equals("Approved")) {
                        Cv cv = dao.getCVbyId(CvID);
                        int n = dao4.updateRole(cv.getUserId(), 3);
                        float price= dao.getPriceById(CvID);
                        dao2.addTutor(new Tutor(0, CvID, 0, price));
                        Tutor tutor = dao2.getTutorByCVid(CvID);
                        dao3.addTutorSubject(tutor.getTutorID(), subjectId);
                    }
                } else {
                    error = "This CV used";
                }
            }
            rsCv = dao.getData("SELECT [CVID],[Fullname],[Education],CV.Status,[SubjectName],Subject.SubjectID FROM [dbo].[CV]\n"
                    + "join Subject on CV.SubjectId=Subject.SubjectID\n"
                    + "join Users on Users.UserID=CV.UserID\n"
                    + "Where CV.Status='Pending'");
            request.setAttribute("error", error);
            request.setAttribute("rsCv", rsCv);
            request.getRequestDispatcher("/admin/statusCV.jsp").forward(request, response);
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
    }
}


