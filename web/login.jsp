<%-- 
    Document   : login1
    Created on : Aug 14, 2025, 10:29:15 PM
    Author     : Dat Anh
--%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
        <!-- FAVICONS ICON -->
        <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- MOBILE SPECIFIC -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>G5 SmartTutor</title>
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
        </style>
    </head>
    <body id="bg">
        <!-- Thiết lập Locale và Resource Bundle -->
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper">
            <!-- Tạm thời loại bỏ loading-icon-bx để kiểm tra -->
            <!-- <div id="loading-icon-bx"></div> -->
            <div class="account-form">
                <div class="account-head" style="background-image:url(assets/images/background/bg.jpg); position: relative;">
                    <div class="language-switcher">
                        <select class="header-lang-bx" onchange="window.location.href = 'LanguageServlet?lang=' + this.value;">
                            <option value="en" ${sessionScope.locale == null || sessionScope.locale == 'en' ? 'selected' : ''}><fmt:message key="english"/></option>
                            <option value="vi" ${sessionScope.locale == 'vi' ? 'selected' : ''}><fmt:message key="vietnamese"/></option>
                        </select>
                    </div>
                    <a href="home"><img src="assets/images/logo-white-2.png" alt=""></a>
                </div>
                <div class="account-form-inner">
                    <div class="account-container">
                        <div class="heading-bx left">
                            <h2 class="title-head"><fmt:message key="login_to_your"/> <span><fmt:message key="account"/></span></h2>
                            <p><fmt:message key="dont_have_account"/> <a href="register.jsp"><fmt:message key="create_one_here"/></a></p>
                        </div>  
                        <form action="login" class="contact-bx">
                            <input type="hidden" name="service" value="loginUser">
                            <div class="row placeani">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <div class="input-group">
                                            <label><fmt:message key="username"/></label>
                                            <input name="loginInput" type="text" required class="form-control">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <div class="input-group">
                                            <label><fmt:message key="password"/></label>
                                            <input name="password" type="password" class="form-control" required>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group form-forget">
                                        <div class="custom-control custom-checkbox">
                                            <input type="checkbox" class="custom-control-input" id="customControlAutosizing">
                                            <label class="custom-control-label" for="customControlAutosizing"><fmt:message key="remember_me"/></label>
                                        </div>
                                        <a href="requestPassword" class="ml-auto"><fmt:message key="forgot_password"/></a>
                                    </div>
                                </div>
                                <p class="text-danger">${error}</p>
                                <div class="col-lg-12 m-b30">
                                    <button name="submit" type="submit" value="Submit" class="btn button-md"><fmt:message key="login"/></button>
                                </div>
                                <div class="col-lg-12">
                                    <h6><fmt:message key="login_with_social_media"/></h6>
                                    <div class="d-flex">
                                        <a class="btn flex-fill m-l5 google" href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:9999/SWP391_Group5_TutorManagement/login&response_type=code&client_id=918167236066-r8da2g0h2eh06buen60d3km6fqaecn1f.apps.googleusercontent.com&approval_prompt=force"><i class="fa fa-google"></i> Google</a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!-- Chỉ tải các thư viện cần thiết -->
            <script src="assets/js/jquery.min.js"></script>
            <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
            <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
            <script src="assets/js/functions.js"></script>
            <!-- Thêm kiểm tra console -->
            <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                console.log('Trang đã load xong');
                                // Nếu loading-icon-bx vẫn hiển thị, ẩn nó thủ công
                                var loadingIcon = document.getElementById('loading-icon-bx');
                                if (loadingIcon) {
                                    loadingIcon.style.display = 'none';
                                }
                            });
            </script>
    </body>
</html>
