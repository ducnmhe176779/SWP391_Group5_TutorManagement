<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>G4 SmartTutor</title>
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
            <div class="account-form">
                <div class="account-head" style="background-image:url(assets/images/background/bg2.jpg);">
                    <div class="language-switcher">
                        <select class="header-lang-bx" onchange="location.href = 'LanguageServlet?lang=' + this.value;">
                            <option value="en" ${sessionScope.locale == null || sessionScope.locale == 'en' ? 'selected' : ''}><fmt:message key="english"/></option>
                            <option value="vi" ${sessionScope.locale == 'vi' ? 'selected' : ''}><fmt:message key="vietnamese"/></option>
                        </select>
                    </div>
                    <a href="home"><img src="assets/images/logo-white-2.png" alt=""></a>
                </div>
                <div class="account-form-inner">
                    <div class="account-container">
                        <div class="heading-bx left">
                            <h2 class="title-head"><fmt:message key="sign_up"/> <span><fmt:message key="now"/></span></h2>
                            <p><fmt:message key="login_your_account"/> <a href="login.jsp"><fmt:message key="click_here"/></a></p>
                        </div>
                        <form action="User" method="POST" class="contact-bx" enctype="multipart/form-data">
                            <input type="hidden" name="service" value="registerUser">
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
                                            <input type="date" name="Dob" class="form-control" required>
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
                                <div class="col-lg-12 m-b30">
                                    <button type="submit" class="btn button-md" name="submit" value="registerUser"><fmt:message key="sign_up"/></button>
                                </div>
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
    </body>
</html>