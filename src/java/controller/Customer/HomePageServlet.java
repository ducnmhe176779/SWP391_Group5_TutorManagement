package controller.Customer;

import entity.Tutor;
import entity.Subject;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.DAOSubject;
import model.DAOTutor;
import model.DAOUser;

public class HomePageServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false); // Không tạo session mới nếu chưa có
        User user = null;

        // Lấy user từ session nếu có
        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        DAOUser daoUser = new DAOUser();
        DAOTutor daoTutor = new DAOTutor();
        DAOSubject daoSubject = new DAOSubject();

        // Nếu user không null và email bị thiếu, lấy lại từ database
        try {
            if (user != null && user.getEmail() == null) {
                if (user.getUserID() != 0) {
                    user = daoUser.getUserById(user.getUserID());
                    if (user != null && session != null) {
                        session.setAttribute("user", user); // Cập nhật lại session
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Lấy danh sách top tutors và subjects (không phụ thuộc user)
        List<Tutor> topTutors = daoTutor.getTopTutors(5);
        List<Subject> topSubjects = daoSubject.getTopSubjectsByBooking(5);

        // Gán các thuộc tính cho request
        request.setAttribute("user", user); // user có thể là null
        request.setAttribute("topTutors", topTutors);
        request.setAttribute("topSubjects", topSubjects);

        // Chuyển tiếp đến home.jsp (không cần đăng nhập)
        request.getRequestDispatcher("home.jsp").forward(request, response);
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
        return "Short description";
    }
}