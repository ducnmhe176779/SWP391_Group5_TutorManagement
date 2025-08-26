package UserController;

import entity.Schedule;
import entity.User;
import model.DAOSchedule;
import model.DAOTutor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet chuyên xử lý calendar view cho booking system
 * Tách biệt với BookScheduleServlet để tránh conflict
 */
@WebServlet(name = "BookingCalendarServlet", urlPatterns = {"/booking-calendar"})
public class BookingCalendarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra authentication
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String view = request.getParameter("view");
        
        // Chỉ xử lý calendar view
        if ("calendar".equals(view)) {
            handleCalendarView(request, response, user);
        } else {
            // Redirect về BookSchedule cho các request khác
            response.sendRedirect(request.getContextPath() + "/BookSchedule?" + request.getQueryString());
        }
    }

    /**
     * Xử lý calendar view - hiển thị lịch tutor dạng lưới 7 ngày x khung giờ
     */
    private void handleCalendarView(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            String tutorIdStr = request.getParameter("tutorId");
            if (tutorIdStr == null || tutorIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/Tutor");
                return;
            }

            int tutorId = Integer.parseInt(tutorIdStr);
            
            // Lấy tuần hiện tại (bắt đầu từ thứ 2)
            Calendar cal = Calendar.getInstance();
            cal.setFirstDayOfWeek(Calendar.MONDAY);
            cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            
            Date startOfWeek = cal.getTime();
            
            // Lấy lịch available để booking
            DAOSchedule daoSchedule = new DAOSchedule();
            List<Schedule> availableSchedules = daoSchedule.getAllSchedulesForCalendar(tutorId, new Date());
            // Debug each schedule DOW
            for (Schedule s : availableSchedules) {
                Calendar sc = Calendar.getInstance();
                sc.setTime(s.getStartTime());
                System.out.println("DEBUG CAL: schedId=" + s.getScheduleID() + ", start=" + s.getStartTime() + ", DOW=" + sc.get(Calendar.DAY_OF_WEEK));
            }
            
            // Lấy thông tin tutor
            DAOTutor daoTutor = new DAOTutor();
            Object[] tutorDetailArray = daoTutor.getTutorDetailById(tutorId);
            String tutorName = daoTutor.getFullNameByTutorId(tutorId);
            
            // Tạo calendar data
            Map<String, Object> calendarData = createCalendarData(availableSchedules, startOfWeek);
            
            request.setAttribute("tutorId", tutorId);
            request.setAttribute("tutorDetailArray", tutorDetailArray);
            request.setAttribute("tutorName", tutorName);
            request.setAttribute("calendarData", calendarData);
            request.setAttribute("weekStart", startOfWeek);
            request.setAttribute("currentUser", user);
            
            request.getRequestDispatcher("/tutor-booking-calendar.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            Logger.getLogger(BookingCalendarServlet.class.getName()).log(Level.WARNING, "Invalid tutor ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Tutor");
        } catch (Exception e) {
            Logger.getLogger(BookingCalendarServlet.class.getName()).log(Level.SEVERE, "Error in calendar view: " + e.getMessage(), e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Tạo calendar data cho JSP
     */
    private Map<String, Object> createCalendarData(List<Schedule> schedules, Date startOfWeek) {
        Map<String, Object> calendarData = new HashMap<>();
        
        // Tạo array các ngày trong tuần
        String[] daysOfWeek = {"", "Chủ nhật", "Thứ hai", "Thứ ba", "Thứ tư", "Thứ năm", "Thứ sáu", "Thứ bảy"};
        List<String> dayNames = new ArrayList<>();
        List<Date> dayDates = new ArrayList<>();
        
        Calendar cal = Calendar.getInstance();
        cal.setFirstDayOfWeek(Calendar.MONDAY);
        cal.setTime(startOfWeek);
        
        // Tạo 7 ngày từ thứ 2 đến chủ nhật
        for (int i = 0; i < 7; i++) {
            int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
            dayNames.add(daysOfWeek[dayOfWeek]);
            dayDates.add(new Date(cal.getTimeInMillis()));
            cal.add(Calendar.DAY_OF_MONTH, 1);
        }
        
        // Tạo time slots từ 7h đến 22h
        List<Integer> timeSlots = new ArrayList<>();
        for (int hour = 7; hour <= 22; hour++) {
            timeSlots.add(hour);
        }
        
        // Tạo grid data từ schedules
        Map<String, Schedule> gridData = new HashMap<>();
        for (Schedule schedule : schedules) {
            Calendar schedCal = Calendar.getInstance();
            schedCal.setTime(schedule.getStartTime());
            // Convert Calendar.DAY_OF_WEEK (Sun=1..Sat=7) -> ISO (Mon=1..Sun=7)
            int dowJava = schedCal.get(Calendar.DAY_OF_WEEK); // 1..7
            int isoDay = ((dowJava + 5) % 7) + 1; // Mon=1..Sun=7
            int hour = schedCal.get(Calendar.HOUR_OF_DAY);
            
            String key = isoDay + "-" + hour;
            gridData.put(key, schedule);
        }
        
        calendarData.put("dayNames", dayNames);
        calendarData.put("dayDates", dayDates);
        calendarData.put("timeSlots", timeSlots);
        calendarData.put("gridData", gridData);
        calendarData.put("schedules", schedules);
        
        return calendarData;
    }

    @Override
    public String getServletInfo() {
        return "Servlet chuyên xử lý calendar view cho booking system";
    }
}
