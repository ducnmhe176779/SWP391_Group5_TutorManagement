package UserController;

import model.DAOUser;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(true);
        DAOUser dao = new DAOUser();

        String service = request.getParameter("service");

        if (service == null) {
            service = "loginUser";
        }

        switch (service) {
            case "loginUser":
                handleUserLogin(request, response, session, dao);
                break;

            default:
                request.setAttribute("error", "Dịch vụ đăng nhập không hợp lệ.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                break;
        }
    }

    private void handleUserLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session, DAOUser dao)
            throws ServletException, IOException {
        String submit = request.getParameter("submit");
        if (submit == null) {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            String loginInput = request.getParameter("loginInput");
            String password = request.getParameter("password");

            System.out.println("Login attempt: loginInput=" + loginInput + ", password=" + password); // Debug

            User user = dao.Login(loginInput, password); // Truyền mật khẩu thô, DAO sẽ mã hóa
            if (user == null) {
                System.out.println("Login failed: No user found or incorrect credentials");
                request.setAttribute("error", "Thông tin đăng nhập hoặc mật khẩu không chính xác");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else if (user.getIsActive() == 0) {
                System.out.println("Login failed: User is deactivated, UserID=" + user.getUserID());
                handleDeactivatedAccount(user, request, response);
            } else {
                System.out.println("Login successful: UserID=" + user.getUserID() + ", RoleID=" + user.getRoleID());
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserID());
                redirectBasedOnRole(user, request, response);
            }
        }
    }

    // Phương thức xử lý tài khoản bị deactivate
    private void handleDeactivatedAccount(User user, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (user.getRoleID() == 4) {
            request.setAttribute("error", "Tài khoản của bạn đã bị vô hiệu hóa. Liên hệ với quản lý để có thể kích hoạt lại tài khoản.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else if (user.getRoleID() == 2 || user.getRoleID() == 3) {
            request.setAttribute("error", "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email để kích hoạt tài khoản.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ hỗ trợ.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void redirectBasedOnRole(User user, HttpServletRequest request, HttpServletResponse response) throws IOException {
        int roleId = user.getRoleID();
        String contextPath = request.getContextPath();

        switch (roleId) {
            case 1:
                response.sendRedirect(contextPath + "/admin/index");
                break;
            case 2:
                response.sendRedirect(contextPath + "/home");
                break;
            case 3:
                response.sendRedirect(contextPath + "/tutor/indextutor.jsp");
                break;
            case 4:
                response.sendRedirect(contextPath + "/staff/dashboard");
                break;
            default:
                response.sendRedirect(contextPath + "/home.jsp");
                break;
        }
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
        return "Login Servlet";
    }
}
