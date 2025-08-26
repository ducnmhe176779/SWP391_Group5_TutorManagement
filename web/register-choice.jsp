<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>G5 SmartTutor - Chọn loại đăng ký</title>
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
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
            .registration-choice {
                display: flex;
                justify-content: center;
                gap: 40px;
                margin-top: 40px;
                flex-wrap: wrap;
            }
            .choice-card {
                background: #fff;
                border-radius: 15px;
                padding: 40px 30px;
                text-align: center;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                min-width: 300px;
                max-width: 350px;
                border: 2px solid transparent;
            }
            .choice-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            }
            .choice-card.student {
                border-color: #3498db;
            }
            .choice-card.student:hover {
                border-color: #2980b9;
                background: linear-gradient(135deg, #f8f9fa 0%, #e3f2fd 100%);
            }
            .choice-card.tutor {
                border-color: #e74c3c;
            }
            .choice-card.tutor:hover {
                border-color: #c0392b;
                background: linear-gradient(135deg, #f8f9fa 0%, #ffebee 100%);
            }
            .choice-icon {
                font-size: 4rem;
                margin-bottom: 20px;
                display: block;
            }
            .choice-card.student .choice-icon {
                color: #3498db;
            }
            .choice-card.tutor .choice-icon {
                color: #e74c3c;
            }
            .choice-title {
                font-size: 1.8rem;
                font-weight: 700;
                margin-bottom: 15px;
                color: #2c3e50;
            }
            .choice-description {
                color: #7f8c8d;
                margin-bottom: 25px;
                line-height: 1.6;
            }
            .choice-btn {
                display: inline-block;
                padding: 12px 30px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-size: 0.9rem;
            }
            .choice-btn.student {
                background: #3498db;
                color: white;
                border: 2px solid #3498db;
            }
            .choice-btn.student:hover {
                background: #2980b9;
                border-color: #2980b9;
                color: white;
                text-decoration: none;
            }
            .choice-btn.tutor {
                background: #e74c3c;
                color: white;
                border: 2px solid #e74c3c;
            }
            .choice-btn.tutor:hover {
                background: #c0392b;
                border-color: #c0392b;
                color: white;
                text-decoration: none;
            }
            .back-to-login {
                text-align: center;
                margin-top: 30px;
            }
            .back-to-login a {
                color: #7f8c8d;
                text-decoration: none;
                font-size: 0.9rem;
            }
            .back-to-login a:hover {
                color: #2c3e50;
                text-decoration: underline;
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
                        <div class="heading-bx left" style="text-align: center;">
                            <h2 class="title-head">Chọn loại tài khoản <span>đăng ký</span></h2>
                            <p>Bạn muốn đăng ký tài khoản nào?</p>
                        </div>
                        
                        <div class="registration-choice">
                            <!-- Student Registration Card -->
                            <div class="choice-card student">
                                <i class="choice-icon fa fa-graduation-cap"></i>
                                <h3 class="choice-title">Học Sinh</h3>
                                <p class="choice-description">
                                    Tìm kiếm và đặt lịch học với các gia sư chất lượng. 
                                    Học tập hiệu quả với chi phí hợp lý.
                                </p>
                                <a href="User?service=registerStudent" class="choice-btn student">
                                    Đăng ký Học Sinh
                                </a>
                            </div>
                            
                            <!-- Tutor Registration Card -->
                            <div class="choice-card tutor">
                                <i class="choice-icon fa fa-chalkboard-teacher"></i>
                                <h3 class="choice-title">Gia Sư</h3>
                                <p class="choice-description">
                                    Chia sẻ kiến thức và kiếm thu nhập từ việc dạy học. 
                                    Quản lý lịch dạy linh hoạt theo thời gian của bạn.
                                </p>
                                <a href="User?service=registerTutor" class="choice-btn tutor">
                                    Đăng ký Gia Sư
                                </a>
                            </div>
                        </div>
                        
                        <div class="back-to-login">
                            <p>Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/js/functions.js"></script>
    </body>
</html>
