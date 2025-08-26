package UserController;

import entity.User;
import model.DAOUser;
import model.DAOToken;
import entity.Token; // Sử dụng entity.Token
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "UserRegister", urlPatterns = {"/User"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class UserRegister extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UserRegister.class.getName());
    private static final String REGISTER_JSP = "/register.jsp";
    private static final String LOGIN_JSP = "login.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String service = request.getParameter("service");
        if ("registerUser".equals(service)) {
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
        } else if ("registerStudent".equals(service)) {
            request.getRequestDispatcher("/register-student.jsp").forward(request, response);
        } else if ("registerTutor".equals(service)) {
            // Load subjects for tutor registration
            loadSubjectsForTutorRegistration(request);
            request.getRequestDispatcher("/register-tutor.jsp").forward(request, response);
        } else {
            // Default redirect to registration choice page
            request.getRequestDispatcher("/register-choice.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        String service = request.getParameter("service");

        if (!"registerUser".equals(service) && !"registerStudent".equals(service) && !"registerTutor".equals(service)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid service parameter");
            return;
        }

        String submit = request.getParameter("submit");
        if (submit == null) {
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
            return;
        }

        DAOUser dao = new DAOUser();
        if (!dao.isConnected()) {
            LOGGER.log(Level.SEVERE, "Database connection is null");
            request.setAttribute("error", "Không thể kết nối cơ sở dữ liệu. Vui lòng thử lại sau.");
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
            return;
        }

        // Lấy dữ liệu từ form
        String email = request.getParameter("Email");
        String fullName = request.getParameter("FullName");
        String phone = request.getParameter("Phone");
        String dob = request.getParameter("Dob");
        String address = request.getParameter("Address");
        String avatar = request.getParameter("Avatar");
        String userName = request.getParameter("UserName");
        String password = request.getParameter("Password"); // Giữ plaintext

        String avatarPath = handleFileUpload(request);

        try {
            String error = validateInput(dao, email, fullName, phone, dob, address, userName, password);
            if (!error.isEmpty()) {
                request.setAttribute("error", error);
                
                // Reload subjects for tutor registration on error
                if ("registerTutor".equals(service)) {
                    loadSubjectsForTutorRegistration(request);
                }
                
                String targetJsp = getTargetJsp(service);
                request.getRequestDispatcher(targetJsp).forward(request, response);
                return;
            }

            // Xác định RoleID dựa trên service
            int roleId = getRoleIdFromService(service);
            
            // Tạo đối tượng User với mật khẩu plaintext
            User newUser = new User(
                    0, roleId, email, fullName, phone, null, 0, Date.valueOf(dob),
                    address, avatarPath != null ? avatarPath : "uploads/default_avatar.jpg",
                    userName, password // Truyền plaintext
            );

            // Đăng ký người dùng và lấy UserID
            int userId = dao.registerUser(newUser);
            if (userId > 0) {
                
                // Nếu đăng ký tutor, tạo CV
                if ("registerTutor".equals(service)) {
                    boolean cvCreated = createTutorCV(request, userId);
                    if (!cvCreated) {
                        request.setAttribute("error", "Đăng ký thành công nhưng có lỗi khi tạo CV. Vui lòng cập nhật CV sau.");
                        
                        // Reload subjects for tutor registration on error
                        if ("registerTutor".equals(service)) {
                            loadSubjectsForTutorRegistration(request);
                        }
                        
                        String targetJsp = getTargetJsp(service);
                        request.getRequestDispatcher(targetJsp).forward(request, response);
                        return;
                    }
                }
                // Tạo token kích hoạt bằng resetService
                resetService resetSvc = new resetService();
                String token = resetSvc.generateToken();

                Token activationToken = new Token(
                        userId, false, token, resetSvc.expireDateTime()
                );
                DAOToken daoToken = new DAOToken();
                boolean isTokenSaved = daoToken.insertTokenForget(activationToken);

                if (!isTokenSaved) {
                    request.setAttribute("error", "Lỗi khi lưu token kích hoạt. Vui lòng thử lại.");
                    
                    // Reload subjects for tutor registration on error
                    if ("registerTutor".equals(service)) {
                        loadSubjectsForTutorRegistration(request);
                    }
                    
                    String targetJsp = getTargetJsp(service);
                    request.getRequestDispatcher(targetJsp).forward(request, response);
                    return;
                }

                // Gửi email kích hoạt
                String activationLink = "http://localhost:9999/SWP391_Group5_TutorManagement/activate?token=" + token;
                boolean isEmailSent = resetSvc.sendActivationEmail(email, activationLink, fullName);

                if (!isEmailSent) {
                    request.setAttribute("error", "Không thể gửi email kích hoạt. Vui lòng thử lại.");
                    
                    // Reload subjects for tutor registration on error
                    if ("registerTutor".equals(service)) {
                        loadSubjectsForTutorRegistration(request);
                    }
                    
                    String targetJsp = getTargetJsp(service);
                    request.getRequestDispatcher(targetJsp).forward(request, response);
                    return;
                }

                session.setAttribute("success", "Đăng ký thành công! Vui lòng kiểm tra email để kích hoạt tài khoản.");
                response.sendRedirect(LOGIN_JSP);
            } else {
                request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                
                // Reload subjects for tutor registration on error
                if ("registerTutor".equals(service)) {
                    loadSubjectsForTutorRegistration(request);
                }
                
                String targetJsp = getTargetJsp(service);
                request.getRequestDispatcher(targetJsp).forward(request, response);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error registering user", ex);
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
        }
    }

    // Các phương thức khác giữ nguyên
    private String handleFileUpload(HttpServletRequest request) throws IOException, ServletException {
        try {
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = extractFileName(filePart);
                if (fileName != null && isImageFile(fileName)) {
                    String uploadPath = getServletContext().getRealPath("") + "uploads/";
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    filePart.write(uploadPath + fileName);
                    return "uploads/" + fileName;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error uploading file", e);
        }
        return null;
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return null;
    }

    private boolean isImageFile(String fileName) {
        String[] allowedExtensions = {".jpg", ".jpeg", ".png", ".gif"};
        for (String ext : allowedExtensions) {
            if (fileName.toLowerCase().endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    private String validateInput(DAOUser dao, String email, String fullName, String phone, String dob,
            String address, String userName, String password) throws SQLException {
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "Email không hợp lệ.";
        }
        if (dao.isEmailExists(email)) {
            return "Email đã được sử dụng.";
        }
        if (userName == null || userName.trim().isEmpty()) {
            return "Username không được để trống.";
        }
        if (dao.isUsernameExists(userName)) {
            return "Username đã tồn tại.";
        }
        if (phone == null || !phone.matches("\\d{10}")) {
            return "Số điện thoại phải là 10 chữ số.";
        }
        if (dao.isPhoneExists(phone)) {
            return "Số điện thoại đã được sử dụng.";
        }
        if (password == null || password.length() < 8) {
            return "Mật khẩu phải dài ít nhất 8 ký tự.";
        }
        if (dob == null || dob.trim().isEmpty()) {
            return "Ngày sinh không được để trống.";
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Họ và tên không được để trống.";
        }
        if (address == null || address.trim().isEmpty()) {
            return "Địa chỉ không được để trống.";
        }
        return "";
    }

    /**
     * Helper method để xác định RoleID từ service
     */
    private int getRoleIdFromService(String service) {
        switch (service) {
            case "registerStudent":
                return 2; // Student role
            case "registerTutor":
                return 3; // Tutor role
            case "registerUser":
            default:
                return 2; // Default to student
        }
    }
    
    /**
     * Helper method để xác định target JSP từ service
     */
    private String getTargetJsp(String service) {
        switch (service) {
            case "registerStudent":
                return "/register-student.jsp";
            case "registerTutor":
                return "/register-tutor.jsp";
            case "registerUser":
            default:
                return REGISTER_JSP;
        }
    }
    
    /**
     * Load subjects và skill categories cho form đăng ký tutor
     */
    private void loadSubjectsForTutorRegistration(HttpServletRequest request) {
        System.out.println("=== DEBUG: loadSubjectsForTutorRegistration() called ===");
        try {
            // Load subjects
            model.DAOSubject daoSubject = new model.DAOSubject();
            java.util.List<entity.Subject> subjects = daoSubject.getAllSubjects();
            request.setAttribute("subjects", subjects);
            System.out.println("DEBUG: Loaded " + (subjects != null ? subjects.size() : 0) + " subjects");
            
            // Load skill categories - TEMPORARILY DISABLED FOR TESTING
            /*
            model.DAOTutorSkill daoTutorSkill = new model.DAOTutorSkill();
            java.util.List<entity.SkillCategory> skillCategories = daoTutorSkill.getAllSkillCategories();
            request.setAttribute("skillCategories", skillCategories);
            System.out.println("DEBUG: Loaded " + (skillCategories != null ? skillCategories.size() : 0) + " skill categories");
            
            // Load popular skills for suggestions
            java.util.List<String> popularSkills = daoTutorSkill.getPopularSkills(20);
            request.setAttribute("popularSkills", popularSkills);
            System.out.println("DEBUG: Loaded " + popularSkills.size() + " popular skills");
            */
            
            // Set empty lists for now
            request.setAttribute("skillCategories", new java.util.ArrayList<>());
            request.setAttribute("popularSkills", new java.util.ArrayList<>());
            System.out.println("DEBUG: Skill categories and popular skills temporarily disabled");
            
        } catch (Exception e) {
            System.out.println("ERROR: Exception in loadSubjectsForTutorRegistration: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error loading data for tutor registration", e);
            request.setAttribute("subjects", new java.util.ArrayList<>());
            request.setAttribute("skillCategories", new java.util.ArrayList<>());
            request.setAttribute("popularSkills", new java.util.ArrayList<>());
        }
        System.out.println("=== DEBUG: loadSubjectsForTutorRegistration() completed ===");
    }
    
    /**
     * Tạo CV cho tutor mới đăng ký
     */
    private boolean createTutorCV(HttpServletRequest request, int userId) {
        try {
            // Lấy thông tin cơ bản
            String education = request.getParameter("Education");
            String experience = request.getParameter("Experience");
            String certificates = request.getParameter("Certificates");
            String description = request.getParameter("Description");
            String skills = request.getParameter("Skills");
            String detailedExperience = request.getParameter("DetailedExperience");
            
            // Xử lý CV image upload
            String cvImagePath = handleCVImageUpload(request);
            
            // Tạo CV
            model.DAOCv daoCv = new model.DAOCv();
            entity.Cv cv = new entity.Cv();
            
            cv.setUserId(userId);
            cv.setEducation(education != null ? education : "Chưa cập nhật");
            cv.setExperience(experience != null ? experience : "Chưa cập nhật");
            cv.setCertificates(certificates != null ? certificates : "Chưa có");
            cv.setDescription(description != null ? description : "Chưa có mô tả");
            cv.setStatus("Pending"); // Chờ admin duyệt
            cv.setSubjectId(1); // Default subject, sẽ được override bởi TutorSubject
            
            // Thêm các trường mới
            if (skills != null && !skills.trim().isEmpty()) {
                cv.setSkill(skills);
            } else {
                cv.setSkill("Chưa cập nhật");
            }
            
            // Lấy giá từ form
            String priceStr = request.getParameter("Price");
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    float price = Float.parseFloat(priceStr);
                    cv.setPrice(price);
                } catch (NumberFormatException e) {
                    cv.setPrice(0.0f); // Giá mặc định nếu parse lỗi
                }
            } else {
                cv.setPrice(0.0f); // Giá mặc định
            }
            
            int cvId = daoCv.sendCv(cv);
            System.out.println("DEBUG: CV creation result - cvId: " + cvId);
            
            if (cvId > 0) {
                System.out.println("DEBUG: CV created successfully with ID: " + cvId);
                
                // AUTO-ASSIGN CV TO STAFF FOR REVIEW
                try {
                    model.DAOCVAssignment daoCvAssignment = new model.DAOCVAssignment();
                    boolean assignmentResult = daoCvAssignment.autoAssignCV(cvId);
                    
                    if (assignmentResult) {
                        System.out.println("SUCCESS: CV " + cvId + " has been automatically assigned to staff for review");
                    } else {
                        System.out.println("WARNING: CV " + cvId + " created but failed to auto-assign to staff");
                    }
                } catch (Exception e) {
                    System.out.println("ERROR: Failed to auto-assign CV " + cvId + " to staff: " + e.getMessage());
                    e.printStackTrace();
                }
                
                // Tạo record Tutor
                model.DAOTutor daoTutor = new model.DAOTutor();
                entity.Tutor tutor = new entity.Tutor();
                tutor.setCVID(cvId);
                tutor.setRating(0.0f); // Rating ban đầu
                tutor.setPrice(0.0f); // Giá mặc định, sẽ được cập nhật sau
                
                System.out.println("DEBUG: Attempting to create Tutor with CVID: " + cvId);
                System.out.println("DEBUG: CVID value: " + cvId);
                int tutorResult = daoTutor.addTutor(tutor);
                System.out.println("DEBUG: Tutor creation result: " + tutorResult);
                
                if (tutorResult > 0) {
                    // TutorID đã được trả về trực tiếp từ OUTPUT clause
                    int tutorId = tutorResult;
                    System.out.println("DEBUG: Using TutorID from OUTPUT clause: " + tutorId);
                    
                    // Xử lý subjects được chọn
                    boolean subjectsCreated = createTutorSubjects(request, tutorId);
                    System.out.println("DEBUG: Subjects creation result: " + subjectsCreated);
                    
                    // Xử lý skills được nhập
                    boolean skillsCreated = createTutorSkills(request, tutorId);
                    System.out.println("DEBUG: Skills creation result: " + skillsCreated);
                    
                    // Xử lý experiences được nhập
                    boolean experiencesCreated = createTutorExperiences(request, tutorId);
                    System.out.println("DEBUG: Experiences creation result: " + experiencesCreated);
                    
                    // Log thông tin bổ sung
                    if (skills != null && !skills.trim().isEmpty()) {
                        System.out.println("Tutor skills: " + skills);
                    }
                    if (detailedExperience != null && !detailedExperience.trim().isEmpty()) {
                        System.out.println("Detailed experience: " + detailedExperience);
                    }
                    if (cvImagePath != null) {
                        System.out.println("CV image uploaded: " + cvImagePath);
                    }
                    
                    System.out.println("DEBUG: Final registration results - Subjects: " + subjectsCreated + 
                                     ", Skills: " + skillsCreated + ", Experiences: " + experiencesCreated);
                    
                    boolean finalResult = subjectsCreated && skillsCreated && experiencesCreated;
                    System.out.println("DEBUG: Final return value: " + finalResult);
                    return finalResult;
                } else {
                    System.out.println("ERROR: Failed to create Tutor record. tutorResult: " + tutorResult);
                }
            } else {
                System.out.println("ERROR: Failed to create CV. cvId: " + cvId);
            }
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating tutor CV", e);
            return false;
        }
    }
    
    /**
     * Tạo TutorSubject records cho các môn học được chọn - Enhanced version
     */
    private boolean createTutorSubjects(HttpServletRequest request, int tutorId) {
        try {
            String[] selectedSubjects = request.getParameterValues("selectedSubjects");
            if (selectedSubjects == null || selectedSubjects.length == 0) {
                System.out.println("No subjects selected, using default subject ID 1");
                // Nếu không chọn môn học nào, tạo default với subject ID 1
                return createDefaultTutorSubject(tutorId);
            }
            // Chỉ cho phép 1 môn được chọn: lấy phần tử đầu tiên hợp lệ
            // Nếu front-end là radio, selectedSubjects chỉ có 1 phần tử
            String first = selectedSubjects[0];
            int subjectId;
            try {
                subjectId = Integer.parseInt(first);
            } catch (NumberFormatException e) {
                // Nếu client gửi SubjectName, convert sang ID
                model.DAOSubject daoSubject = new model.DAOSubject();
                subjectId = daoSubject.getSubjectIdByName(first);
                if (subjectId <= 0) {
                    System.out.println("Cannot resolve SubjectName to ID: " + first + ", fallback to default subject 1");
                    return createDefaultTutorSubject(tutorId);
                }
            }

            model.DAOTutorSubject daoTutorSubject = new model.DAOTutorSubject();
            boolean result = daoTutorSubject.addTutorSubject(tutorId, subjectId);
            System.out.println("Created single TutorSubject for SubjectID=" + subjectId + ": " + result);
            return result;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating tutor subjects", e);
            return false;
        }
    }
    
    /**
     * Tạo một TutorSubject record
     */
    private boolean createSingleTutorSubject(int tutorId, int subjectId) {
        try {
            // Kiểm tra xem có DAO cho TutorSubject không, nếu không thì tạo manual
            String sql = "INSERT INTO TutorSubject (TutorID, SubjectID) VALUES (?, ?)";
            
            model.DBConnect dbConnect = new model.DBConnect();
            try (java.sql.PreparedStatement ps = dbConnect.getConnection().prepareStatement(sql)) {
                ps.setInt(1, tutorId);
                ps.setInt(2, subjectId);
                
                int result = ps.executeUpdate();
                return result > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating single tutor subject", e);
            return false;
        }
    }
    
    /**
     * Tạo TutorSubject mặc định
     */
    private boolean createDefaultTutorSubject(int tutorId) {
        return createSingleTutorSubject(tutorId, 1); // Subject ID 1 làm default
    }
    
    /**
     * Xử lý upload ảnh CV
     */
    private String handleCVImageUpload(HttpServletRequest request) {
        try {
            Part cvImagePart = request.getPart("cvImage");
            if (cvImagePart != null && cvImagePart.getSize() > 0) {
                String fileName = cvImagePart.getSubmittedFileName();
                if (fileName != null && !fileName.isEmpty()) {
                    // Tạo tên file unique
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = "cv_" + System.currentTimeMillis() + fileExtension;
                    
                    // Đường dẫn lưu file
                    String uploadPath = request.getServletContext().getRealPath("/uploads/cv/");
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    String filePath = uploadPath + uniqueFileName;
                    cvImagePart.write(filePath);
                    
                    return "uploads/cv/" + uniqueFileName;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error handling CV image upload", e);
        }
        return null;
    }
    
    /**
     * Tạo TutorSkills records cho các kỹ năng được nhập
     */
    private boolean createTutorSkills(HttpServletRequest request, int tutorId) {
        try {
            model.DAOTutorSkill daoTutorSkill = new model.DAOTutorSkill();
            java.util.List<entity.TutorSkill> skills = new java.util.ArrayList<>();
            
            // Lấy skills data từ form
            String[] skillNames = request.getParameterValues("skillName");
            String[] skillLevels = request.getParameterValues("skillLevel");
            String[] skillYears = request.getParameterValues("skillYears");
            String[] skillDescriptions = request.getParameterValues("skillDescription");
            String[] skillCategories = request.getParameterValues("skillCategory");
            
            if (skillNames != null && skillNames.length > 0) {
                for (int i = 0; i < skillNames.length; i++) {
                    if (skillNames[i] != null && !skillNames[i].trim().isEmpty()) {
                        entity.TutorSkill skill = new entity.TutorSkill();
                        skill.setTutorID(tutorId);
                        skill.setSkillName(skillNames[i].trim());
                        
                        // Set skill level
                        if (skillLevels != null && i < skillLevels.length) {
                            skill.setSkillLevel(skillLevels[i]);
                        } else {
                            skill.setSkillLevel("Intermediate");
                        }
                        
                        // Set years of experience
                        if (skillYears != null && i < skillYears.length) {
                            try {
                                skill.setYearsOfExperience(Integer.parseInt(skillYears[i]));
                            } catch (NumberFormatException e) {
                                skill.setYearsOfExperience(0);
                            }
                        }
                        
                        // Set description
                        if (skillDescriptions != null && i < skillDescriptions.length) {
                            skill.setDescription(skillDescriptions[i]);
                        }
                        
                        // Set category ID
                        if (skillCategories != null && i < skillCategories.length) {
                            try {
                                skill.setCategoryID(Integer.parseInt(skillCategories[i]));
                            } catch (NumberFormatException e) {
                                skill.setCategoryID(0);
                            }
                        }
                        
                        skills.add(skill);
                    }
                }
            }
            
            // Nếu không có skills, tạo default skill
            if (skills.isEmpty()) {
                entity.TutorSkill defaultSkill = new entity.TutorSkill();
                defaultSkill.setTutorID(tutorId);
                defaultSkill.setSkillName("Teaching");
                defaultSkill.setSkillLevel("Intermediate");
                defaultSkill.setYearsOfExperience(1);
                defaultSkill.setDescription("General teaching skills");
                defaultSkill.setCategoryID(4); // Teaching Methods category
                skills.add(defaultSkill);
                System.out.println("DEBUG: Created default teaching skill for TutorID " + tutorId);
            }
            
            boolean result = daoTutorSkill.addTutorSkills(tutorId, skills);
            System.out.println("DEBUG: Created " + skills.size() + " skills for TutorID " + tutorId + ", Result: " + result);
            return result;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating tutor skills", e);
            return false;
        }
    }
    
    /**
     * Tạo TutorExperience records cho các kinh nghiệm được nhập
     */
    private boolean createTutorExperiences(HttpServletRequest request, int tutorId) {
        try {
            model.DAOTutorExperience daoTutorExperience = new model.DAOTutorExperience();
            java.util.List<entity.TutorExperience> experiences = new java.util.ArrayList<>();
            
            // Lấy experiences data từ form
            String[] jobTitles = request.getParameterValues("experienceJobTitle");
            String[] companies = request.getParameterValues("experienceCompany");
            String[] locations = request.getParameterValues("experienceLocation");
            String[] startDates = request.getParameterValues("experienceStartDate");
            String[] endDates = request.getParameterValues("experienceEndDate");
            String[] isCurrents = request.getParameterValues("experienceIsCurrent");
            String[] descriptions = request.getParameterValues("experienceDescription");
            String[] achievements = request.getParameterValues("experienceAchievements");
            
            if (jobTitles != null && jobTitles.length > 0) {
                for (int i = 0; i < jobTitles.length; i++) {
                    if (jobTitles[i] != null && !jobTitles[i].trim().isEmpty()) {
                        entity.TutorExperience experience = new entity.TutorExperience();
                        experience.setTutorID(tutorId);
                        experience.setJobTitle(jobTitles[i].trim());
                        
                        // Set company
                        if (companies != null && i < companies.length) {
                            experience.setCompany(companies[i]);
                        }
                        
                        // Set location
                        if (locations != null && i < locations.length) {
                            experience.setLocation(locations[i]);
                        }
                        
                        // Set start date
                        if (startDates != null && i < startDates.length && !startDates[i].trim().isEmpty()) {
                            try {
                                experience.setStartDate(java.sql.Date.valueOf(startDates[i]));
                            } catch (IllegalArgumentException e) {
                                System.out.println("DEBUG: Invalid start date format: " + startDates[i]);
                                experience.setStartDate(new java.sql.Date(System.currentTimeMillis()));
                            }
                        } else {
                            experience.setStartDate(new java.sql.Date(System.currentTimeMillis()));
                        }
                        
                        // Set end date and current status
                        boolean isCurrent = false;
                        if (isCurrents != null && i < isCurrents.length) {
                            isCurrent = "true".equals(isCurrents[i]) || "on".equals(isCurrents[i]);
                        }
                        experience.setCurrent(isCurrent);
                        
                        if (!isCurrent && endDates != null && i < endDates.length && !endDates[i].trim().isEmpty()) {
                            try {
                                experience.setEndDate(java.sql.Date.valueOf(endDates[i]));
                            } catch (IllegalArgumentException e) {
                                System.out.println("DEBUG: Invalid end date format: " + endDates[i]);
                            }
                        }
                        
                        // Set description
                        if (descriptions != null && i < descriptions.length) {
                            experience.setDescription(descriptions[i]);
                        }
                        
                        // Set achievements
                        if (achievements != null && i < achievements.length) {
                            experience.setAchievements(achievements[i]);
                        }
                        
                        experiences.add(experience);
                    }
                }
            }
            
            // Nếu không có experience, tạo default experience
            if (experiences.isEmpty()) {
                entity.TutorExperience defaultExperience = new entity.TutorExperience();
                defaultExperience.setTutorID(tutorId);
                defaultExperience.setJobTitle("Tutor/Teacher");
                defaultExperience.setCompany("Private Tutoring");
                defaultExperience.setStartDate(new java.sql.Date(System.currentTimeMillis()));
                defaultExperience.setCurrent(true);
                defaultExperience.setDescription("Teaching and tutoring experience");
                experiences.add(defaultExperience);
                System.out.println("DEBUG: Created default teaching experience for TutorID " + tutorId);
            }
            
            boolean result = daoTutorExperience.addTutorExperiences(tutorId, experiences);
            System.out.println("DEBUG: Created " + experiences.size() + " experiences for TutorID " + tutorId + ", Result: " + result);
            return result;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating tutor experiences", e);
            return false;
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet for user registration";
    }
}

