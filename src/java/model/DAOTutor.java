package model;

import entity.Cv;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import entity.Tutor;
import entity.User;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOTutor extends DBConnect {

    public int addTutor(Tutor tutor) {
        int result = 0;
        DAOCv dao= new DAOCv();
        String sql = "INSERT INTO [dbo].[Tutor]([CVID],[Rating],[Price])\n"
                + "VALUES(?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutor.getCVID());
            ps.setFloat(2, tutor.getRating());
            ps.setFloat(3, tutor.getPrice());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int updateTutor(Tutor tutor) {
        int result = 0;
        String sql = "UPDATE Tutor SET CVID = ?, rating = ? WHERE tutorID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutor.getCVID());
            ps.setFloat(2, tutor.getRating());
            ps.setInt(3, tutor.getTutorID());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * Cập nhật giá giờ học của tutor
     */
    public boolean updateTutorPrice(int tutorId, float newPrice) {
        String sql = "UPDATE Tutor SET Price = ? WHERE TutorID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setFloat(1, newPrice);
            ps.setInt(2, tutorId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi cập nhật giá tutor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Lấy TutorID từ UserID (cho tutor đang login)
     */
    public int getTutorIdByUserId(int userId) {
        String sql = """
            SELECT t.TutorID 
            FROM Users u
            JOIN CV c ON u.UserID = c.UserID
            JOIN Tutor t ON c.CVID = t.CVID
            WHERE u.UserID = ?
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("TutorID");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy TutorID từ UserID: " + e.getMessage());
            e.printStackTrace();
        }
        return -1; // Không tìm thấy
    }

    public int deleteTutor(int tutorID) {
        int result = 0;
        String sql = "DELETE FROM Tutor WHERE tutorID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // dang su dung: Homepage - lay 5 tutors trong danh sach
    // join: Tutor, CV, User
    public List<Tutor> getTopTutors(int limit) {
        List<Tutor> tutors = new ArrayList<>();
        String sql
                = "SELECT TOP (" + limit + ") t.TutorID, t.Rating,t.Price, "
                + "c.CVID, c.Desciption, "
                + "u.UserID, u.Email, u.FullName, u.Phone, u.Avatar "
                + "FROM Tutor t "
                + "JOIN CV c ON t.CVID = c.CVID "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "ORDER BY t.Rating DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
           DAOTutorRating dao= new DAOTutorRating();
            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setEmail(rs.getString("Email"));
                user.setFullName(rs.getString("FullName"));
                user.setPhone(rs.getString("Phone"));
                user.setAvatar(rs.getString("Avatar"));

                Cv cv = new Cv();
                cv.setCvId(rs.getInt("CVID"));
                cv.setDescription(rs.getString("Desciption"));
                cv.setUser(user);

                Tutor tutor = new Tutor();
                tutor.setTutorID(rs.getInt("TutorID"));
                tutor.setCVID(rs.getInt("CVID"));
                tutor.setRating(dao.getAvgRating(rs.getInt("TutorID")));
                tutor.setPrice(rs.getFloat("Price"));
                tutor.setCv(cv);

                tutors.add(tutor);
            }
        } catch (SQLException e) {
            System.out.println("lỗi khi lấy 5 tutors");
            e.printStackTrace();
        }
        return tutors;
    }

    public float getPriceByTutorId(int tutorId) {
        float price = -1; // Giá trị mặc định nếu không tìm thấy hoặc có lỗi
        String sql = """
           SELECT Tutor.Price
                        FROM dbo.Users 
                        JOIN dbo.CV ON CV.UserID = Users.UserID
                        JOIN dbo.Tutor ON Tutor.CVID = CV.CVID
                        WHERE TutorID = ?
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                price = rs.getFloat("Price");
                // Kiểm tra nếu Price là NULL trong cơ sở dữ liệu
                if (rs.wasNull()) {
                    price = 0; // Gán giá trị mặc định nếu Price là NULL
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy Price của Tutor theo TutorID: " + e.getMessage());
            e.printStackTrace();
        }
        return price;
    }

    public String getFullNameByTutorId(int tutorID) {
        String fullName = null;
        String sql = "SELECT u.FullName "
                + "FROM dbo.Users u "
                + "JOIN dbo.CV cv ON cv.UserID = u.UserID "
                + "JOIN dbo.Tutor t ON t.CVID = cv.CVID "
                + "WHERE t.TutorID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                fullName = rs.getString("FullName");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fullName;
    }

    public List<Tutor> getAllTutors() {
        List<Tutor> tutors = new ArrayList<>();
        String sql = """
        SELECT t.tutorID, t.CVID, t.rating, u.FullName, u.Email
        FROM Tutor t
        JOIN CV c ON t.CVID = c.CVID
        JOIN Users u ON c.UserID = u.UserID
    """;
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                User user = new User();
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));

                Cv cv = new Cv();
                cv.setUser(user);

                Tutor tutor = new Tutor();
                tutor.setTutorID(rs.getInt("tutorID"));
                tutor.setCVID(rs.getInt("CVID"));
                tutor.setRating(rs.getFloat("rating"));
                tutor.setCv(cv);
                tutors.add(tutor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tutors;
    }

    public Tutor getTutorById(int tutorID) {
        String sql = "SELECT * FROM Tutor WHERE tutorID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Tutor(
                        rs.getInt("tutorID"),
                        rs.getInt("CVID"),
                        rs.getFloat("rating")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Hungnv: su dung trong bookschedule
    public List<Tutor> getAllTutorsBySubject(int subjectID) {
        List<Tutor> tutors = new ArrayList<>();
        String sql = """
        SELECT t.tutorID, t.CVID, t.rating, u.FullName, u.Email
        FROM Tutor t
        JOIN TutorSubject ts ON t.TutorID = ts.TutorID
        JOIN CV c ON t.CVID = c.CVID
        JOIN Users u ON c.UserID = u.UserID
        WHERE ts.SubjectID = ?
    """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));

                Cv cv = new Cv();
                cv.setUser(user);

                Tutor tutor = new Tutor();
                tutor.setTutorID(rs.getInt("tutorID"));
                tutor.setCVID(rs.getInt("CVID"));
                tutor.setRating(rs.getFloat("rating"));
                tutor.setCv(cv);
                tutors.add(tutor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tutors;
    }

    public Tutor getTutorBySubject(int tutorID, int subjectID) {
        Tutor tutor = null;
        String sql = """
        SELECT t.tutorID, t.CVID, t.rating, t.Price,
               u.FullName, u.Email, u.Phone, u.Avatar, 
               c.Education, c.Experience, c.Certificates, c.Status, c.Desciption
        FROM Tutor t
        JOIN Cv c ON t.CVID = c.CVID
        JOIN Users u ON c.UserID = u.UserID
        JOIN Subject s ON c.SubjectId = s.SubjectID
        WHERE t.TutorID = ? AND s.SubjectID = ?
    """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            ps.setInt(2, subjectID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setPhone(rs.getString("Phone"));
                user.setAvatar(rs.getString("Avatar"));

                Cv cv = new Cv();
                cv.setUser(user);
                cv.setEducation(rs.getString("Education"));
                cv.setExperience(rs.getString("Experience"));
                cv.setCertificates(rs.getString("Certificates"));
                cv.setStatus(rs.getString("Status"));
                cv.setDescription(rs.getString("Desciption"));

                tutor = new Tutor();
                tutor.setTutorID(rs.getInt("tutorID"));
                tutor.setCVID(rs.getInt("CVID"));
                tutor.setRating(rs.getFloat("rating"));
                float price = rs.getFloat("Price");
                if (rs.wasNull()) {
                    tutor.setPrice(0);
                } else {
                    tutor.setPrice(price);
                }
                tutor.setCv(cv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("lấy tutor by subject Id thành công");
        return tutor;
    }

    public Tutor getTutorByCVid(int cvId) {
        Tutor tutor = null;
        String query = "SELECT TutorID, CVID, Rating, Price FROM Tutor WHERE CVID = ?";

        // Sử dụng try-with-resources để tự động đóng kết nối và statement
        try (
                PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, cvId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    tutor = new Tutor();
                    tutor.setTutorID(rs.getInt("TutorID"));
                    tutor.setCVID(rs.getInt("CVID"));
                    int rating = rs.getInt("Rating");
                    if (rs.wasNull()) {
                        tutor.setRating(0);
                    } else {
                        tutor.setRating(rating);
                    }
                    float price = rs.getFloat("Price");
                    if (rs.wasNull()) {
                        tutor.setPrice(0);
                    } else {
                        tutor.setPrice(price);
                    }
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return tutor;
    }

    public boolean isCVExists(int cvid) {
        String sql = "SELECT COUNT(*) FROM Tutor WHERE CVID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cvid);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTutor.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }



    // Method mới: Lấy danh sách tutors theo subject (trả về Object[] để dễ sử dụng trong JSP)
    public List<Object[]> getTutorsBySubject(int subjectID) {
        List<Object[]> tutors = new ArrayList<>();
        String sql = """
        SELECT t.TutorID, u.FullName
        FROM Tutor t
        JOIN CV c ON t.CVID = c.CVID
        JOIN Users u ON c.UserID = u.UserID
        WHERE c.SubjectId = ?
        ORDER BY u.FullName
    """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Object[] tutorData = new Object[2];
                tutorData[0] = rs.getInt("TutorID");
                tutorData[1] = rs.getString("FullName");
                tutors.add(tutorData);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tutors;
    }

    // Method mới: Lấy thông tin chi tiết tutor theo ID
    public Object[] getTutorDetailById(int tutorID) {
        String sql = """
        SELECT t.TutorID, u.FullName, u.Avatar, c.Education, c.Experience, c.Certificates, u.Email, u.Phone, t.Rating
        FROM Tutor t
        JOIN CV c ON t.CVID = c.CVID
        JOIN Users u ON c.UserID = u.UserID
        WHERE t.TutorID = ?
    """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tutorID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Object[] tutorData = new Object[9];
                tutorData[0] = rs.getInt("TutorID");
                tutorData[1] = rs.getString("FullName");
                tutorData[2] = rs.getString("Avatar");
                tutorData[3] = rs.getString("Education");
                tutorData[4] = rs.getString("Experience");
                tutorData[5] = rs.getString("Certificates");
                tutorData[6] = rs.getString("Email");
                tutorData[7] = rs.getString("Phone");
                tutorData[8] = rs.getFloat("Rating");
                return tutorData;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
