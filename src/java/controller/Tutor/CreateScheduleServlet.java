package controller.Tutor;

import entity.Schedule;
import entity.Subject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.Timestamp;
import model.DAOSchedule;
import model.DAOSubject;
import model.DAOTutor;
import model.DAOTutorSubject;

<<<<<<< HEAD
@WebServlet(name = "CreateScheduleServlet", urlPatterns = {"/tutor/schedule-management"})
=======
@WebServlet(name = "CreateSchedule", urlPatterns = {"/tutor/CreateSchedule"})
>>>>>>> 25bcd760110fa789b7faa0ce3d5dc724d69f1e92
public class CreateScheduleServlet extends HttpServlet {

     protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        DAOTutor daoTutor = new DAOTutor();
        DAOSubject daoSubject = new DAOSubject();
        DAOSchedule daoSchedule = new DAOSchedule();

        List<Subject> subjectList = new ArrayList<>();
        List<Schedule> scheduleList = new ArrayList<>();

        int tutorId = daoTutor.getTutorIdByUserId(userId);
        subjectList = daoSubject.getTutorSubjects(userId);
        scheduleList = daoSchedule.getSchedulesByTutorId(tutorId);
        request.setAttribute("subjectList", subjectList);
        request.setAttribute("scheduleList", scheduleList);
<<<<<<< HEAD
        // Forward to new calendar view for tutor schedule management
        request.getRequestDispatcher("/tutor/schedule-calendar.jsp").forward(request, response);
=======
        request.getRequestDispatcher("createschedule.jsp").forward(request, response);
>>>>>>> 25bcd760110fa789b7faa0ce3d5dc724d69f1e92
    }

    @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession();
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int subjectId = Integer.parseInt(request.getParameter("subject"));
  //  String startTimeStr = request.getParameter("startTime");
    int slotCount = Integer.parseInt(request.getParameter("slotCount")); // Lấy số lượng slot

//    if (subjectId <= 0 || startTimeStr == null || startTimeStr.isEmpty() || slotCount <= 0) {
//        request.setAttribute("message", "Vui lòng nhập đầy đủ thông tin.");
//        doGet(request, response);
//        return;
//    }

    try {
//        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
//        LocalDateTime startTimeLDT = LocalDateTime.parse(startTimeStr, formatter);
//        LocalDateTime now = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
//
//        if (startTimeLDT.isBefore(now)) {
//            request.setAttribute("message", "Không thể tạo lịch cho ngày trong quá khứ. Vui lòng chọn ngày hợp lệ.");
//            doGet(request, response);
//            return;
//        }

        DAOTutor daoTutor = new DAOTutor();
        DAOSchedule daoSchedule = new DAOSchedule();
        int tutorId = daoTutor.getTutorIdByUserId(userId);

        boolean isSuccess = true;
       for (int i = 1; i <= slotCount; i++) {
    Schedule newSchedule = new Schedule();
    newSchedule.setTutorID(tutorId);
    newSchedule.setSlotNumber(i);   // slot 1, 2, 3...
    newSchedule.setIsBooked(false);
    newSchedule.setSubjectId(subjectId);
    newSchedule.setStatus("Pending");

    if (!daoSchedule.insertSchedule(newSchedule)) {
        isSuccess = false;
    }
}

<<<<<<< HEAD
    private boolean validateStartTime(String startTimeStr) {
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime startTimeLDT = LocalDateTime.parse(startTimeStr, formatter);
            LocalDateTime now = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
            return !startTimeLDT.isBefore(now);
        } catch (Exception e) {
            return false;
        }
    }

    private boolean createSchedules(HttpServletRequest request, HttpServletResponse response, 
                                  User user, int subjectId, String startTimeStr, int slotCount) {
        try {
            DAOTutor daoTutor = new DAOTutor();
            DAOSchedule daoSchedule = new DAOSchedule();
            int tutorId = daoTutor.getTutorIdByUserId(user.getUserID());

            if (tutorId == -1) {
                request.setAttribute("error", "Không tìm thấy thông tin tutor.");
                return false;
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime startTimeLDT = LocalDateTime.parse(startTimeStr, formatter);

            for (int i = 0; i < slotCount; i++) {
                LocalDateTime slotStart = startTimeLDT.plusMinutes(60 * i);
                LocalDateTime slotEnd = slotStart.plusMinutes(60);

                // Chuyển LocalDateTime thành java.util.Date
                Date startTime = Date.from(slotStart.atZone(ZoneId.systemDefault()).toInstant());
                Date endTime = Date.from(slotEnd.atZone(ZoneId.systemDefault()).toInstant());

                // Tạo đối tượng Schedule
                Schedule newSchedule = new Schedule();
                newSchedule.setTutorID(tutorId);
                newSchedule.setStartTime(startTime);
                newSchedule.setEndTime(endTime);
                newSchedule.setIsBooked(false);
                newSchedule.setSubjectId(subjectId);
                newSchedule.setStatus("Available");

                // Chèn vào database
                if (!daoSchedule.insertSchedule(newSchedule)) {
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            Logger.getLogger(CreateScheduleServlet.class.getName()).log(Level.SEVERE, "Lỗi khi tạo lịch dạy", e);
            return false;
        }
    }

    private void handleDeleteSchedule(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        try {
            String scheduleIdStr = request.getParameter("scheduleId");
            if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID lịch không hợp lệ.");
                loadTutorData(request, response, user);
                return;
            }

            int scheduleId = Integer.parseInt(scheduleIdStr);
            
            // Lấy tutor ID của user hiện tại
            DAOTutor daoTutor = new DAOTutor();
            int currentTutorId = daoTutor.getTutorIdByUserId(user.getUserID());
            
            if (currentTutorId == -1) {
                request.setAttribute("error", "Không tìm thấy thông tin tutor  .");
                loadTutorData(request, response, user);
                return;
            }
            
            // Kiểm tra xem lịch có thuộc về tutor này không và có thể xóa không
            DAOSchedule daoSchedule = new DAOSchedule();
            Schedule schedule = daoSchedule.getScheduleById(scheduleId);
            
            if (schedule == null) {
                request.setAttribute("error", "Không tìm thấy lịch.");
            } else if (schedule.getTutorID() != currentTutorId) {
                request.setAttribute("error", "Bạn không có quyền xóa lịch này.");
            } else if (schedule.getIsBooked()) {
                request.setAttribute("error", "Không thể xóa lịch đã được đặt.");
            } else {
                // Xóa lịch
                int result = daoSchedule.deleteSchedule(scheduleId);
                if (result > 0) {
                    request.setAttribute("message", "Xóa lịch thành công!");
                } else {
                    request.setAttribute("error", "Có lỗi xảy ra khi xóa lịch.");
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID lịch không hợp lệ.");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            Logger.getLogger(CreateScheduleServlet.class.getName()).log(Level.SEVERE, "Lỗi khi xóa lịch dạy", e);
        }

        // Reload trang với thông báo
        loadTutorData(request, response, user);
=======

        request.setAttribute("message", isSuccess ? 
            "Tạo " + slotCount + " lịch dạy thành công!" : "Có lỗi xảy ra khi tạo lịch. Vui lòng thử lại.");
    } catch (Exception ex) {
        request.setAttribute("message", "Lỗi hệ thống: " + ex.getMessage());
        Logger.getLogger(CreateScheduleServlet.class.getName()).log(Level.SEVERE, null, ex);
>>>>>>> 25bcd760110fa789b7faa0ce3d5dc724d69f1e92
    }
    doGet(request, response);
}

    @Override
    public String getServletInfo() {
        return "Servlet for creating and viewing tutor schedules";
    }
}
