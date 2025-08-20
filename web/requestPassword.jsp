
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>G5 SmartTutor</title>

    <!-- Favicon -->
    <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

    <!-- Stylesheets -->
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
            <div class="account-head" style="background-image:url(assets/images/background/bg2.jpg); position: relative;">
                <div class="language-switcher">
                    <select class="header-lang-bx" onchange="window.location.href='${pageContext.request.contextPath}/LanguageServlet?lang=' + this.value;">
                        <option value="en" ${sessionScope.locale == null || sessionScope.locale == 'en' ? 'selected' : ''}><fmt:message key="english"/></option>
                        <option value="vi" ${sessionScope.locale == 'vi' ? 'selected' : ''}><fmt:message key="vietnamese"/></option>
                    </select>
                </div>
                <a href="home"><img src="${pageContext.request.contextPath}/assets/images/logo-white-2.png" alt=""></a>
            </div>
            <div class="account-form-inner">
                <div class="account-container">
                    <div class="heading-bx left">
                        <h2 class="title-head"><fmt:message key="request"/> <span><fmt:message key="password"/></span></h2>
                        <p><fmt:message key="login_your_account"/> <a href="login"><fmt:message key="click_here"/></a></p>
                    </div>
                    <form class="contact-bx" action="requestPassword" method="POST">
                        <div class="row placeani">
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <label><fmt:message key="your_email_address"/></label>
                                        <input name="email" type="email" class="form-control" required>
                                    </div>
                                </div>
                            </div>
                            <p class="text-danger">${mess}</p> <!-- Thông báo về tình trạng reset mật khẩu -->
                            <div class="col-lg-12 m-b30">
                                <button type="submit" class="btn button-md"><fmt:message key="request_password"/></button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- External JavaScripts -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/js/functions.js"></script>
        <!-- Thêm kiểm tra console và ẩn loading thủ công -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                console.log('Trang requestPassword đã load xong');
                // Nếu loading-icon-bx vẫn hiển thị, ẩn nó thủ công
                var loadingIcon = document.getElementById('loading-icon-bx');
                if (loadingIcon) {
                    loadingIcon.style.display = 'none';
                }
            });
        </script>
    </body>
</html>