package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Set;
import entity.User;

@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    private static final boolean debug = true;

    // Đảm bảo các URL có cùng định dạng (bắt đầu bằng "/")
    private static final Set<String> ADMIN_URLS = Set.of(
            "/admin"
    );

    private static final Set<String> STAFF_URLS = Set.of(
            "/staff"
    );

    private static final Set<String> TUTOR_URLS = Set.of(
            "/tutor"
    );
    private static final Set<String> USER_URLS = Set.of(
            "/user","/Booking",
            "/myschedule",
            "/bookschedule"
    );

    private FilterConfig filterConfig = null;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (debug) {
            log("AuthorizationFilter:doFilter()");
        }

        doBeforeProcessing(request, response);

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        if (!isRestricted(path)) {
            chain.doFilter(request, response);
            return;
        }

        User user = (User) httpRequest.getSession(false).getAttribute("user");

        boolean hasAccess = switch (user != null ? user.getRoleID() : 0) {
            case 4 ->
                isAllowed(STAFF_URLS, path);
            case 3 ->
                isAllowed(TUTOR_URLS, path);
            case 2 ->
                isAllowed(USER_URLS, path);
            case 1 ->
                isAllowed(ADMIN_URLS, path);
            default ->
                false;
        };

        if (!hasAccess) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/error-403.jsp");
            return;
        }

        chain.doFilter(request, response);
        doAfterProcessing(request, response);
    }

    // Phương thức kiểm tra nếu path trùng khớp hoặc nằm trong phạm vi của 1 URL cho phép
    private boolean isAllowed(Set<String> allowedUrls, String path) {
        for (String allowed : allowedUrls) {
            if (path.equals(allowed) || path.startsWith(allowed + "/")) {
                return true;
            }
        }
        return false;
    }

    // Kiểm tra nếu path thuộc bất kỳ URL nào cần được bảo vệ
    private boolean isRestricted(String path) {
        return isAllowed(ADMIN_URLS, path) || isAllowed(STAFF_URLS, path)
                || isAllowed(TUTOR_URLS, path)||isAllowed(USER_URLS, path);
    }

    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AuthorizationFilter:DoBeforeProcessing");
        }
        // Thêm xử lý trước nếu cần
    }

    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AuthorizationFilter:DoAfterProcessing");
        }
        // Thêm xử lý sau nếu cần
    }

    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);
        if (stackTrace != null && !stackTrace.isEmpty()) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n");
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");
                pw.print(stackTrace);
                pw.print("</pre></body>\n</html>");
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
                // Xử lý ngoại lệ khi gửi lỗi
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
                // Xử lý ngoại lệ khi in stack trace
            }
        }
    }

    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
            // Xử lý ngoại lệ khi lấy stack trace
        }
        return stackTrace;
    }

    public void log(String msg) {
        filterConfig.getServletContext().log(msg);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
        if (filterConfig != null && debug) {
            log("AuthorizationFilter:Initializing filter");
        }
    }

    @Override
    public void destroy() {
        // Xử lý dọn dẹp nếu cần
    }
}
