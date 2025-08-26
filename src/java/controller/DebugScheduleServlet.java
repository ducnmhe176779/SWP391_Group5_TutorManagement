package controller;

import entity.Schedule;
import model.DAOSchedule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "DebugScheduleServlet", urlPatterns = {"/debug-schedules"})
public class DebugScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String tutorIdStr = request.getParameter("tutorId");
        
        if (tutorIdStr == null) {
            out.println("<h3>Usage: /debug-schedules?tutorId=8</h3>");
            return;
        }
        
        try {
            int tutorId = Integer.parseInt(tutorIdStr);
            
            DAOSchedule dao = new DAOSchedule();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            
            out.println("<h3>All Schedules for Tutor ID: " + tutorId + "</h3>");
            out.println("<table border='1' style='border-collapse: collapse;'>");
            out.println("<tr>");
            out.println("<th>Schedule ID</th>");
            out.println("<th>Start Time</th>");
            out.println("<th>End Time</th>");
            out.println("<th>IsBooked</th>");
            out.println("<th>Status</th>");
            out.println("<th>Subject ID</th>");
            out.println("<th>Actions</th>");
            out.println("</tr>");
            
            // Lấy tất cả schedule của tutor (không chỉ available)
            List<Schedule> allSchedules = dao.getAllSchedulesByTutorAndSubjectDebug(tutorId, 1); // English subject
            
            for (Schedule schedule : allSchedules) {
                String rowColor = schedule.getIsBooked() ? "background-color: #ffcccc;" : "background-color: #ccffcc;";
                out.println("<tr style='" + rowColor + "'>");
                out.println("<td>" + schedule.getScheduleID() + "</td>");
                out.println("<td>" + sdf.format(schedule.getStartTime()) + "</td>");
                out.println("<td>" + sdf.format(schedule.getEndTime()) + "</td>");
                out.println("<td>" + (schedule.getIsBooked() ? "✅ BOOKED" : "❌ Available") + "</td>");
                out.println("<td>" + schedule.getStatus() + "</td>");
                out.println("<td>" + schedule.getSubjectId() + "</td>");
                out.println("<td>");
                out.println("<a href='/SWP391_Group5_TutorManagement/test-schedule-update?scheduleId=" + schedule.getScheduleID() + "&booked=true'>Mark Booked</a> | ");
                out.println("<a href='/SWP391_Group5_TutorManagement/test-schedule-update?scheduleId=" + schedule.getScheduleID() + "&booked=false'>Mark Available</a>");
                out.println("</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
            
            out.println("<h4>Available Schedules Only (what calendar shows):</h4>");
            List<Schedule> availableSchedules = dao.getAvailableSchedules(tutorId, new java.util.Date());
            out.println("<p>Available count: " + availableSchedules.size() + "</p>");
            
            for (Schedule schedule : availableSchedules) {
                out.println("<p>ID: " + schedule.getScheduleID() + " - " + sdf.format(schedule.getStartTime()) + " to " + sdf.format(schedule.getEndTime()) + "</p>");
            }
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
}
