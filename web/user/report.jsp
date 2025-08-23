<%@ page import="entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />
    <meta name="description" content="G4 SmartTutor : Smart tutor, effective learning." />
    <meta property="og:title" content="G4 SmartTutor : Smart tutor, effective learning." />
    <meta property="og:description" content="G4 SmartTutor : Smart tutor, effective learning." />
    <meta property="og:image" content="" />
    <meta name="format-detection" content="telephone=no">

    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

    <title>G4 SmartTutor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
</head>
<body id="bg">
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
    %>
    <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
    <fmt:setBundle basename="messages"/>

    <div class="page-wraper">
        <!-- <div id="loading-icon-bx"></div> -->
        <header class="header rs-nav header-transparent">
            <div class="top-bar">
                <div class="container">
                    <div class="row d-flex justify-content-between">
                        <div class="topbar-left">
                            <ul>
                                <li><a href="faq-1.html"><i class="fa fa-question-circle"></i><fmt:message key="ask_a_question"/></a></li>
                                <li><a href="javascript:;"><i class="fa fa-envelope-o"></i><fmt:message key="support_email"/></a></li>
                            </ul>
                        </div>
                        <div class="topbar-right">
                            <ul>
                                <li>
                                    <select class="header-lang-bx" onchange="window.location.href='${pageContext.request.contextPath}/LanguageServlet?lang=' + this.value;">
                                        <option value="en" ${sessionScope.locale == null || sessionScope.locale == 'en' ? 'selected' : ''}><fmt:message key="english"/></option>
                                        <option value="vi" ${sessionScope.locale == 'vi' ? 'selected' : ''}><fmt:message key="vietnamese"/></option>
                                    </select>
                                </li>
                                <li>
                                    <div class="ttr-header-submenu">
                                        <ul>
                                            <li>
                                                <a href="profile" class="ttr-material-button ttr-submenu-toggle">
                                                    <span class="ttr-user-avatar">
                                                        <img alt="" 
                                                             src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                                             width="32" height="32"
                                                             onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                                    </span>
                                                </a>
                                            </li>
                                            <li><a href="profile"><fmt:message key="my_profile"/></a></li>
                                            <li><a href="StudentPaymentHistory"><fmt:message key="history_payment"/></a></li>
                                            <li><a href="cv"><fmt:message key="become_a_tutor"/></a></li>
                                            <li><a href="logout"><fmt:message key="logout"/></a></li>
                                        </ul>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="sticky-header navbar-expand-lg">
                <div class="menu-bar clearfix">
                    <div class="container clearfix">
                        <div class="menu-logo">
                            <a href="home"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt=""></a>
                        </div>
                        <div class="menu-links navbar-collapse collapse justify-content-start" id="menuDropdown">
                            <div class="menu-logo">
                                <a href="home"><img src="${pageContext.request.contextPath}/assets/images/logo.png" alt=""></a>
                            </div>
                            <ul class="nav navbar-nav">    
                                <li class="active"><a href="home"><fmt:message key="home"/></a></li>
                                <li><a href="Tutor"><fmt:message key="our_tutor"/></a></li>
                                <li><a href="ViewBlog"><fmt:message key="blog"/></a></li>
                                <c:if test="${sessionScope.user != null && sessionScope.user.roleID == 3}">
                                    <li><a href="CreateSchedule"><fmt:message key="view_schedule"/></a></li>
                                </c:if>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <div class="page-content bg-white">
            <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/banner/banner1.jpg);">
                <div class="container">
                    <div class="page-banner-entry">
                        <h1 class="text-white"><fmt:message key="report_booking"/></h1>
                    </div>
                </div>
            </div>
            <div class="breadcrumb-row">
                <div class="container">
                    <ul class="list-inline">
                        <li><a href="home"><fmt:message key="home"/></a></li>
                        <li><fmt:message key="report_booking"/></li>
                    </ul>
                </div>
            </div>
            <div class="content-block">
                <div class="section-area section-sp1">
                    <div class="container">
                        <a href="home" class="btn btn-primary mb-3"><fmt:message key="back"/></a>
                        <h3><fmt:message key="report_booking"/></h3>
                        <form method="post" action="Report" class="mb-3">
                            <input type="hidden" name="userID" value=${sessionScope.user.userID}>
                            <input type="hidden" name="bookingID" value=${bookId}>
                            <div class="form-group row">
                                <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="full_name"/></label>
                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                    <input class="form-control" type="text" name="fullName" value="<%= user.getFullName() %>" readonly>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="email"/></label>
                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                    <input class="form-control" type="email" name="email" value="<%= user.getEmail() %>" readonly>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="reason"/></label>
                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                    <textarea name="reason" rows="4" class="form-control" placeholder="<fmt:message key='enter_reason'/>" required></textarea>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-12 col-sm-3 col-md-3 col-lg-2"></div>
                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                    <button name="submit" type="submit" value="Submit" class="btn btn-primary"><fmt:message key="submit_report"/></button>
                                </div>
                            </div>
                        </form>
                        <c:if test="${not empty sessionScope.message}">
                            <div class="alert alert-success">${sessionScope.message}</div>
                            <c:remove var="message" scope="session"/>
                        </c:if>
                        <c:if test="${not empty sessionScope.error}">
                            <div class="alert alert-danger">${sessionScope.error}</div>
                            <c:remove var="error" scope="session"/>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <footer>
            <div class="footer-top">
                <div class="pt-exebar">
                    <div class="container">
                        <div class="d-flex align-items-stretch">
                            <div class="pt-logo mr-auto">
                                <a href="home"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt=""/></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/magnific-popup/magnific-popup.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/counter/waypoints-min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/counter/counterup.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/imagesloaded/imagesloaded.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/masonry/masonry.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/masonry/filter.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/owl-carousel/owl.carousel.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>
</body>
</html>