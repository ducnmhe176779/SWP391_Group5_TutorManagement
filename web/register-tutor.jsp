<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>G5 SmartTutor - Đăng ký Gia Sư</title>
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
        <link rel="stylesheet" type="text/css" href="assets/css/tutor-register.css">
        <style>
            /* Override conflicting styles and fix text overlap */
            * {
                box-sizing: border-box !important;
            }
            
            .language-switcher {
                position: absolute;
                top: 10px;
                right: 10px;
                z-index: 1000;
            }
            
            .language-switcher select {
                padding: 5px;
                border-radius: 5px;
                background-color: #fff;
                color: #000;
                border: 1px solid #ccc;
            }
            
            /* Fix text overlap issues */
            .form-group {
                margin-bottom: 25px !important;
                clear: both;
                overflow: hidden;
            }
            
            .form-group label {
                display: block !important;
                width: 100% !important;
                margin-bottom: 8px !important;
                font-weight: 600;
                color: #495057;
                font-size: 14px;
                line-height: 1.4;
                clear: both;
            }
            
            .form-control {
                width: 100% !important;
                display: block !important;
                padding: 12px 16px !important;
                font-size: 14px !important;
                line-height: 1.5 !important;
                border: 2px solid #e9ecef !important;
                border-radius: 8px !important;
                background-color: #fff !important;
                margin-top: 5px !important;
            }
            
            .form-control:focus {
                border-color: #e74c3c !important;
                box-shadow: 0 0 0 0.2rem rgba(231, 76, 60, 0.25) !important;
            }
            
            textarea.form-control {
                min-height: 100px !important;
                resize: vertical !important;
            }
            
            /* Fix column spacing */
            .col-lg-6, .col-lg-12 {
                padding-left: 15px !important;
                padding-right: 15px !important;
                margin-bottom: 15px;
            }
            
            .row {
                margin-left: -15px !important;
                margin-right: -15px !important;
            }
            
            /* Section styling */
            .form-section {
                background: #fff !important;
                padding: 25px !important;
                margin-bottom: 30px !important;
                border-radius: 8px;
                border-left: 4px solid #e74c3c;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .section-title {
                color: #e74c3c !important;
                font-size: 1.3rem !important;
                margin-bottom: 20px !important;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
                padding-bottom: 10px;
                border-bottom: 2px solid #f8f9fa;
            }
            
            .section-title i {
                font-size: 1.4rem;
                color: #e74c3c;
            }
            
            /* Header */
            .tutor-header {
                background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%) !important;
                color: white !important;
                padding: 30px !important;
                border-radius: 10px 10px 0 0;
                margin-bottom: 0 !important;
                text-align: center;
            }
            
            .tutor-header h2 {
                color: white !important;
                margin: 0 !important;
                font-size: 2rem;
                font-weight: 700;
            }
            
            .tutor-header p {
                color: white !important;
                margin: 10px 0 0 0 !important;
                opacity: 0.9;
            }
            
            /* Subject selection fix */
            .subjects-grid {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)) !important;
                gap: 15px !important;
                max-height: 400px !important;
                overflow-y: auto !important;
                border: 2px solid #e9ecef !important;
                padding: 20px !important;
                border-radius: 10px !important;
                background: #f8f9fa !important;
                margin-top: 15px !important;
            }
            
            .subject-option {
                display: flex !important;
                align-items: flex-start !important;
                padding: 15px !important;
                background: white !important;
                border-radius: 8px !important;
                border: 2px solid #e9ecef !important;
                cursor: pointer !important;
                transition: all 0.3s ease !important;
                min-height: 80px !important;
                word-wrap: break-word !important;
                overflow-wrap: break-word !important;
            }
            
            .subject-option:hover {
                border-color: #e74c3c !important;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            
            .subject-option input[type="checkbox"] {
                margin-right: 12px !important;
                transform: scale(1.3) !important;
                margin-top: 2px !important;
                flex-shrink: 0 !important;
            }
            
            .subject-option label {
                margin: 0 !important;
                cursor: pointer !important;
                flex: 1 !important;
                font-weight: 500 !important;
                line-height: 1.4 !important;
                word-wrap: break-word !important;
            }
            
            .subject-option label strong {
                color: #495057 !important;
                font-size: 15px !important;
                display: block !important;
                margin-bottom: 5px !important;
                font-weight: 600 !important;
            }
            
            .subject-option label small {
                color: #6c757d !important;
                font-size: 12px !important;
                line-height: 1.3 !important;
                display: block !important;
            }
            
            /* Button styles */
            .btn-tutor, .btn-register {
                background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%) !important;
                border: none !important;
                color: white !important;
                padding: 15px 40px !important;
                border-radius: 25px !important;
                font-weight: 600 !important;
                font-size: 16px !important;
                transition: all 0.3s ease !important;
                width: 100% !important;
                margin-top: 20px !important;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            
            .btn-tutor:hover, .btn-register:hover {
                background: linear-gradient(135deg, #c0392b 0%, #a93226 100%) !important;
                transform: translateY(-2px) !important;
                box-shadow: 0 8px 20px rgba(231, 76, 60, 0.4) !important;
                color: white !important;
            }
            
            .btn-secondary {
                background: #6c757d !important;
                border: none !important;
                color: white !important;
                padding: 15px 40px !important;
                border-radius: 25px !important;
                font-weight: 600 !important;
                font-size: 16px !important;
                transition: all 0.3s ease !important;
                width: 100% !important;
                margin-top: 10px !important;
            }
            
            .btn-secondary:hover {
                background: #545b62 !important;
                transform: translateY(-2px) !important;
                color: white !important;
            }
            
            /* Note section */
            .note-section, .note-text {
                background: #fff3cd !important;
                border: 1px solid #ffeaa7 !important;
                border-radius: 8px !important;
                padding: 15px !important;
                margin-bottom: 20px !important;
                color: #856404 !important;
                font-size: 14px !important;
                line-height: 1.5 !important;
            }
            
            .note-section .fa {
                color: #f39c12 !important;
                margin-right: 10px !important;
            }
            
            /* Back link */
            .back-link {
                display: inline-block !important;
                margin-bottom: 20px !important;
                color: #7f8c8d !important;
                text-decoration: none !important;
                font-size: 0.9rem !important;
            }
            
            .back-link:hover {
                color: #e74c3c !important;
                text-decoration: none !important;
            }
            
            .back-link i {
                margin-right: 5px !important;
            }
            
            /* Responsive fixes */
            @media (max-width: 768px) {
                .form-section {
                    padding: 20px 15px !important;
                }
                
                .subjects-grid {
                    grid-template-columns: 1fr !important;
                    padding: 15px !important;
                    max-height: 300px !important;
                }
                
                .subject-option {
                    min-height: 70px !important;
                    padding: 12px !important;
                }
                
                .tutor-header {
                    padding: 20px !important;
                }
                
                .tutor-header h2 {
                    font-size: 1.6rem !important;
                }
            }
            
            /* Force clear floats */
            .clearfix::after {
                content: "";
                display: table;
                clear: both;
            }
        </style>
    </head>
    <body id="bg">
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper">
            <div class="account-form">
                <div class="account-head" style="background-image:url(assets/images/background/bg2.jpg);">
                    <div class="language-switcher">
                        <select class="header-lang-bx" onchange="location.href = '${pageContext.request.contextPath}/LanguageServlet?lang=' + this.value;">
                            <option value="en" ${sessionScope.locale == null || sessionScope.locale == 'en' ? 'selected' : ''}><fmt:message key="english"/></option>
                            <option value="vi" ${sessionScope.locale == 'vi' ? 'selected' : ''}><fmt:message key="vietnamese"/></option>
                        </select>
                    </div>
                    <a href="home"><img src="${pageContext.request.contextPath}/assets/images/logo-white-2.png" alt=""></a>
                </div>
                <div class="account-form-inner">
                    <div class="account-container">
                        <a href="register-choice.jsp" class="back-link">
                            <i class="fa fa-arrow-left"></i> Quay lại chọn loại tài khoản
                        </a>
                        
                        <div class="tutor-header">
                            <h2 class="title-head">
                                <i class="fa fa-chalkboard-teacher"></i>
                                Đăng ký tài khoản <span>Gia Sư</span>
                            </h2>
                            <p style="margin: 10px 0 0 0; opacity: 0.9;">
                                Chia sẻ kiến thức và kiếm thu nhập từ việc dạy học
                            </p>
                        </div>
                        
                        <!-- Important Note -->
                        <div class="note-section">
                            <p><i class="fa fa-info-circle"></i> 
                                <strong>Lưu ý quan trọng:</strong> Sau khi đăng ký thành công, bạn cần cập nhật CV và chờ admin duyệt 
                                để có thể bắt đầu nhận học sinh.
                            </p>
                        </div>
                        
                        <form action="User" method="POST" class="contact-bx" enctype="multipart/form-data">
                            <input type="hidden" name="service" value="registerTutor">
                            <input type="hidden" name="RoleID" value="3">
                            <input type="hidden" name="IsActive" value="1">
                            
                            <c:if test="${not empty requestScope.error}">
                                <div class="alert alert-danger">${requestScope.error}</div>
                            </c:if>
                            <c:if test="${not empty sessionScope.success}">
                                <div class="alert alert-success">${sessionScope.success}</div>
                                <c:remove var="success" scope="session"/>
                            </c:if>

                            <!-- Personal Information Section -->
                            <div class="form-section clearfix">
                                <h3 class="section-title">
                                    <i class="fa fa-user"></i> Thông tin cá nhân
                                </h3>
                                <div class="row placeani clearfix">
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-envelope"></i> Email *</label>
                                                <input type="email" name="Email" class="form-control" required 
                                                       placeholder="Nhập địa chỉ email của bạn">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-id-card"></i> Họ và tên *</label>
                                                <input type="text" name="FullName" class="form-control" required
                                                       placeholder="Nhập họ và tên đầy đủ">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-phone"></i> Số điện thoại *</label>
                                                <input type="text" name="Phone" class="form-control" required
                                                       placeholder="Nhập số điện thoại">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group1">
                                                <label><i class="fa fa-calendar"></i> Ngày sinh *</label>
                                                <input type="date" name="Dob" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-map-marker"></i> Địa chỉ *</label>
                                                <input type="text" name="Address" class="form-control" required
                                                       placeholder="Nhập địa chỉ của bạn">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Professional Information Section -->
                            <div class="form-section clearfix">
                                <h3 class="section-title">
                                    <i class="fa fa-briefcase"></i> Thông tin nghề nghiệp
                                </h3>
                                <div class="row placeani clearfix">
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-graduation-cap"></i> Trình độ học vấn *</label>
                                                <input type="text" name="Education" class="form-control" required
                                                       placeholder="Ví dụ: Cử nhân Toán học - ĐH Bách Khoa">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-star"></i> Kinh nghiệm dạy học *</label>
                                                <input type="text" name="Experience" class="form-control" required
                                                       placeholder="Ví dụ: 3 năm dạy Toán THPT">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-list-alt"></i> Kinh nghiệm chi tiết</label>
                                                <textarea name="DetailedExperience" class="form-control" rows="4" 
                                                          placeholder="Mô tả chi tiết kinh nghiệm dạy học của bạn: các cấp độ đã dạy, thành tích học sinh, phương pháp giảng dạy..."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-certificate"></i> Chứng chỉ</label>
                                                <input type="text" name="Certificates" class="form-control" 
                                                       placeholder="Ví dụ: IELTS 7.5, TOEIC 900, Giáo viên giỏi cấp thành phố">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-cogs"></i> Kỹ năng đặc biệt</label>
                                                <input type="text" name="Skills" class="form-control" 
                                                       placeholder="Ví dụ: Dạy online, Tâm lý học đường, Phương pháp Montessori">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-money"></i> Giá giờ dạy (VND/giờ) *</label>
                                                <input type="number" name="Price" class="form-control" required
                                                       min="10000" max="1000000" step="1000"
                                                       placeholder="Ví dụ: 150000">
                                                <small class="form-text text-muted">Giá từ 10,000 đến 1,000,000 VND/giờ</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-info-circle"></i> Giới thiệu bản thân *</label>
                                                <textarea name="Description" class="form-control" rows="4" required
                                                          placeholder="Mô tả về bản thân, phong cách dạy học, điểm mạnh và cam kết với học sinh"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Subject Selection Section -->
                            <div class="form-section clearfix">
                                <h3 class="section-title">
                                    <i class="fa fa-book"></i> Môn học có thể dạy *
                                </h3>
                                <div class="row placeani clearfix">
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <label style="margin-bottom: 15px;">
                                                <i class="fa fa-check-square"></i> Chọn các môn học bạn có thể dạy (chọn ít nhất 1 môn):
                                            </label>
                                            
                                            <!-- Debug information -->
                                            <div style="background: #f0f0f0; padding: 10px; margin-bottom: 10px; border-radius: 5px; font-size: 12px;">
                                                <strong>Debug Info:</strong><br/>
                                                Subjects attribute: ${subjects != null ? 'Found' : 'NULL'}<br/>
                                                <c:if test="${subjects != null}">
                                                    Subjects count: ${subjects.size()}<br/>
                                                </c:if>
                                                <c:if test="${empty subjects}">
                                                    <span style="color: red;">Subjects list is empty!</span><br/>
                                                </c:if>
                                            </div>
                                            
                                            <div class="subjects-grid">
                                                <c:choose>
                                                    <c:when test="${empty subjects}">
                                                        <div style="grid-column: 1/-1; text-align: center; padding: 20px; background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; color: #856404;">
                                                            <i class="fa fa-exclamation-triangle"></i>
                                                            <strong>Không tìm thấy môn học nào!</strong><br/>
                                                            Vui lòng liên hệ admin để thêm môn học vào hệ thống.
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach items="${subjects}" var="subject">
                                                            <div class="subject-option">
                                                                <input type="checkbox" name="selectedSubjects" value="${subject.subjectID}" 
                                                                       id="subject_${subject.subjectID}">
                                                                <label for="subject_${subject.subjectID}">
                                                                    <strong>${subject.subjectName}</strong>
                                                                    <c:if test="${not empty subject.description}">
                                                                        <br><small>${subject.description}</small>
                                                                    </c:if>
                                                                </label>
                                                            </div>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <small class="form-text text-muted">
                                                Bạn có thể cập nhật thêm môn học và đặt giá riêng cho từng môn sau khi tài khoản được duyệt.
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Images Section -->
                            <div class="form-section clearfix">
                                <h3 class="section-title">
                                    <i class="fa fa-camera"></i> Hình ảnh
                                </h3>
                                <div class="row placeani clearfix">
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group1">
                                                <label><i class="fa fa-user-circle"></i> Ảnh đại diện</label>
                                                <input type="file" name="avatar" accept="image/*" class="form-control">
                                                <small class="form-text text-muted">
                                                    Ảnh đại diện chuyên nghiệp (JPG, PNG, tối đa 10MB)
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group1">
                                                <label><i class="fa fa-file-image"></i> Ảnh CV/Bằng cấp</label>
                                                <input type="file" name="cvImage" accept="image/*" class="form-control">
                                                <small class="form-text text-muted">
                                                    Ảnh CV hoặc bằng cấp để xác minh (JPG, PNG, tối đa 10MB)
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Account Information Section -->
                            <div class="form-section clearfix">
                                <h3 class="section-title">
                                    <i class="fa fa-lock"></i> Thông tin tài khoản
                                </h3>
                                <div class="row placeani clearfix">
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-user-circle"></i> Tên đăng nhập *</label>
                                                <input type="text" name="UserName" class="form-control" required
                                                       placeholder="Chọn tên đăng nhập">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><i class="fa fa-key"></i> Mật khẩu *</label>
                                                <input type="password" name="Password" class="form-control" required
                                                       placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <div class="row">
                                <div class="col-lg-12 m-b30 text-center">
                                    <button type="submit" class="btn btn-tutor" name="submit" value="registerTutor">
                                        <i class="fa fa-chalkboard-teacher"></i> Đăng ký tài khoản Gia Sư
                                    </button>
                                </div>
                            </div>
                        </form>
                        
                        <div class="text-center" style="margin-top: 20px;">
                            <p>Đã có tài khoản? <a href="login.jsp" style="color: #e74c3c;">Đăng nhập ngay</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/js/functions.js"></script>
        <script>
            $(document).ready(function() {
                // Form validation
                $('form').on('submit', function(e) {
                    var selectedSubjects = $('input[name="selectedSubjects"]:checked').length;
                    if (selectedSubjects === 0) {
                        e.preventDefault();
                        alert('Vui lòng chọn ít nhất một môn học bạn có thể dạy.');
                        $('html, body').animate({
                            scrollTop: $('.subjects-grid').offset().top - 100
                        }, 500);
                        return false;
                    }
                    
                    // Validate required fields
                    var requiredFields = ['Education', 'Experience', 'Description'];
                    for (var i = 0; i < requiredFields.length; i++) {
                        var field = $('[name="' + requiredFields[i] + '"]');
                        if (field.val().trim() === '') {
                            e.preventDefault();
                            alert('Vui lòng điền đầy đủ thông tin bắt buộc.');
                            field.focus();
                            return false;
                        }
                    }
                });
                
                // Subject selection enhancement
                $('.subject-option').on('click', function(e) {
                    if (e.target.type !== 'checkbox') {
                        var checkbox = $(this).find('input[type="checkbox"]');
                        checkbox.prop('checked', !checkbox.prop('checked'));
                        updateSubjectSelection();
                    }
                });
                
                $('input[name="selectedSubjects"]').on('change', function() {
                    updateSubjectSelection();
                });
                
                function updateSubjectSelection() {
                    $('.subject-option').each(function() {
                        var checkbox = $(this).find('input[type="checkbox"]');
                        if (checkbox.prop('checked')) {
                            $(this).css({
                                'background': '#e8f5e8',
                                'border-color': '#28a745',
                                'box-shadow': '0 2px 4px rgba(40, 167, 69, 0.2)'
                            });
                        } else {
                            $(this).css({
                                'background': 'white',
                                'border-color': '#eee',
                                'box-shadow': 'none'
                            });
                        }
                    });
                    
                    var selectedCount = $('input[name="selectedSubjects"]:checked').length;
                    var countDisplay = $('.subjects-grid').parent().find('.selected-count');
                    if (countDisplay.length === 0) {
                        $('.subjects-grid').after('<div class="selected-count" style="margin-top: 10px; font-weight: bold; color: #28a745;"></div>');
                        countDisplay = $('.selected-count');
                    }
                    
                    if (selectedCount > 0) {
                        countDisplay.html('<i class="fa fa-check-circle"></i> Đã chọn ' + selectedCount + ' môn học');
                    } else {
                        countDisplay.html('<i class="fa fa-exclamation-triangle" style="color: #dc3545;"></i> Chưa chọn môn học nào');
                    }
                }
                
                // File upload preview
                $('input[type="file"]').on('change', function() {
                    var fileInput = $(this);
                    var file = this.files[0];
                    var previewContainer = fileInput.parent().find('.file-preview');
                    
                    if (previewContainer.length === 0) {
                        fileInput.parent().append('<div class="file-preview" style="margin-top: 10px;"></div>');
                        previewContainer = fileInput.parent().find('.file-preview');
                    }
                    
                    if (file) {
                        var fileName = file.name;
                        var fileSize = (file.size / 1024 / 1024).toFixed(2); // MB
                        previewContainer.html('<small style="color: #28a745;"><i class="fa fa-check"></i> ' + fileName + ' (' + fileSize + ' MB)</small>');
                    } else {
                        previewContainer.empty();
                    }
                });
                
                // Initialize subject selection display
                updateSubjectSelection();
            });
        </script>
    </body>
</html>
