package AdminController;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Locale;

@WebServlet(name = "LanguageServlet", urlPatterns = {"/LanguageServlet"})
public class LanguageServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        String lang = request.getParameter("lang");
        String referer = request.getHeader("Referer"); // Lấy URL trang trước đó

        // Thiết lập Locale dựa trên lựa chọn ngôn ngữ
        if (lang != null) {
            switch (lang) {
                case "vi":
                    session.setAttribute("locale", new Locale("vi"));
                    break;
                case "en":
                default:
                    session.setAttribute("locale", new Locale("en"));
                    break;
            }
        }

        // Chuyển hướng về trang trước đó
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("home"); // Mặc định về trang chủ nếu không có referer
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
        return "Servlet to handle language change";
    }
}