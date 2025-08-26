package controller;

import entity.Subject;
import model.DAOSubject;
import model.DAOTutorSubject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for filtering tutors by subjects and other criteria
 * Supports advanced filtering for multiple subjects per tutor
 */
@WebServlet(name = "TutorFilterServlet", urlPatterns = {"/tutor-filter"})
public class TutorFilterServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(TutorFilterServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String action = request.getParameter("action");
            
            if ("getSubjects".equals(action)) {
                handleGetSubjects(request, response);
            } else if ("filterTutors".equals(action)) {
                handleFilterTutors(request, response);
            } else if ("getTutorsWithSubjects".equals(action)) {
                handleGetTutorsWithSubjects(request, response);
            } else {
                // Default: load all subjects and tutors
                loadDefaultData(request, response);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in TutorFilterServlet", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Get all subjects for filter dropdown
     */
    private void handleGetSubjects(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        DAOSubject daoSubject = new DAOSubject();
        List<Subject> subjects = daoSubject.getAllSubjects();
        
        request.setAttribute("subjects", subjects);
        request.getRequestDispatcher("/tutor-subjects.jsp").forward(request, response);
    }
    
    /**
     * Filter tutors by selected subjects
     */
    private void handleFilterTutors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String[] selectedSubjects = request.getParameterValues("subjects");
        String priceRange = request.getParameter("priceRange");
        String ratingMin = request.getParameter("ratingMin");
        
        DAOTutorSubject daoTutorSubject = new DAOTutorSubject();
        
        if (selectedSubjects != null && selectedSubjects.length > 0) {
            // Filter tutors by subjects
            java.util.Set<Integer> filteredTutorIds = new java.util.HashSet<>();
            
            for (String subjectIdStr : selectedSubjects) {
                try {
                    int subjectId = Integer.parseInt(subjectIdStr);
                    List<Integer> tutorIds = daoTutorSubject.getTutorIdsBySubjectId(subjectId);
                    filteredTutorIds.addAll(tutorIds);
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid subject ID: " + subjectIdStr);
                }
            }
            
            request.setAttribute("filteredTutorIds", filteredTutorIds);
            request.setAttribute("selectedSubjects", selectedSubjects);
        }
        
        // Additional filters
        if (priceRange != null && !priceRange.isEmpty()) {
            request.setAttribute("priceRange", priceRange);
        }
        
        if (ratingMin != null && !ratingMin.isEmpty()) {
            try {
                float minRating = Float.parseFloat(ratingMin);
                request.setAttribute("ratingMin", minRating);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid rating: " + ratingMin);
            }
        }
        
        // Load all tutors with subjects for display
        List<Object[]> tutorsWithSubjects = daoTutorSubject.getTutorsWithSubjects();
        request.setAttribute("tutorsWithSubjects", tutorsWithSubjects);
        
        request.getRequestDispatcher("/tutor-filter-results.jsp").forward(request, response);
    }
    
    /**
     * Get all tutors with their subjects for advanced display
     */
    private void handleGetTutorsWithSubjects(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        DAOTutorSubject daoTutorSubject = new DAOTutorSubject();
        List<Object[]> tutorsWithSubjects = daoTutorSubject.getTutorsWithSubjects();
        
        request.setAttribute("tutorsWithSubjects", tutorsWithSubjects);
        request.getRequestDispatcher("/tutors-with-subjects.jsp").forward(request, response);
    }
    
    /**
     * Load default data for the filter page
     */
    private void loadDefaultData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        DAOSubject daoSubject = new DAOSubject();
        DAOTutorSubject daoTutorSubject = new DAOTutorSubject();
        
        // Load all subjects for filter
        List<Subject> subjects = daoSubject.getAllSubjects();
        request.setAttribute("subjects", subjects);
        
        // Load all tutors with subjects
        List<Object[]> tutorsWithSubjects = daoTutorSubject.getTutorsWithSubjects();
        request.setAttribute("tutorsWithSubjects", tutorsWithSubjects);
        
        request.getRequestDispatcher("/tutor-filter.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET for filter operations
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet for advanced tutor filtering by subjects and criteria";
    }
}
