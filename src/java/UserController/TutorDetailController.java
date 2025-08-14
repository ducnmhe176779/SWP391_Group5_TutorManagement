package UserController;

import entity.TutorRating;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.DAOCv;
import model.DAOTutorRating;

@WebServlet(name = "TutorDetailController", urlPatterns = {"/Tutordetail"})
public class TutorDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            DAOTutorRating dao = new DAOTutorRating();
            int tutor = Integer.parseInt(request.getParameter("tutorID"));
            ResultSet rsTutor = null;
            rsTutor = dao.getData("select TutorID, FullName, SubjectName, rating, Avatar, Tutor.Price ,Desciption, Certificates,Subject.SubjectID,Skill from users\n"
                    + "                        join CV on users.UserID=Cv.UserID\n"
                    + "                        join tutor on CV.CVID=tutor.CVID\n"
                    + "                        join Subject on CV.SubjectId=Subject.SubjectID\n"
                    + "                    where TutorID=" + tutor);
            request.setAttribute("rsTutor", rsTutor);
            ResultSet rsReviews = dao.getData("SELECT StudentID, Rating, Comment, RatingDate "
                    + "FROM TutorRating "
                    + "WHERE TutorID = " + tutor + " "
                    + "ORDER BY RatingDate DESC");
            int[] ratingDistribution = new int[5]; // For 1 to 5 stars
            double totalRating = 0;
            int reviewCount = 0;
            ResultSet rsRatingDist = dao.getData("SELECT Rating FROM TutorRating WHERE TutorID = " + tutor);
            while (rsRatingDist.next()) {
                int rating = rsRatingDist.getInt("Rating");
                if (rating >= 1 && rating <= 5) {
                    ratingDistribution[rating - 1]++;
                    totalRating += rating;
                    reviewCount++;
                }
            }
            DAOCv dao1 = new DAOCv();
            List<Object[]> reviews = new ArrayList<>();
            while (rsReviews.next()) {
                int studentId = rsReviews.getInt("StudentID");
                int rating = rsReviews.getInt("Rating");
                String comment = rsReviews.getString("Comment");
                String ratingDate = rsReviews.getString("RatingDate");
                ResultSet rsStudent = dao.getData("SELECT FullName, Avatar FROM users WHERE UserID = " + studentId);
                String reviewerName = "";
                String reviewerAvatar = "";
                if (rsStudent.next()) {
                    reviewerName = rsStudent.getString("FullName");
                    reviewerAvatar = rsStudent.getString("Avatar");
                }
                boolean isLongReview = comment.length() > 100;
                String displayText = isLongReview ? comment.substring(0, 100) + "..." : comment;
                reviews.add(new Object[]{studentId, rating, comment, ratingDate, reviewerName, reviewerAvatar, isLongReview, displayText});
            }
            request.setAttribute("reviews", reviews);
            double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;
            request.setAttribute("ratingDistribution", ratingDistribution);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("reviewCount", reviewCount);

            request.getRequestDispatcher("/tutor-details.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
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
        return "Short description";
    }
}
