package UserController;

import entity.Booking;
import entity.Schedule;
import entity.Subject;
import entity.User;
import entity.Slot;
import model.DAOBooking;
import model.DAOSchedule;
import model.DAOSubject;
import model.DAOTutor;
import model.DAOSlot;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.Calendar;

@WebServlet(name = "BookScheduleServlet", urlPatterns = {"/BookSchedule"})
public class BookScheduleServlet extends HttpServlet {

    private DAOSchedule daoSchedule;
    private DAOBooking daoBooking;
    private DAOSubject daoSubject;
    private DAOTutor daoTutor;
    private DAOSlot daoSlot;

    @Override
    public void init() throws ServletException {
        System.out.println("=== DEBUG: BookScheduleServlet.init() được gọi ===");
        System.out.println("DEBUG: Servlet name: " + getServletName());
        System.out.println("DEBUG: Servlet info: " + getServletInfo());
        
        try {
            System.out.println("DEBUG: Bắt đầu khởi tạo DAO objects");
            daoSchedule = new DAOSchedule();
            System.out.println("DEBUG: DAOSchedule đã khởi tạo");
            daoBooking = new DAOBooking();
            System.out.println("DEBUG: DAOBooking đã khởi tạo");
            daoSubject = new DAOSubject();
            System.out.println("DEBUG: DAOSubject đã khởi tạo");
            daoTutor = new DAOTutor();
            System.out.println("DEBUG: DAOTutor đã khởi tạo");
            daoSlot = new DAOSlot();
            System.out.println("DEBUG: DAOSlot đã khởi tạo");
            
            System.out.println("DEBUG: Tất cả DAO objects đã được khởi tạo thành công");
        } catch (Exception e) {
            System.out.println("DEBUG: Lỗi khi khởi tạo DAO objects: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== DEBUG: doGet() được gọi ===");
        System.out.println("DEBUG: URL: " + request.getRequestURL());
        System.out.println("DEBUG: Method: " + request.getMethod());
        
        HttpSession session = request.getSession();
        System.out.println("DEBUG: Session ID: " + session.getId());
        User user = (User) session.getAttribute("user");
        System.out.println("DEBUG: User từ session: " + (user != null ? "Có user" : "Không có user"));

        // Kiểm tra quyền truy cập
        if (user == null) {
            System.out.println("DEBUG: Redirect đến login.jsp");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Kiểm tra nếu không có parameters, redirect với parameters mặc định
        String subjectIdStr = request.getParameter("subjectId");
        String tutorIdStr = request.getParameter("tutorId");
        
        if (subjectIdStr == null || subjectIdStr.trim().isEmpty()) {
            // Redirect với subjectId=1 (English) mặc định
            response.sendRedirect(request.getContextPath() + "/BookSchedule?subjectId=1");
            return;
        }

        try {
            System.out.println("DEBUG: Bắt đầu truy vấn database");
            
            // Lấy danh sách tất cả subjects
            System.out.println("DEBUG: Gọi daoSubject.getAllSubjects()");
            List<Subject> allSubjects = daoSubject.getAllSubjects();
            System.out.println("DEBUG: Số subjects: " + (allSubjects != null ? allSubjects.size() : "null"));
            request.setAttribute("allSubjects", allSubjects);
            
            // Parse subjectId
            int subjectId = Integer.parseInt(subjectIdStr);

            // Lấy thông tin môn học
            Subject selectedSubject = daoSubject.getSubjectById(subjectId);
            if (selectedSubject == null && !allSubjects.isEmpty()) {
                selectedSubject = allSubjects.get(0);
                subjectId = selectedSubject.getSubjectID();
            }

            // Lấy danh sách tutors theo subject
            List<Object[]> tutorsBySubject = daoTutor.getTutorsBySubject(subjectId);
            request.setAttribute("tutorsBySubject", tutorsBySubject);
            
            // Xử lý tutor được chọn
            int tutorId = 0;
            if (tutorIdStr != null && !tutorIdStr.trim().isEmpty() && !tutorIdStr.equals("null")) {
                try {
                    tutorId = Integer.parseInt(tutorIdStr);
                } catch (NumberFormatException e) {
                    tutorId = 0;
                }
            }
            
            // Nếu không có tutor được chọn hoặc tutor không hợp lệ, chọn tutor đầu tiên
            if (tutorId == 0 && !tutorsBySubject.isEmpty()) {
                tutorId = (Integer) tutorsBySubject.get(0)[0]; // TutorID là cột đầu tiên
                // Redirect với tutorId để URL có đầy đủ parameters
                response.sendRedirect(request.getContextPath() + "/BookSchedule?subjectId=" + subjectId + "&tutorId=" + tutorId);
                return;
            }

            if (tutorId > 0) {
                // Lấy thông tin chi tiết tutor
                Object[] tutorInfo = daoTutor.getTutorDetailById(tutorId);
                if (tutorInfo != null) {
                    // Debug: In ra các giá trị để kiểm tra
                    System.out.println("DEBUG: TutorInfo array:");
                    for (int i = 0; i < tutorInfo.length; i++) {
                        System.out.println("DEBUG: Index " + i + ": " + tutorInfo[i] + " (Type: " + (tutorInfo[i] != null ? tutorInfo[i].getClass().getSimpleName() : "null") + ")");
                    }
                    
                    request.setAttribute("tutorName", tutorInfo[1] != null ? tutorInfo[1].toString() : "N/A"); // FullName
                    
                    // Xử lý avatar: nếu null hoặc rỗng thì dùng default, nếu có thì giữ nguyên
                    String avatar = tutorInfo[2] != null ? tutorInfo[2].toString() : null;
                    if (avatar == null || avatar.trim().isEmpty()) {
                        request.setAttribute("tutorAvatar", "uploads/default_avatar.jpg");
                    } else {
                        request.setAttribute("tutorAvatar", avatar);
                    }
                    
                    request.setAttribute("tutorEducation", tutorInfo[3] != null ? tutorInfo[3].toString() : "N/A"); // Education
                    request.setAttribute("tutorExperience", tutorInfo[4] != null ? tutorInfo[4].toString() : "N/A"); // Experience
                    request.setAttribute("tutorCertificates", tutorInfo[5] != null ? tutorInfo[5].toString() : "N/A"); // Certificates
                    request.setAttribute("tutorEmail", tutorInfo[6] != null ? tutorInfo[6].toString() : "N/A"); // Email
                    request.setAttribute("tutorPhone", tutorInfo[7] != null ? tutorInfo[7].toString() : "N/A"); // Phone
                    
                    // Xử lý rating: có thể là Float hoặc Object
                    Object ratingObj = tutorInfo[8];
                    String ratingStr;
                    if (ratingObj instanceof Float) {
                        ratingStr = String.valueOf((Float) ratingObj);
                    } else if (ratingObj instanceof Double) {
                        ratingStr = String.valueOf((Double) ratingObj);
                    } else if (ratingObj instanceof Number) {
                        ratingStr = String.valueOf(((Number) ratingObj).floatValue());
                    } else {
                        ratingStr = ratingObj != null ? ratingObj.toString() : "0.0";
                    }
                    request.setAttribute("tutorRating", ratingStr);
                } else {
                    request.setAttribute("tutorName", "Tutor ID: " + tutorId);
                    request.setAttribute("tutorAvatar", "uploads/default_avatar.jpg");
                    request.setAttribute("tutorEducation", "N/A");
                    request.setAttribute("tutorExperience", "N/A");
                    request.setAttribute("tutorCertificates", "N/A");
                    request.setAttribute("tutorEmail", "N/A");
                    request.setAttribute("tutorPhone", "N/A");
                    request.setAttribute("tutorRating", "0.0");
                }

                // Debug: Lấy tất cả schedules trước
                System.out.println("=== DEBUG: Lấy TẤT CẢ schedules ===");
                List<Schedule> allSchedules = daoSchedule.getAllSchedulesByTutorAndSubjectDebug(tutorId, subjectId);
                
                // Lấy danh sách lịch có sẵn của tutor (có filter)
                System.out.println("=== DEBUG: Lấy schedules có filter ===");
                List<Schedule> scheduleList = daoSchedule.getSchedulesByTutorAndSubject(tutorId, subjectId);
                request.setAttribute("scheduleList", scheduleList);
            } else {
                // Không có tutor nào
                request.setAttribute("scheduleList", null);
                request.setAttribute("tutorName", "No Tutor Available");
                request.setAttribute("tutorAvatar", "uploads/default_avatar.jpg");
            }
            
            request.setAttribute("selectedSubjectId", subjectId);
            request.setAttribute("selectedTutorId", tutorId);
            request.setAttribute("subjectName", selectedSubject != null ? selectedSubject.getSubjectName() : "N/A");

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/bookschedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== DEBUG: doPost() được gọi ===");
        System.out.println("DEBUG: URL: " + request.getRequestURL());
        System.out.println("DEBUG: Method: " + request.getMethod());
        
        HttpSession session = request.getSession();
        System.out.println("DEBUG: Session ID trong doPost: " + session.getId());
        User user = (User) session.getAttribute("user");
        System.out.println("DEBUG: User từ session trong doPost: " + (user != null ? "Có user" : "Không có user"));

        // Kiểm tra quyền truy cập
        if (user == null) {
            System.out.println("DEBUG: Redirect đến login.jsp từ doPost");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Xử lý đặt lịch
        System.out.println("DEBUG: Gọi handleBooking()");
        handleBooking(request, response, user);
    }

    private void handleBooking(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        try {
            System.out.println("=== DEBUG: Bắt đầu xử lý booking ===");
            
            // Lấy thông tin từ form
            String tutorIdStr = request.getParameter("tutorId");
            String subjectIdStr = request.getParameter("subjectId");
            String selectedScheduleStr = request.getParameter("selectedSchedule");
            
            System.out.println("DEBUG: tutorId = " + tutorIdStr);
            System.out.println("DEBUG: subjectId = " + subjectIdStr);
            System.out.println("DEBUG: selectedSchedule = " + selectedScheduleStr);

            // Validate input
            if (tutorIdStr == null || subjectIdStr == null || selectedScheduleStr == null ||
                tutorIdStr.trim().isEmpty() || subjectIdStr.trim().isEmpty() || selectedScheduleStr.trim().isEmpty()) {
                System.out.println("DEBUG: Lỗi validate input - thiếu thông tin");
                request.setAttribute("error", "Vui lòng chọn lịch học.");
                doGet(request, response);
                return;
            }

            int tutorId = Integer.parseInt(tutorIdStr);
            int subjectId = Integer.parseInt(subjectIdStr);
            int scheduleId = Integer.parseInt(selectedScheduleStr);

            System.out.println("DEBUG: Đã parse thành công - tutorId: " + tutorId + ", subjectId: " + subjectId + ", scheduleId: " + scheduleId);
            
            // Kiểm tra xem lịch có còn khả dụng không
            Schedule schedule = daoSchedule.getScheduleById(scheduleId);
            System.out.println("DEBUG: Schedule từ database: " + (schedule != null ? "Tồn tại" : "Không tồn tại"));
            
            if (schedule == null) {
                System.out.println("DEBUG: Lỗi - Lịch học không tồn tại");
                request.setAttribute("error", "Lịch học không tồn tại.");
                doGet(request, response);
                return;
            }

            System.out.println("DEBUG: Schedule details - TutorID: " + schedule.getTutorID() + ", IsBooked: " + schedule.getIsBooked());
            
            if (schedule.getIsBooked()) {
                System.out.println("DEBUG: Lỗi - Lịch học đã được đặt");
                request.setAttribute("error", "Lịch học này đã được đặt.");
                doGet(request, response);
                return;
            }

            if (schedule.getTutorID() != tutorId) {
                System.out.println("DEBUG: Lỗi - Lịch học không thuộc về tutor này");
                request.setAttribute("error", "Lịch học không thuộc về tutor này.");
                doGet(request, response);
                return;
            }

            // Kiểm tra xem học sinh đã đặt lịch này chưa
            boolean hasBooked = daoBooking.hasStudentBookedSchedule(user.getUserID(), scheduleId);
            System.out.println("DEBUG: Học sinh đã đặt lịch này: " + hasBooked);
            
            if (hasBooked) {
                System.out.println("DEBUG: Lỗi - Học sinh đã đặt lịch này rồi");
                request.setAttribute("error", "Bạn đã đặt lịch học này rồi.");
                doGet(request, response);
                return;
            }

            System.out.println("DEBUG: Bắt đầu tạo booking mới");
            
            // Tạo booking mới
            Booking booking = new Booking();
            booking.setStudentID(user.getUserID());
            booking.setStudentName(user.getFullName());
            booking.setTutorID(tutorId);
            booking.setTutorName("Tutor ID: " + tutorId); // Có thể cải thiện bằng cách lấy tên thật
            
            // Tạm thời sử dụng ScheduleID làm SlotID để test
            // TODO: Sau này sẽ tạo Slot thực sự
            int slotId = schedule.getScheduleID();
            System.out.println("DEBUG: Sử dụng ScheduleID làm SlotID: " + slotId);
            
            booking.setSlotID(slotId);
            booking.setBookingDate(new Date(System.currentTimeMillis()));
            booking.setStatus("Pending");
            booking.setSubjectID(subjectId);
            
            System.out.println("DEBUG: Booking object đã tạo - StudentID: " + booking.getStudentID() + 
                             ", TutorID: " + booking.getTutorID() + 
                             ", SlotID: " + booking.getSlotID() + 
                             ", SubjectID: " + booking.getSubjectID());

            // Thêm booking vào database
            System.out.println("DEBUG: Gọi daoBooking.addBooking()");
            int result = daoBooking.addBooking(booking);
            System.out.println("DEBUG: Kết quả addBooking: " + result);
            
            if (result > 0) {
                System.out.println("DEBUG: Booking thành công, cập nhật trạng thái lịch");
                // Cập nhật trạng thái lịch
                schedule.setIsBooked(true);
                boolean updateResult = daoSchedule.updateScheduleStatus(scheduleId, true);
                System.out.println("DEBUG: Kết quả updateScheduleStatus: " + updateResult);
                
                // Lưu thông tin cần thiết vào session để hiển thị trong trang thanh toán
                HttpSession session = request.getSession();
                session.setAttribute("tutorName", request.getAttribute("tutorName"));
                session.setAttribute("subjectName", request.getAttribute("subjectName"));
                session.setAttribute("totalAmount", "10.0"); // Giá cố định, có thể lấy từ database sau
                session.setAttribute("selectedSchedules", java.util.Arrays.asList(schedule));
                
                System.out.println("DEBUG: Forward đến trang thanh toán");
                // Forward đến trang thanh toán thay vì redirect
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
                return;
            } else {
                System.out.println("DEBUG: Lỗi - addBooking trả về 0");
                request.setAttribute("error", "Có lỗi xảy ra khi đặt lịch. Vui lòng thử lại.");
            }

        } catch (NumberFormatException e) {
            System.out.println("DEBUG: Lỗi NumberFormatException: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.");
        } catch (Exception e) {
            System.out.println("DEBUG: Lỗi Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        // Reload trang với thông báo lỗi
        System.out.println("DEBUG: Reload trang với thông báo lỗi");
        doGet(request, response);
    }
    
    /**
     * Tạo Slot mới từ Schedule - TẠM THỜI KHÔNG SỬ DỤNG
     */
    /*
    private int createSlotFromSchedule(Schedule schedule) {
        try {
            System.out.println("DEBUG: Bắt đầu tạo Slot từ Schedule ID: " + schedule.getScheduleID());
            
            // Tạo Slot object
            Slot slot = new Slot();
            slot.setTutorID(schedule.getTutorID());
            // Convert Date to Timestamp
            slot.setStartTime(new java.sql.Timestamp(schedule.getStartTime().getTime()));
            slot.setEndTime(new java.sql.Timestamp(schedule.getEndTime().getTime()));
            slot.setSubjectID(schedule.getSubjectId());
            slot.setStatus("Available");
            
            System.out.println("DEBUG: Slot object đã tạo - TutorID: " + slot.getTutorID() + 
                             ", StartTime: " + slot.getStartTime() + 
                             ", EndTime: " + slot.getEndTime() + 
                             ", SubjectID: " + slot.getSubjectID());
            
            // Thêm Slot vào database
            int slotId = daoSlot.addSlot(slot);
            System.out.println("DEBUG: Kết quả addSlot: " + slotId);
            
            return slotId;
            
        } catch (Exception e) {
            System.out.println("DEBUG: Lỗi khi tạo Slot: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }
    */
}
