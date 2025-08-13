package model;

import entity.Subject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOSubject extends DBConnect {

    public int addSubject(Subject subject) throws SQLException {
        int result = 0;
        // Sửa đổi: Thêm cột Status vào câu lệnh INSERT
        String sql = "INSERT INTO Subject (SubjectName, Description, Status) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subject.getSubjectName());
            ps.setString(2, subject.getDescription());
            // Sửa đổi: Sử dụng getStatus() để lấy giá trị status, mặc định là "Active" nếu null
            ps.setString(3, subject.getStatus() != null ? subject.getStatus() : "Active");
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int updateSubject(Subject subject) throws SQLException {
        int result = 0;
        // Sửa đổi: Thêm cột Status vào câu lệnh UPDATE
        String sql = "UPDATE Subject SET SubjectName = ?, Description = ?, Status = ? WHERE SubjectID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subject.getSubjectName());
            ps.setString(2, subject.getDescription());
            // Sửa đổi: Sử dụng getStatus() để lấy giá trị status, mặc định là "Active" nếu null
            ps.setString(3, subject.getStatus() != null ? subject.getStatus() : "Active");
            ps.setInt(4, subject.getSubjectID());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Subject> getAllSubjects() {
        List<Subject> subjects = new ArrayList<>();
        // Sửa đổi: Thêm cột Status vào câu lệnh SELECT
        String sql = "SELECT SubjectID, SubjectName, Description, Status FROM Subject";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                // Sửa đổi: Sử dụng constructor mới có status
                subjects.add(new Subject(
                        rs.getInt("SubjectID"),
                        rs.getString("SubjectName"),
                        rs.getString("Description"),
                        rs.getString("Status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    public Subject getSubjectById(int subjectID) throws SQLException {
        // Sửa đổi: Thêm cột Status vào câu lệnh SELECT
        String sql = "SELECT SubjectID, SubjectName, Description, Status FROM Subject WHERE SubjectID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Sửa đổi: Sử dụng constructor mới có status
                return new Subject(
                        rs.getInt("SubjectID"),
                        rs.getString("SubjectName"),
                        rs.getString("Description"),
                        rs.getString("Status")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Phương thức để lấy tất cả Tutor-Subject với UserName chỉ khi TutorSubject.Approved = true
public List<Subject> getAllTutorSubjects() throws SQLException {
    List<Subject> subjectList = new ArrayList<>();
    String sql = """
            SELECT TutorID, UserName, TutorSubject.SubjectID, Desciption 
            FROM dbo.Users 
            JOIN dbo.CV ON CV.UserID = Users.UserID
            JOIN dbo.TutorSubject ON TutorSubject.SubjectID = CV.SubjectId
            WHERE status = 'Approved'"""; // Assuming 'Approved' is a boolean or integer (1 for true)

    try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
            int tutorID = rs.getInt("TutorID");
            String userName = rs.getString("UserName");
            int subjectID = rs.getInt("SubjectID");
            String description = rs.getString("Desciption");
            // Sử dụng constructor được comment "Constructor cho getAllTutorSubjects"
            subjectList.add(new Subject(subjectID, description, tutorID, userName));
        }
    }
    return subjectList;
}
    
    public List<Subject> getTutorSubjects(int id) throws SQLException {
        List<Subject> subjectList = new ArrayList<>();
        String sql = """
                     SELECT CV.SubjectId, SubjectName, Tutor.TutorID 
                     FROM dbo.Subject 
                     JOIN dbo.CV ON CV.SubjectId = Subject.SubjectID
                     JOIN dbo.Tutor ON Tutor.CVID = CV.CVID
                     JOIN dbo.Users ON Users.UserID = CV.UserID
                     WHERE CV.UserID = ?
                     """;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id); // Truyền giá trị id vào tham số ?
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int tutorID = rs.getInt("TutorID");
                    int subjectID = rs.getInt("SubjectId");
                    String subjectName = rs.getString("SubjectName");
                    subjectList.add(new Subject(subjectID, subjectName, tutorID));
                }
            }
        }
        return subjectList;
    }

    // dang su dung: Hungnv tai homepage
    // join: Subject, booking
    public List<Subject> getTopSubjectsByBooking(int limit) {
        List<Subject> subjects = new ArrayList<>();
        // Sửa đổi: Thêm cột Status vào câu lệnh SELECT và lọc chỉ lấy Subject có Status = 'Active'
        String sql = """
                     SELECT TOP (?) s.SubjectID, s.SubjectName, s.Description, s.Status, COUNT(b.SubjectID) AS BookingCount
                     FROM Subject s
                     JOIN Booking b ON s.SubjectID = b.SubjectID
                     WHERE b.Status IN ('Confirmed', 'Completed', 'Pending') AND s.Status = 'Active'
                     GROUP BY s.SubjectID, s.SubjectName, s.Description, s.Status
                     ORDER BY BookingCount DESC
                     """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Sửa đổi: Sử dụng constructor mới có status
                Subject subject = new Subject(
                        rs.getInt("SubjectID"),
                        rs.getString("SubjectName"),
                        rs.getString("Description"),
                        rs.getString("Status")
                );
                subject.setBookingCount(rs.getInt("BookingCount"));
                subjects.add(subject);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy các Subject.");
            e.printStackTrace();
        }
        return subjects;
    }

    public static void main(String[] args) {
        DAOSubject dao = new DAOSubject(); // Tạo instance của DAOSubject

        try {
            // Demo addSubject (Insert)
            System.out.println("=== Demo addSubject ===");
            // Sửa đổi: Sử dụng constructor mới có status
            Subject newSubject = new Subject(0, "ko", "hiểu", "Active");
            int insertResult = dao.addSubject(newSubject);
            System.out.println("Insert result: " + insertResult + " rows affected.");

        } catch (SQLException e) {
            System.out.println("Lỗi khi thực hiện các thao tác!");
            e.printStackTrace();
        }
    }
}