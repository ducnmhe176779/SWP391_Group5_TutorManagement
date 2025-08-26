<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>G5 SmartTutor - Đăng ký User</title>
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
        <!-- CSS tùy chỉnh cho language switcher -->
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
            .form-section {
                margin-bottom: 30px;
                padding: 20px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                background-color: #f9f9f9;
            }
            .section-title {
                color: #2c3e50;
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 2px solid #3498db;
            }
            .form-control {
                color: #000000 !important;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
                font-size: 14px !important;
                line-height: 1.5 !important;
                margin-bottom: 15px !important;
            }
            .form-control option {
                color: #000000 !important;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
                font-size: 14px !important;
            }
            .form-control:focus {
                border-color: #3498db !important;
                box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25) !important;
            }
            label {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
                font-weight: 600 !important;
                color: #2c3e50 !important;
                font-size: 14px !important;
                margin-bottom: 8px !important;
                display: block !important;
                clear: both !important;
            }
            .form-group {
                margin-bottom: 25px !important;
                clear: both !important;
            }
            .input-group {
                margin-bottom: 20px !important;
                clear: both !important;
            }
            .btn.button-md {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
                font-weight: 600 !important;
                font-size: 16px !important;
                padding: 12px 30px !important;
                border-radius: 25px !important;
                text-transform: uppercase !important;
                letter-spacing: 0.5px !important;
            }
            .registration-type-buttons {
                text-align: center;
                margin-bottom: 30px;
            }
            .registration-type-buttons .btn {
                margin: 0 10px;
                padding: 12px 30px;
                font-size: 16px;
                border-radius: 25px;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
                font-weight: 600 !important;
            }
            .btn-user {
                background-color: #3498db;
                border-color: #3498db;
            }
            .btn-tutor {
                background-color: #e74c3c;
                border-color: #e74c3c;
            }
            .btn-user:hover {
                background-color: #2980b9;
                border-color: #2980b9;
            }
            .btn-tutor:hover {
                background-color: #c0392b;
                border-color: #c0392b;
            }
            
            /* Fix overlapping text issues */
            .form-group label {
                position: relative !important;
                top: auto !important;
                left: auto !important;
                float: none !important;
                display: block !important;
                margin-bottom: 8px !important;
            }
            
            .input-group {
                position: relative !important;
                display: block !important;
                width: 100% !important;
            }
            
            .input-group label {
                position: static !important;
                margin-bottom: 8px !important;
            }
            
            /* Ensure proper spacing between form elements */
            .form-group + .form-group {
                margin-top: 20px !important;
            }
            
            .input-group + .input-group {
                margin-top: 15px !important;
            }
            
            /* Consistent heights for form elements */
            input[type="text"].form-control,
            input[type="email"].form-control,
            input[type="password"].form-control,
            input[type="date"].form-control {
                height: 45px;
                margin-top: 5px !important;
            }
            
            input[type="file"].form-control {
                padding: 8px;
                height: auto;
                margin-top: 5px !important;
            }
        </style>
    </head>
    <body id="bg">
        <!-- Thiết lập Locale và Resource Bundle -->
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
                        <div class="heading-bx left">
                            <h2 class="title-head"><fmt:message key="sign_up"/> <span><fmt:message key="now"/></span></h2>
                            <p><fmt:message key="login_your_account"/> <a href="login.jsp"><fmt:message key="click_here"/></a></p>
                        </div>
                        
                        <!-- Registration Type Selection -->
                        <div class="registration-type-buttons">
                            <a href="register_user.jsp" class="btn btn-user">Đăng ký User</a>
                            <a href="User?service=registerTutor" class="btn btn-tutor">Đăng ký Tutor</a>
                        </div>
                        
                        <form action="User" method="POST" class="contact-bx" enctype="multipart/form-data">
                            <input type="hidden" name="service" value="registerUser">
                            
                            <!-- Personal Information Section -->
                            <div class="form-section">
                                <h3 class="section-title"><fmt:message key="personal_information"/></h3>
                                <div class="row placeani">
                                    <input type="hidden" name="RoleID" value="2">
                                    <input type="hidden" name="IsActive" value="1">

                                    <c:if test="${not empty requestScope.error}">
                                        <div class="col-lg-12"><p class="text-danger">${requestScope.error}</p></div>
                                    </c:if>
                                    <c:if test="${not empty sessionScope.success}">
                                        <div class="col-lg-12"><p class="text-success">${sessionScope.success}</p></div>
                                        <c:remove var="success" scope="session"/>
                                    </c:if>

                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><fmt:message key="email"/></label>
                                                <input type="email" name="Email" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><fmt:message key="full_name"/></label>
                                                <input type="text" name="FullName" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><fmt:message key="phone"/></label>
                                                <input type="text" name="Phone" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group1">
                                                <label><fmt:message key="dob"/></label>
                                                <input type="date" name="Dob" id="dobUser" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><fmt:message key="address"/></label>
                                                <input type="text" name="Address" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group1">
                                                <label><fmt:message key="avatar"/></label>
                                                <input type="file" name="avatar" accept="image/*">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><fmt:message key="username"/></label>
                                                <input type="text" name="UserName" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label><fmt:message key="password"/></label>
                                                <input type="password" name="Password" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-12 m-b30">
                                <button type="submit" class="btn button-md" name="submit" value="registerUser"><fmt:message key="sign_up"/></button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <script src="assets/js/jquery.min.js"></script>
            <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
            <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
            <script src="assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
            <script src="assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
            <script src="assets/vendors/magnific-popup/magnific-popup.js"></script>
            <script src="assets/vendors/counter/waypoints-min.js"></script>
            <script src="assets/vendors/counter/counterup.min.js"></script>
            <script src="assets/vendors/imagesloaded/imagesloaded.js"></script>
            <script src="assets/vendors/masonry/masonry.js"></script>
            <script src="assets/vendors/masonry/filter.js"></script>
            <script src="assets/vendors/owl-carousel/owl.carousel.js"></script>
            <script src="assets/js/functions.js"></script>
            <script src="assets/js/contact.js"></script>
            <script src='assets/vendors/switcher/switcher.js'></script>
            <script>
                (function() {
                    var dobInput = document.getElementById('dobUser');
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
                                if (age < 13) {
                                    e.preventDefault();
                                    alert('Bạn phải đủ 13 tuổi trở lên.');
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
