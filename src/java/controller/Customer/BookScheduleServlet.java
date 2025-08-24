package controller.Customer;

import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.DAOSubject;
import model.DAOTutor;
import model.DAOSchedule;
import model.DAOSlot;
import entity.Subject;
import entity.Tutor;
import entity.Schedule;
import entity.Slot;
import jakarta.servlet.annotation.WebServlet;
import java.util.List;

@WebServlet(name = "BookScheduleServlet", urlPatterns = {"/bookschedule"})
public class BookScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOTutor daoTutor = new DAOTutor();
        DAOSubject daoSubject = new DAOSubject();
        DAOSlot daoSlot = new DAOSlot();

        List<Subject> subjectList = daoSubject.getAllSubjects();
        List<Slot> slotList = daoSlot.getAllSlots();
        request.setAttribute("subjectList", subjectList);
        request.setAttribute("slotList", slotList);

        String subjectIdParam = request.getParameter("subjectId");
        String tutorIdParam = request.getParameter("tutorId");

        List<Tutor> tutorList;
        Tutor selectedTutor = null;

        if (subjectIdParam == null || subjectIdParam.isEmpty()) {
            tutorList = daoTutor.getTopTutors(5);
        } else {
            int subjectId = Integer.parseInt(subjectIdParam);
            tutorList = daoTutor.getAllTutorsBySubject(subjectId);
        }

        if (tutorIdParam != null && !tutorIdParam.isEmpty()) {
            int subjectId = Integer.parseInt(subjectIdParam);
            int tutorId = Integer.parseInt(tutorIdParam);
            selectedTutor = daoTutor.getTutorBySubject(tutorId, subjectId);

            DAOSchedule daoSchedule = new DAOSchedule();
            List<Schedule> scheduleList = daoSchedule.getSchedulesByTutorAndSubject(tutorId, subjectId);
            request.setAttribute("scheduleList", scheduleList);
        }
        request.setAttribute("selectedTutor", selectedTutor);
        request.setAttribute("tutorList", tutorList);
        String error = request.getParameter("error");
        String success = request.getParameter("success");
        if (error != null) {
            request.setAttribute("error", error);
        }
        if (success != null) {
            request.setAttribute("success", success);
        }

        request.getRequestDispatcher("user/bookschedule.jsp").forward(request, response);
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}