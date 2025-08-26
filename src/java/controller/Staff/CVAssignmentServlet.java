package controller.Staff;

import entity.CVAssignment;
import entity.User;
import model.DAOCVAssignment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling CV assignments for staff review and admin oversight
 */
@WebServlet(name = "CVAssignmentServlet", urlPatterns = {"/staff/cv-assignments", "/admin/cv-assignments"})
public class CVAssignmentServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CVAssignmentServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check authentication
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String requestURI = request.getRequestURI();
        
        try {
            DAOCVAssignment daoCVAssignment = new DAOCVAssignment();
            
            if (requestURI.contains("/admin/")) {
                // Admin view - see all CV assignments
                handleAdminView(request, response, daoCVAssignment, action);
            } else if (requestURI.contains("/staff/")) {
                // Staff view - see only assigned CVs
                handleStaffView(request, response, daoCVAssignment, currentUser, action);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in CVAssignmentServlet", e);
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle admin view - see all CV assignments
     */
    private void handleAdminView(HttpServletRequest request, HttpServletResponse response,
                                DAOCVAssignment daoCVAssignment, String action) 
                                throws ServletException, IOException {
        
        if ("viewDetails".equals(action)) {
            // View specific CV assignment details
            String cvIdStr = request.getParameter("cvId");
            if (cvIdStr != null) {
                try {
                    int cvId = Integer.parseInt(cvIdStr);
                    CVAssignment assignment = daoCVAssignment.getAssignmentByCVID(cvId);
                    request.setAttribute("assignment", assignment);
                    request.getRequestDispatcher("/admin/cv-assignment-details.jsp").forward(request, response);
                    return;
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid CV ID");
                }
            }
        }
        
        // Default: show all CV assignments
        List<CVAssignment> allAssignments = daoCVAssignment.getAllCVAssignments();
        request.setAttribute("assignments", allAssignments);
        request.setAttribute("totalCVs", allAssignments.size());
        
        // Count by status
        long pendingCount = allAssignments.stream()
                .filter(a -> "Pending".equals(a.getStatus()))
                .count();
        long underReviewCount = allAssignments.stream()
                .filter(a -> "Under Review".equals(a.getStatus()))
                .count();
        long approvedCount = allAssignments.stream()
                .filter(a -> "Approved".equals(a.getStatus()))
                .count();
        long rejectedCount = allAssignments.stream()
                .filter(a -> "Rejected".equals(a.getStatus()))
                .count();
        
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("underReviewCount", underReviewCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        
        request.getRequestDispatcher("/admin/cv-assignments.jsp").forward(request, response);
    }
    
    /**
     * Handle staff view - see only assigned CVs
     */
    private void handleStaffView(HttpServletRequest request, HttpServletResponse response,
                                DAOCVAssignment daoCVAssignment, User currentUser, String action) 
                                throws ServletException, IOException {
        
        int staffId = currentUser.getUserID();
        
        if ("review".equals(action)) {
            // Start reviewing a CV
            String assignmentIdStr = request.getParameter("assignmentId");
            if (assignmentIdStr != null) {
                try {
                    int assignmentId = Integer.parseInt(assignmentIdStr);
                    // Update status to "Under Review"
                    boolean updated = daoCVAssignment.updateCVStatus(assignmentId, "Under Review", "Started review process");
                    if (updated) {
                        request.setAttribute("success", "CV review started successfully");
                    } else {
                        request.setAttribute("error", "Failed to start CV review");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid assignment ID");
                }
            }
        } else if ("approve".equals(action)) {
            // Approve a CV
            String assignmentIdStr = request.getParameter("assignmentId");
            String reviewNotes = request.getParameter("reviewNotes");
            if (assignmentIdStr != null) {
                try {
                    int assignmentId = Integer.parseInt(assignmentIdStr);
                    boolean updated = daoCVAssignment.updateCVStatus(assignmentId, "Approved", 
                                                                   reviewNotes != null ? reviewNotes : "CV approved by staff");
                    if (updated) {
                        request.setAttribute("success", "CV approved successfully");
                    } else {
                        request.setAttribute("error", "Failed to approve CV");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid assignment ID");
                }
            }
        } else if ("reject".equals(action)) {
            // Reject a CV
            String assignmentIdStr = request.getParameter("assignmentId");
            String reviewNotes = request.getParameter("reviewNotes");
            if (assignmentIdStr != null) {
                try {
                    int assignmentId = Integer.parseInt(assignmentIdStr);
                    boolean updated = daoCVAssignment.updateCVStatus(assignmentId, "Rejected", 
                                                                   reviewNotes != null ? reviewNotes : "CV rejected by staff");
                    if (updated) {
                        request.setAttribute("success", "CV rejected");
                    } else {
                        request.setAttribute("error", "Failed to reject CV");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid assignment ID");
                }
            }
        }
        
        // Get assigned CVs for this staff
        List<CVAssignment> assignedCVs = daoCVAssignment.getAssignedCVsForStaff(staffId);
        request.setAttribute("assignedCVs", assignedCVs);
        request.setAttribute("totalAssigned", assignedCVs.size());
        
        // Count by status
        long pendingCount = assignedCVs.stream()
                .filter(a -> "Pending".equals(a.getStatus()))
                .count();
        long underReviewCount = assignedCVs.stream()
                .filter(a -> "Under Review".equals(a.getStatus()))
                .count();
        long completedCount = assignedCVs.stream()
                .filter(a -> "Approved".equals(a.getStatus()) || "Rejected".equals(a.getStatus()))
                .count();
        
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("underReviewCount", underReviewCount);
        request.setAttribute("completedCount", completedCount);
        
        request.getRequestDispatcher("/staff/cv-assignments.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle form submissions for CV review actions
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet for handling CV assignments and reviews";
    }
}
