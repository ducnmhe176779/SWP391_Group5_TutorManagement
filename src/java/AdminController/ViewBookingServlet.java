package AdminController;

import entity.User;
import model.DAOBooking;
import entity.Booking;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ViewBookingServlet", urlPatterns = {"/admin/ViewBooking"})
public class ViewBookingServlet extends HttpServlet {

    private static final String VIEW_BOOKING_PAGE = "/admin/ViewBooking.jsp";
    private static final String LOGIN_PAGE = "/login.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_PAGE);
            return;
        }

        DAOBooking daoBooking = new DAOBooking();
        List<Booking> bookingList = daoBooking.getAllBookings();
        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher(VIEW_BOOKING_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_PAGE);
            return;
        }

        String action = request.getParameter("action");
        if ("refund".equals(action)) {
            try {
                int bookingID = Integer.parseInt(request.getParameter("bookingID"));
                DAOBooking daoBooking = new DAOBooking();
                int result = daoBooking.changeBookingStatusToRefund(bookingID);

                if (result > 0) {
                    session.setAttribute("message", "Booking ID " + bookingID + " has been updated to Cancelled successfully.");
                } else {
                    request.setAttribute("error", "Failed to update Booking ID " + bookingID + " to Cancelled. Booking may not exist or already cancelled.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid Booking ID format.");
            }
        }

        doGet(request, response); // Tải lại trang
    }
}