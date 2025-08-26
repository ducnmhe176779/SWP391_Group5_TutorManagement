package controller;

import entity.Subject;
import model.DAOSubject;
import model.DBConnect;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

/**
 * Comprehensive test servlet to debug subject loading
 */
@WebServlet(name = "TestSubjectsServlet", urlPatterns = {"/test-subjects-debug"})
public class TestSubjectsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Debug Subject Loading</title></head><body>");
            out.println("<h1>🔍 DEBUG SUBJECT LOADING - STEP BY STEP</h1>");
            
            // STEP 1: Test DBConnect
            out.println("<h2>📋 STEP 1: Testing DBConnect</h2>");
            DBConnect dbConnect = new DBConnect();
            Connection conn = dbConnect.getConnection();
            
            if (conn == null) {
                out.println("<p style='color: red;'>❌ ERROR: Connection is NULL</p>");
                out.println("</body></html>");
                return;
            } else {
                out.println("<p style='color: green;'>✅ SUCCESS: Connection established</p>");
            }
            
            // STEP 2: Test Subject table directly
            out.println("<h2>📋 STEP 2: Testing Subject Table Directly</h2>");
            try {
                String sql = "SELECT COUNT(*) as count FROM Subject";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                
                if (rs.next()) {
                    int count = rs.getInt("count");
                    out.println("<p style='color: green;'>✅ Subject table has " + count + " records</p>");
                    
                    if (count > 0) {
                        // Show first few subjects
                        out.println("<h3>First few subjects:</h3>");
                        String selectSql = "SELECT TOP 5 SubjectID, SubjectName, Description, Status FROM Subject";
                        ResultSet subjectRs = stmt.executeQuery(selectSql);
                        
                        out.println("<ul>");
                        while (subjectRs.next()) {
                            out.println("<li><strong>ID:</strong> " + subjectRs.getInt("SubjectID") + 
                                      ", <strong>Name:</strong> " + subjectRs.getString("SubjectName") + 
                                      ", <strong>Status:</strong> " + subjectRs.getString("Status") + "</li>");
                        }
                        out.println("</ul>");
                    }
                } else {
                    out.println("<p style='color: red;'>❌ ERROR: Could not get count from Subject table</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>❌ ERROR testing Subject table: " + e.getMessage() + "</p>");
                e.printStackTrace(out);
            }
            
            // STEP 3: Test DAOSubject
            out.println("<h2>📋 STEP 3: Testing DAOSubject.getAllSubjects()</h2>");
            try {
                DAOSubject daoSubject = new DAOSubject();
                List<Subject> subjects = daoSubject.getAllSubjects();
                
                if (subjects == null) {
                    out.println("<p style='color: red;'>❌ ERROR: subjects is null</p>");
                } else if (subjects.isEmpty()) {
                    out.println("<p style='color: orange;'>⚠️ WARNING: No subjects returned from DAO</p>");
                } else {
                    out.println("<p style='color: green;'>✅ SUCCESS: DAO returned " + subjects.size() + " subjects</p>");
                    out.println("<ul>");
                    for (Subject subject : subjects) {
                        out.println("<li><strong>ID:</strong> " + subject.getSubjectID() + 
                                  ", <strong>Name:</strong> " + subject.getSubjectName() + 
                                  ", <strong>Status:</strong> " + subject.getStatus() + "</li>");
                    }
                    out.println("</ul>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>❌ ERROR in DAOSubject: " + e.getMessage() + "</p>");
                e.printStackTrace(out);
            }
            
            // STEP 4: Test Request Attribute
            out.println("<h2>📋 STEP 4: Testing Request Attribute</h2>");
            try {
                DAOSubject daoSubject = new DAOSubject();
                List<Subject> subjects = daoSubject.getAllSubjects();
                
                request.setAttribute("subjects", subjects);
                List<Subject> retrievedSubjects = (List<Subject>) request.getAttribute("subjects");
                
                if (retrievedSubjects != null) {
                    out.println("<p style='color: green;'>✅ Request attribute set successfully: " + retrievedSubjects.size() + " subjects</p>");
                } else {
                    out.println("<p style='color: red;'>❌ Failed to set request attribute</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>❌ ERROR testing request attribute: " + e.getMessage() + "</p>");
                e.printStackTrace(out);
            }
            
            out.println("</body></html>");
            
        } catch (Exception e) {
            out.println("<h2 style='color: red;'>❌ CRITICAL ERROR:</h2>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        } finally {
            out.close();
        }
    }
}
