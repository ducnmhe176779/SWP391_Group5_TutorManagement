<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>G5 SmartTutor - Đăng ký Học Sinh</title>
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
        <!-- ULTRA AGGRESSIVE FIX FOR UI OVERLAP -->
        <link rel="stylesheet" type="text/css" href="assets/css/student-register-fix.css">
        <style>
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
            .student-header {
                background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
                color: white;
                padding: 20px;
                border-radius: 10px 10px 0 0;
                margin-bottom: 0;
            }
            .student-header h2 {
                color: white !important;
                margin: 0;
            }
            .student-header .fa {
                font-size: 2rem;
                margin-right: 15px;
                vertical-align: middle;
            }
            .form-section {
                background: #f8f9fa;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 8px;
                border-left: 4px solid #3498db;
            }
            .section-title {
                color: #2c3e50;
                font-size: 1.2rem;
                margin-bottom: 15px;
                font-weight: 600;
            }
            .btn-student {
                background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
                border: none;
                color: white;
                padding: 12px 30px;
                border-radius: 25px;
                font-weight: 600;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .btn-student:hover {
                background: linear-gradient(135deg, #2980b9 0%, #1f6391 100%);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
                color: white;
            }
            .back-link {
                display: inline-block;
                margin-bottom: 20px;
                color: #7f8c8d;
                text-decoration: none;
                font-size: 0.9rem;
            }
            .back-link:hover {
                color: #3498db;
                text-decoration: none;
            }
            .back-link i {
                margin-right: 5px;
            }
            
            /* FIX UI OVERLAP - AGGRESSIVE OVERRIDES */
            .form-group {
                margin-bottom: 20px !important;
                clear: both !important;
                overflow: hidden !important;
            }
            
            .form-group label {
                display: block !important;
                margin-bottom: 8px !important;
                font-weight: 600 !important;
                color: #333 !important;
                width: 100% !important;
                float: none !important;
                clear: both !important;
            }
            
            .form-control {
                width: 100% !important;
                padding: 12px 15px !important;
                border: 1px solid #ddd !important;
                border-radius: 6px !important;
                font-size: 14px !important;
                line-height: 1.4 !important;
                box-sizing: border-box !important;
                display: block !important;
                clear: both !important;
                margin-top: 0 !important;
            }
            
            .col-lg-6, .col-lg-12 {
                width: 100% !important;
                float: none !important;
                padding: 0 !important;
                margin-bottom: 15px !important;
                box-sizing: border-box !important;
            }
            
            .row {
                margin: 0 !important;
                display: block !important;
                width: 100% !important;
                clear: both !important;
            }
            
            .form-section {
                clear: both !important;
                overflow: hidden !important;
                padding: 25px !important;
                margin-bottom: 25px !important;
            }
            
            .student-header {
                clear: both !important;
                overflow: hidden !important;
            }
            
            .clearfix::after {
                content: "";
                display: table;
                clear: both;
            }
            
            /* Responsive fixes */
            @media (max-width: 768px) {
                .col-lg-6 {
                    width: 100% !important;
                    margin-bottom: 15px !important;
                }
                
                .form-control {
                    font-size: 16px !important; /* Prevent zoom on mobile */
                }
            }
            
            /* NUCLEAR OPTION - ULTRA SPECIFIC OVERRIDES */
            body div.page-wraper div.contact-bx form div.form-section div.row div.col-lg-6 div.form-group {
                margin-bottom: 25px !important;
                clear: both !important;
                overflow: visible !important;
                display: block !important;
                width: 100% !important;
                float: none !important;
                position: static !important;
            }
            
            body div.page-wraper div.contact-bx form div.form-section div.row div.col-lg-6 div.form-group label {
                display: block !important;
                width: 100% !important;
                margin-bottom: 10px !important;
                float: none !important;
                clear: both !important;
                position: static !important;
                z-index: auto !important;
                background: transparent !important;
            }
            
            body div.page-wraper div.contact-bx form div.form-section div.row div.col-lg-6 div.form-group input.form-control,
            body div.page-wraper div.contact-bx form div.form-section div.row div.col-lg-12 div.form-group input.form-control {
                width: 100% !important;
                display: block !important;
                clear: both !important;
                margin: 0 !important;
                padding: 15px !important;
                font-size: 16px !important;
                line-height: 1.5 !important;
                border: 2px solid #ddd !important;
                border-radius: 8px !important;
                background: #fff !important;
                color: #333 !important;
                position: static !important;
                float: none !important;
                height: auto !important;
                min-height: 50px !important;
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
                        
                        <div class="student-header">
                            <h2 class="title-head">
                                <i class="fa fa-graduation-cap"></i>
                                Đăng ký tài khoản <span>Học Sinh</span>
                            </h2>
                            <p style="margin: 10px 0 0 0; opacity: 0.9;">
                                Tham gia hệ thống để tìm kiếm và đặt lịch học với các gia sư chất lượng
                            </p>
                        </div>
                        
                        <form action="User" method="POST" class="contact-bx" enctype="multipart/form-data">
                            <input type="hidden" name="service" value="registerStudent">
                            <input type="hidden" name="RoleID" value="2">
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
                                            <div class="input-group" style="display: block !important; width: 100% !important;">
                                                <label style="display: block !important; width: 100% !important; margin-bottom: 10px !important; float: none !important; clear: both !important; font-weight: 600 !important; color: #333 !important;"><i class="fa fa-envelope"></i> Email *</label>
                                                <input type="email" name="Email" class="form-control" required 
                                                       placeholder="Nhập địa chỉ email của bạn" style="width: 100% !important; padding: 15px !important; border: 2px solid #ddd !important; border-radius: 8px !important; font-size: 16px !important; display: block !important; clear: both !important; margin: 0 !important; background: #fff !important; color: #333 !important; min-height: 50px !important;">
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
                                                <input type="date" name="Dob" id="dobStudent" class="form-control" required>
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

                            <!-- Avatar Section -->
                            <div class="form-section clearfix">
                                <h3 class="section-title">
                                    <i class="fa fa-camera"></i> Ảnh đại diện (Tùy chọn)
                                </h3>
                                <div class="row placeani clearfix">
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group1">
                                                <input type="file" name="avatar" accept="image/*" class="form-control">
                                                <small class="form-text text-muted">
                                                    Chọn ảnh đại diện (JPG, PNG, tối đa 10MB)
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
                                    <button type="submit" class="btn btn-student" name="submit" value="registerStudent">
                                        <i class="fa fa-graduation-cap"></i> Đăng ký tài khoản Học Sinh
                                    </button>
                                </div>
                            </div>
                        </form>
                        
                        <div class="text-center" style="margin-top: 20px;">
                            <p>Đã có tài khoản? <a href="login.jsp" style="color: #3498db;">Đăng nhập ngay</a></p>
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
            (function() {
                var dobInput = document.getElementById('dobStudent');
                if (dobInput) {
                    var today = new Date();
                    var yyyy = today.getFullYear();
                    var mm = String(today.getMonth() + 1).padStart(2, '0');
                    var dd = String(today.getDate()).padStart(2, '0');
                    var maxDate = yyyy + '-' + mm + '-' + dd;
                    dobInput.setAttribute('max', maxDate);

                    var form = dobInput.form;
                    if (form) {
                        form.addEventListener('submit', function(e) {
                            var value = dobInput.value;
                            if (!value) return;
                            var dob = new Date(value + 'T00:00:00');
                            var now = new Date();
                            if (dob > now) {
                                e.preventDefault();
                                alert('Ngày sinh không được ở tương lai.');
                                dobInput.focus();
                                return false;
                            }
                            var age = now.getFullYear() - dob.getFullYear();
                            var m = now.getMonth() - dob.getMonth();
                            if (m < 0 || (m === 0 && now.getDate() < dob.getDate())) {
                                age--;
                            }
                            if (age < 7) { // học sinh nhỏ tuổi tối thiểu 7
                                e.preventDefault();
                                alert('Học sinh phải đủ 7 tuổi trở lên.');
                                dobInput.focus();
                                return false;
                            }
                        });
                    }
                }
            })();
        </script>
    </body>
</html>
