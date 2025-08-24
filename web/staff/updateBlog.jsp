<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>G4 SmartTutor</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <!-- CKEditor CDN -->
        <script src="https://cdn.ckeditor.com/4.16.2/standard/ckeditor.js"></script>
    </head>
    <body>
        <div class="container">
            <h2 class="mb-4">Cập Nhật Blog</h2>
            <%-- Hiển thị thông báo lỗi nếu có --%>
            <%
                String error = (String) session.getAttribute("error");
                if (error != null) {
            %>
            <div class="alert alert-danger"><%= error%></div>
            <%
                    session.removeAttribute("error"); // Xóa sau khi hiển thị
                }
            %>
            <form action="${pageContext.request.contextPath}/staff/BlogController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="service" value="updateBlog">
                <input type="hidden" name="blogID" value="${blog.blogID}">
                <!-- Trường tiêu đề -->
                <div class="form-group">
                    <label for="title">Tiêu đề: </label>
                    <input type="text" class="form-control" id="title" name="title" value="${blog.title}" required>
                </div>
                <!-- Trường tóm tắt -->
                <div class="form-group">
                    <label for="summary">Tóm Tắt: </label>
                    <textarea class="form-control" id="summary" name="summary" rows="3" required>${blog.summary}</textarea>
                </div>
                <!-- Trường nội dung -->
                <div class="form-group">
                    <label for="content">Nội Dung: </label>
                    <textarea class="form-control" id="content" name="content" rows="8" required>${blog.content}</textarea>
                    <script>
                        CKEDITOR.replace('content', {
                            filebrowserUploadUrl: '${pageContext.request.contextPath}/staff/BlogController?service=uploadImage',
                            extraPlugins: 'uploadimage',
                            height: 300
                        });
                    </script>
                </div>
                <!-- Trường thumbnail hiện tại -->
                <div class="form-group">
                    <label>Thumbnail hiện tại:</label>
                    <div>
                        <img src="${pageContext.request.contextPath}/${blog.thumbnail}" alt="Current Thumbnail" style="max-width: 200px;" class="img-thumbnail">
                    </div>
                </div>
                <!-- Trường thumbnail mới (upload file) -->
                <div class="form-group">
                    <label for="thumbnail">Thumbnail mới (Image File - Leave empty to keep current):</label>
                    <input type="file" class="form-control" id="thumbnail" name="thumbnail" accept="image/*">
                </div>
                <!-- Nút submit -->
                <button type="submit" name="submit" value="update" class="btn btn-primary">Cập Nhật</button>
                <a href="${pageContext.request.contextPath}/staff/BlogController" class="btn btn-secondary">Quay Lại</a>
                <button type="button" class="btn btn-info" onclick="previewBlog()">Xem Trước</button>
            </form>
        </div>
        <!-- Modal Xem trước -->
        <div class="modal fade" id="previewModal" tabindex="-1" role="dialog" aria-labelledby="previewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="previewModalLabel">Blog Preview</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Tiêu đề -->
                        <h3 id="previewTitle" class="mb-3"></h3>
                        <!-- Tóm tắt -->
                        <p id="previewSummary" class="text-muted mb-3"></p>
                        <!-- Hình ảnh thumbnail -->
                        <div id="previewThumbnail" class="mb-3">
                            <img id="thumbnailImage" src="" alt="Thumbnail Preview" style="max-width: 100%; height: auto; display: none;">
                        </div>
                        <!-- Nội dung -->
                        <div id="previewContent"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function previewBlog() {
                // Lấy giá trị từ các trường
                const title = document.getElementById('title').value;
                const summary = document.getElementById('summary').value;
                const content = CKEDITOR.instances.content.getData(); // Lấy nội dung từ CKEditor
                const thumbnailInput = document.getElementById('thumbnail');
                const thumbnailImage = document.getElementById('thumbnailImage');

                // Hiển thị tiêu đề, tóm tắt và nội dung trong modal
                document.getElementById('previewTitle').innerText = title || 'No Title';
                document.getElementById('previewSummary').innerText = summary || 'No Summary';
                document.getElementById('previewContent').innerHTML = content || 'No Content';

                // Hiển thị hình ảnh thumbnail
                if (thumbnailInput.files && thumbnailInput.files[0]) {
                    // Nếu có hình ảnh mới được chọn, hiển thị hình ảnh mới
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        thumbnailImage.src = e.target.result;
                        thumbnailImage.style.display = 'block';
                    };
                    reader.readAsDataURL(thumbnailInput.files[0]);
                } else {
                    // Nếu không có hình ảnh mới, sử dụng hình ảnh hiện tại
                    const currentThumbnail = "${pageContext.request.contextPath}/${blog.thumbnail}";
                                if (currentThumbnail) {
                                    thumbnailImage.src = currentThumbnail;
                                    thumbnailImage.style.display = 'block';
                                } else {
                                    thumbnailImage.style.display = 'none';
                                }
                            }

                            // Hiển thị modal
                            $('#previewModal').modal('show');
                        }
        </script>
        <!-- Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>