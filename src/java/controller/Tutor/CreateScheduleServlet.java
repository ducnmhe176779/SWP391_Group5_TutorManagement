package controller.Tutor;

import entity.Schedule;
import entity.Subject;
import entity.User;
import model.DAOSchedule;
import model.DAOSubject;
import model.DAOTutor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CreateScheduleServlet", urlPatterns = {"/tutor/CreateSchedule"})
public class CreateScheduleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập
        if (user == null || user.getRoleID() != 3) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Xử lý xóa lịch nếu có action delete
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            handleDeleteSchedule(request, response, user);
            return;
        }

        loadTutorData(request, response, user);
    }

    private void loadTutorData(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        DAOTutor daoTutor = new DAOTutor();
        DAOSubject daoSubject = new DAOSubject();
        DAOSchedule daoSchedule = new DAOSchedule();

        List<Subject> subjectList = new ArrayList<>();
        List<Schedule> scheduleList = new ArrayList<>();

        try {
            int tutorId = daoTutor.getTutorIdByUserId(user.getUserID());
            if (tutorId != -1) {
                subjectList = daoSubject.getTutorSubjects(user.getUserID());
                scheduleList = daoSchedule.getSchedulesByTutorId(tutorId);
            } else {
                // Nếu không tìm thấy tutor, tạo list rỗng
                subjectList = new ArrayList<>();
                scheduleList = new ArrayList<>();
                System.out.println("Không tìm thấy TutorID cho UserID: " + user.getUserID());
            }
        } catch (Exception ex) {
            Logger.getLogger(CreateScheduleServlet.class.getName()).log(Level.SEVERE, "Lỗi khi tải dữ liệu tutor", ex);
            // Tạo list rỗng nếu có lỗi
            subjectList = new ArrayList<>();
            scheduleList = new ArrayList<>();
        }
        
        request.setAttribute("subjectList", subjectList);
        request.setAttribute("scheduleList", scheduleList);
        request.getRequestDispatcher("/tutor/createschedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập
        if (user == null || user.getRoleID() != 3) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Lấy thông tin từ form
            String subjectIdStr = request.getParameter("subject");
            String startTimeStr = request.getParameter("startTime");
            String slotCountStr = request.getParameter("slotCount");

            // Debug logging
            System.out.println("=== DEBUG CREATE SCHEDULE ===");
            System.out.println("Subject ID: " + subjectIdStr);
            System.out.println("Start Time: " + startTimeStr);
            System.out.println("Slot Count: " + slotCountStr);
            System.out.println("=============================");

            // Validate input
            if (!validateInput(subjectIdStr, startTimeStr, slotCountStr)) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
                loadTutorData(request, response, user);
                return;
            }

            int subjectId = Integer.parseInt(subjectIdStr);
            int slotCount = Integer.parseInt(slotCountStr);

            // Validate slot count
            if (slotCount < 1 || slotCount > 10) {
                request.setAttribute("error", "Số lượng slot phải từ 1 đến 10.");
                loadTutorData(request, response, user);
                return;
            }

            // Validate start time
            if (!validateStartTime(startTimeStr)) {
                request.setAttribute("error", "Không thể tạo lịch cho ngày trong quá khứ. Vui lòng chọn ngày hợp lệ.");
                loadTutorData(request, response, user);
                return;
            }

            // Create schedules
            boolean isSuccess = createSchedules(request, response, user, subjectId, startTimeStr, slotCount);
            
            if (isSuccess) {
                request.setAttribute("message", "Tạo " + slotCount + " lịch dạy thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo lịch. Vui lòng thử lại.");
            }

        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException: " + e.getMessage());
            request.setAttribute("error", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.");
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            Logger.getLogger(CreateScheduleServlet.class.getName()).log(Level.SEVERE, null, e);
        }

        // Reload trang với thông báo
        loadTutorData(request, response, user);
    }

    private boolean validateInput(String subjectIdStr, String startTimeStr, String slotCountStr) {
        return subjectIdStr != null && startTimeStr != null && slotCountStr != null &&
               !subjectIdStr.trim().isEmpty() && !startTimeStr.trim().isEmpty() && !slotCountStr.trim().isEmpty();
    }

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
                request.setAttribute("error", "Không tìm thấy thông tin tutor.");
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
    }

    @Override
    public String getServletInfo() {
        return "Servlet for creating and viewing tutor schedules";
    }
}

