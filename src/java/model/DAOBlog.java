package model;

import entity.Blog;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOBlog extends DBConnect {

    // Thêm Blog mới
    public int insertBlog(Blog blog) throws SQLException {
        int n = 0;
        String sql = "INSERT INTO Blog (staffID, authorName, thumbnail, title, content, createdAt, summary) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, blog.getStaffID());
            pre.setString(2, blog.getAuthorName());
            pre.setString(3, blog.getThumbnail());
            pre.setString(4, blog.getTitle());
            pre.setString(5, blog.getContent());
            pre.setTimestamp(6, new Timestamp(blog.getCreatedAt().getTime()));
            pre.setString(7, blog.getSummary());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    public int getStaffIDByUsername(String username) {
        int staffID = -1; // Giá trị mặc định nếu không tìm thấy
        String sql = """
                     SELECT StaffID FROM dbo.Staff JOIN dbo.Users
                     ON Users.UserID = Staff.UserID
                     WHERE FullName LIKE ?"""; // Truy vấn SQL

        try {
            // Giả sử conn đã được khởi tạo ở đâu đó (ví dụ: DAO hoặc Connection Pool)
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, username); // Gán username vào truy vấn
            ResultSet rs = pre.executeQuery();

            if (rs.next()) {
                staffID = rs.getInt("staffID"); // Lấy staffID từ kết quả
            }
        } catch (SQLException ex) {
            ex.printStackTrace(); // Xử lý lỗi nếu có
        }
        return staffID;
    }

    // Lấy Blog theo ID
    public Blog getBlogById(int blogID) throws SQLException {
        Blog blog = null;
        String sql = "SELECT * FROM Blog WHERE blogID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, blogID);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                blog = extractBlogFromResultSet(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
        }
        return blog;
    }

    public List<Blog> getRecentBlogs(int limit) throws SQLException {
        List<Blog> recentBlogs = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " * FROM Blog ORDER BY createdAt DESC";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Blog blog = extractBlogFromResultSet(rs);
                    recentBlogs.add(blog);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
        }
        return recentBlogs;
    }

    // Lấy 6 blog gần nhất với đầy đủ thông tin (bao gồm thumbnail)
    public List<Blog> getRecentThumbnails(int limit) throws SQLException {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " blogID, title, thumbnail, createdAt "
                + "FROM Blog "
                + "WHERE thumbnail IS NOT NULL AND thumbnail != '' "
                + "ORDER BY createdAt DESC";
        try (PreparedStatement pre = conn.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogID(rs.getInt("blogID"));
                blog.setTitle(rs.getString("title"));
                blog.setThumbnail(rs.getString("thumbnail"));
                blog.setCreatedAt(rs.getTimestamp("createdAt")); // Giả sử createdAt là Timestamp
                blogs.add(blog);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, "Error fetching recent thumbnails", ex);
            throw ex; // Ném lại exception để servlet xử lý
        }
        return blogs;
    }

    // Lấy danh sách tất cả Blog
    public List<Blog> getAllBlogs() throws SQLException {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blog";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                Blog blog = extractBlogFromResultSet(rs);
                list.add(blog);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<Blog> searchBlogs(String keyword) throws SQLException {
        List<Blog> searchResults = new ArrayList<>();
        String sql = "SELECT * FROM Blog WHERE title LIKE ? OR content LIKE ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, "%" + keyword + "%"); // Tìm kiếm trong title
            pre.setString(2, "%" + keyword + "%"); // Tìm kiếm trong content
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    searchResults.add(extractBlogFromResultSet(rs));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
        }
        return searchResults;
    }

    // Cập nhật Blog
   public int updateBlog(Blog blog) {
    int n = 0;
    String sql = "UPDATE Blog SET staffID = ?, authorName = ?, thumbnail = ?, title = ?, content = ?, createdAt = ?, summary = ? WHERE blogID = ?";
    try {
        PreparedStatement pre = conn.prepareStatement(sql);
        pre.setInt(1, blog.getStaffID());
        pre.setString(2, blog.getAuthorName());
        pre.setString(3, blog.getThumbnail());
        pre.setString(4, blog.getTitle());
        pre.setString(5, blog.getContent());
        pre.setTimestamp(6, new Timestamp(blog.getCreatedAt().getTime()));
        pre.setString(7, blog.getSummary());
        pre.setInt(8, blog.getBlogID());

        // In câu lệnh và tham số để debug
        System.out.println("SQL: " + sql);
        System.out.println("Parameters: " + blog.getStaffID() + ", " + blog.getAuthorName() + ", " + 
                          blog.getThumbnail() + ", " + blog.getTitle() + ", " + blog.getContent() + ", " + 
                          blog.getCreatedAt() + ", " + blog.getSummary() + ", " + blog.getBlogID());

        n = pre.executeUpdate();
    } catch (SQLException ex) {
        Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
    }
    return n;
}
    

    // Xóa Blog theo ID
    public int deleteBlog(int blogID) throws SQLException{
        int n = 0;
        String sql = "DELETE FROM Blog WHERE blogID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, blogID);
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }
  // Lấy danh sách blog theo trang
  public List<Blog> getBlogsByPage(int page, int pageSize) throws SQLException {
    List<Blog> blogList = new ArrayList<>();
    int offset = (page - 1) * pageSize; // Tính vị trí bắt đầu

    String sql = "SELECT * FROM Blog ORDER BY createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, offset);   // Vị trí bắt đầu
        stmt.setInt(2, pageSize); // Số bản ghi mỗi trang
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Blog blog = new Blog(
                rs.getInt("blogID"),
                rs.getInt("staffID"),
                rs.getString("authorName"),
                rs.getString("thumbnail"),
                rs.getString("title"),
                rs.getString("content"),
                rs.getTimestamp("createdAt"),
                rs.getString("summary")
            );
            blogList.add(blog);
        }
    }
    return blogList;
}

    // Lấy tổng số blog để tính số trang
    public int getTotalBlogs() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Blog";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // Phương thức trích xuất dữ liệu Blog từ ResultSet
    private Blog extractBlogFromResultSet(ResultSet rs) throws SQLException {
        int blogID = rs.getInt("blogID");
        int staffID = rs.getInt("staffID");
        String authorName = rs.getString("authorName");
        String thumbnail = rs.getString("thumbnail");
        String title = rs.getString("title");
        String content = rs.getString("content");
        java.util.Date createdAt = new java.util.Date(rs.getTimestamp("createdAt").getTime());
        String summary = rs.getString("summary");
        return new Blog(blogID, staffID, authorName, thumbnail, title, content, createdAt, summary);
    }

    // Test method
    public static void main(String[] args) {
        DAOBlog dao = new DAOBlog();
        //  Test insertBlog

        Blog newBlog = new Blog(1, 47, "julianNg", "https://t3.ftcdn.net/jpg/09/38/20/44/360_F_938204480_5BZPwZ4dL5iujr2XZwzkxdFeQJoRDsRE.jpg",
                "New Blog Post", "blog post content",
                new java.util.Date(), "Short summary here");
        int inserted = 0;
        try {
            inserted = dao.insertBlog(newBlog);
        } catch (SQLException ex) {
            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.out.println("Insert result: " + inserted);
        // Test getAllBlogs
        //        List<Blog> blogs = null;
        //        try {
        //            blogs = dao.getAllBlogs();
        //        } catch (SQLException ex) {
        //            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
        //        }
        //        for (Blog blog : blogs) {
        //            System.out.println(blog.getBlogID() + " - " + blog.getThumbnail() + " - " + blog.getContent());
        //        }
//        int alo = dao.getStaffIDByUsername("aed");
//        System.out.println(alo);
        //Test recentBlogs
//        List<Blog> recentBlogs = null;
//        try {
//            recentBlogs = dao.getRecentThumbnails(3);
//        } catch (SQLException ex) {
//            Logger.getLogger(DAOBlog.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        for (Blog blog : recentBlogs) {
//            System.out.println(blog.getThumbnail());
//        }
        //Test update
//        Blog blog = new Blog(
//            1,                          // blogID
//            1,                       // staffID
//            "Nguyen Van A",           // authorName
//            "thumbnail.jpg",          // thumbnail
//            "New Blog Title",         // title
//            "Updated blog content...", // content
//            new java.util.Date(),               // createdAt (ngày hiện tại)
//            "This is a summary"       // summary
//        );
//
//        // Tạo đối tượng DAOBlog
//
//        // Gọi hàm updateBlog và kiểm tra kết quả
//        int result = dao.updateBlog(blog);
//
//        if (result > 0) {
//            System.out.println("Cập nhật blog thành công! Số hàng bị ảnh hưởng: " + result);
//        } else {
//            System.out.println("Cập nhật blog thất bại!");
//        }
    }
    }


