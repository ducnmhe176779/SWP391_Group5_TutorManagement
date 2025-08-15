package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    private static final boolean debug = true;

    // Danh sách các URL yêu cầu đăng nhập (protected)
    private static final List<String> PROTECTED_URLS = Arrays.asList(
            "/admin/",
            "/staff/",
            "/tutor/",
            "/user/",
            "/Booking",
            "/CreateSchedule",
            "/myschedule",
            "/cv",
            "/bookschedule",
            "/StudentPaymentHistory"
    );

    // Danh sách các URL public không cần đăng nhập
    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/login.jsp", // sử dụng login.jsp (đồng nhất với redirect)
            "/home.jsp",
            "/home",
            "/forget-password.jsp",
            "/blog-classic-sidebar.jsp",
            "/blog-details.jsp",
            "/register.jsp",
            "/tutor.jsp",
            "/error-404.jsp"
    );

    private FilterConfig filterConfig = null;

    public AuthenticationFilter() {
    }

    /**
     * Xử lý trước khi request được chuyển qua filter chain.
     */
    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AuthFilter: doBeforeProcessing");
        }
        // Bạn có thể thêm code xử lý trước tại đây (ví dụ: log tham số request)
    }

    /**
     * Xử lý sau khi request được chuyển qua filter chain.
     */
    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AuthFilter: doAfterProcessing");
        }
        // Bạn có thể thêm code xử lý sau tại đây (ví dụ: log các attribute response)
    }

    /**
     * Hàm doFilter chính của filter, thực hiện: 1. Gọi doBeforeProcessing. 2.
     * Thêm header chống cache. 3. Kiểm tra URL request, nếu thuộc vùng cần bảo
     * vệ mà người dùng chưa đăng nhập thì redirect về login. 4. Gọi
     * chain.doFilter nếu không có vấn đề. 5. Gọi doAfterProcessing.
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (debug) {
            log("AuthFilter: doFilter()");
        }

        doBeforeProcessing(request, response);

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Thêm header chống cache
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        if (isPublic(path)) {
            chain.doFilter(request, response);
            doAfterProcessing(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        if (isProtected(path)) {
            if (session == null || session.getAttribute("user") == null) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
                return;
            }
        }

        chain.doFilter(request, response);
        doAfterProcessing(request, response);
    }

    // Kiểm tra URL có thuộc danh sách protected không
    private boolean isProtected(String path) {
        return PROTECTED_URLS.stream().anyMatch(url -> path.equals(url) || path.startsWith(url));
    }

    // Kiểm tra URL có thuộc danh sách public không
    private boolean isPublic(String path) {
        return PUBLIC_URLS.stream().anyMatch(url -> path.equals(url) || path.startsWith(url));
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
        if (filterConfig != null && debug) {
            log("AuthFilter: Initializing filter");
        }
    }

    @Override
    public void destroy() {
        // Thực hiện dọn dẹp nếu cần
    }

    /**
     * Hỗ trợ gửi lỗi xử lý về client.
     */
    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);
        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);
                pw.print("<html><head><title>Error</title></head><body>");
                pw.print("<h1>The resource did not process correctly</h1><pre>");
                pw.print(stackTrace);
                pw.print("</pre></body></html>");
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
                // Không làm gì nếu có lỗi trong quá trình gửi lỗi
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
                // Không làm gì nếu có lỗi
            }
        }
    }

    /**
     * Trả về chuỗi chứa stack trace của Throwable.
     */
    private String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
            // Không làm gì nếu có lỗi
        }
        return stackTrace;
    }

    /**
     * Ghi log thông qua context của servlet.
     */
    private void log(String msg) {
        if (filterConfig != null) {
            filterConfig.getServletContext().log(msg);
        } else {
            System.out.println(msg);
        }
    }
}
