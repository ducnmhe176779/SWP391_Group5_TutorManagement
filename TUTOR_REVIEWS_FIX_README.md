# Hướng dẫn khắc phục vấn đề hiển thị CV trong trang Tutor Reviews

## Vấn đề hiện tại
Trang `http://localhost:9999/SWP391_Group5_TutorManagement/staff/tutor-reviews` đang hiển thị thống kê nhưng không hiển thị danh sách CV cụ thể.

## Nguyên nhân
1. **Stored Procedure có lỗi**: `sp_GetAssignedCVsForStaff` có lỗi chính tả `cv.Desciption` thay vì `cv.Description`
2. **RoleID không khớp**: Stored procedure đang tìm `RoleID = 2` nhưng Staff thực tế có `RoleID = 4`
3. **Dữ liệu trống**: Bảng `CVAssignment` có thể chưa có dữ liệu
4. **Field mapping sai**: JSP đang sử dụng sai field names

## Cách khắc phục

### Bước 1: Chạy file SQL sửa lỗi
```sql
-- Chạy file fix_tutor_reviews_issues.sql trong SQL Server Management Studio
-- Hoặc copy nội dung và chạy trực tiếp
```

### Bước 2: Kiểm tra dữ liệu
```sql
-- Kiểm tra xem có Staff nào không
SELECT UserID, FullName, Email, RoleID, IsActive 
FROM Users 
WHERE RoleID = 4;

-- Kiểm tra xem có CV nào không
SELECT CVID, UserID, Status, SubjectId 
FROM CV;

-- Kiểm tra xem có CVAssignment nào không
SELECT * FROM CVAssignment;
```

### Bước 3: Tạo dữ liệu mẫu (nếu cần)
```sql
-- Tạo CV mẫu nếu chưa có
INSERT INTO CV (UserID, Education, Experience, Status, SubjectId, Skill, Price)
VALUES (1, 'Bachelor Degree', '2 years teaching', 'Pending', 1, 'Math, Physics', 200000);

-- Tạo CVAssignment mẫu
INSERT INTO CVAssignment (CVID, AssignedStaffID, AssignedDate, Status, Priority)
VALUES (1, [STAFF_USER_ID], GETDATE(), 'Pending', 2);
```

### Bước 4: Kiểm tra stored procedure
```sql
-- Test stored procedure
EXEC sp_GetAssignedCVsForStaff @StaffUserId = [YOUR_STAFF_ID];
```

## Các file đã được sửa

### 1. `fix_tutor_reviews_issues.sql`
- Sửa lỗi chính tả trong stored procedure
- Sửa RoleID từ 2 thành 4
- Tạo dữ liệu mẫu nếu cần

### 2. `web/staff/tutor-reviews.jsp`
- Sửa field mapping từ `cv.status` thành `cv.assignmentStatus`
- Thêm null check cho các field
- Sửa cách hiển thị status

### 3. `src/java/controller/Staff/CVReviewServlet.java`
- Tạo Servlet mới để xử lý việc review CV
- Xử lý POST request từ form review

## Kiểm tra sau khi sửa

1. **Đăng nhập với tài khoản Staff** (RoleID = 4)
2. **Truy cập trang tutor-reviews**
3. **Kiểm tra xem có hiển thị CV không**
4. **Test chức năng review CV**

## Troubleshooting

### Nếu vẫn không hiển thị CV:
1. Kiểm tra console browser có lỗi JavaScript không
2. Kiểm tra log server có lỗi gì không
3. Kiểm tra database có dữ liệu không
4. Kiểm tra stored procedure có chạy được không

### Nếu có lỗi database:
1. Kiểm tra connection string
2. Kiểm tra quyền truy cập database
3. Kiểm tra tên bảng và field có đúng không

## Liên hệ hỗ trợ
Nếu vẫn gặp vấn đề, hãy cung cấp:
1. Log lỗi từ console browser
2. Log lỗi từ server
3. Screenshot trang web
4. Kết quả chạy các câu SQL kiểm tra







