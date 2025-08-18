<%@page import="entity.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="java.util.List, java.util.ArrayList"%>

<!DOCTYPE html>
<html lang="${not empty sessionScope.locale ? sessionScope.locale : 'en'}">

<head>
    <!-- META -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />

    <!-- DESCRIPTION -->
    <meta name="description" content="G5 SmartTutor : Smart tutor, effective learning." />

    <!-- OG -->
    <meta property="og:title" content="G5 SmartTutor : Smart tutor, effective learning." />
    <meta property="og:description" content="G5 SmartTutor : Smart tutor, effective learning." />
    <meta property="og:image" content="" />
    <meta name="format-detection" content="telephone=no">

    <!-- FAVICONS ICON -->
    <link rel="icon" href="${pageContext.request.contextPath}/error-404.jsp" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

    <!-- PAGE TITLE -->
        <title>G5 SmartTutor</title>

    <!-- MOBILE SPECIFIC -->
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    
    <!-- Custom Blue Color Override -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/custom-blue.css">

    <!-- CSS cho thông báo -->
    <style>
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-success {
            color: #3c763d;
            background-color: #dff0d8;
            border-color: #d6e9c6;
        }
        .alert-danger {
            color: #a94442;
            background-color: #f2dede;
            border-color: #ebccd1;
        }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar staff">
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String message = (String) session.getAttribute("message");
        String error = (String) request.getAttribute("error");
        List<User> newUsers = (List<User>) request.getAttribute("newUsers");
        if (newUsers == null) {
            newUsers = new ArrayList<>();
        }
    %>
    <fmt:setLocale value="${not empty sessionScope.locale ? sessionScope.locale : 'en'}"/>
    <fmt:setBundle basename="messages"/>

    <!-- Header start -->
        <header class="ttr-header">
            <div class="ttr-header-wrapper">
                <div class="ttr-toggle-sidebar ttr-material-button">
                    <i class="ti-close ttr-open-icon"></i>
                    <i class="ti-menu ttr-close-icon"></i>
                </div>
                <div class="ttr-logo-box">
                    <div>
                        <a href="${pageContext.request.contextPath}/staff/dashboard" class="ttr-logo">
                            <img class="ttr-logo-mobile" alt="" src="${pageContext.request.contextPath}/assets/images/logo-mobile.png" width="30" height="30">
                            <img class="ttr-logo-desktop" alt="" src="${pageContext.request.contextPath}/assets/images/logo-white.png" width="160" height="27">
                        </a>
                    </div>
                </div>
                <div class="ttr-header-menu">
                    <ul class="ttr-header-navigation">
                        <li><a href="${pageContext.request.contextPath}/staff/dashboard" class="ttr-material-button ttr-submenu-toggle"><fmt:message key="home"/></a></li>
                        <li>
                            <a href="#" class="ttr-material-button ttr-submenu-toggle"><fmt:message key="language"/> <i class="fa fa-angle-down"></i></a>
                            <div class="ttr-header-submenu">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/LanguageServlet?lang=vi"><fmt:message key="vietnamese"/></a></li>
                                    <li><a href="${pageContext.request.contextPath}/LanguageServlet?lang=en"><fmt:message key="english"/></a></li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="ttr-header-right ttr-with-seperator">
                    <ul class="ttr-header-navigation">
                        <li>
                            <a href="${pageContext.request.contextPath}/staff/dashboard" class="ttr-material-button ttr-submenu-toggle">
                                <span class="ttr-user-avatar">
                                    <img alt="" 
                                         src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                         width="32" height="32"
                                         onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                </span>
                            </a>
                            <div class="ttr-header-submenu">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/staff/staffprofile">My Profile</a></li>
                                    <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </header>
    <!-- Header end -->

    <!-- Left sidebar menu start -->
    <div class="ttr-sidebar">
        <div class="ttr-sidebar-wrapper content-scroll">
            <!-- Side menu logo start -->
            <div class="ttr-sidebar-logo">
                <a href="${pageContext.request.contextPath}/staff/dashboard"><img alt="" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27"></a>
                <div class="ttr-sidebar-toggle-button">
                    <i class="ti-arrow-left"></i>
                </div>
            </div>
            <!-- Side menu logo end -->
            <!-- Sidebar menu start -->
            <nav class="ttr-sidebar-navi">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/staff/dashboard" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-home"></i></span>
                            <span class="ttr-label"><fmt:message key="dashboard"/></span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-briefcase"></i></span>
                            <span class="ttr-label"><fmt:message key="tutor_management"/></span>
                            <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                        </a>
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/staff/ViewSchedule" class="ttr-material-button"><span class="ttr-label"><fmt:message key="view_schedule"/></span></a></li>
                            <li><a href="${pageContext.request.contextPath}/staff/ListRated" class="ttr-material-button"><span class="ttr-label"><fmt:message key="tutor_reviews"/></span></a></li>
                            <li><a href="${pageContext.request.contextPath}/staff/SubjectController?service=listSubject" class="ttr-material-button"><span class="ttr-label"><fmt:message key="control_subject"/></span></a></li>
                        </ul>
                    </li>
                    <li>
                        <a href="#" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-book"></i></span>
                            <span class="ttr-label"><fmt:message key="content_management"/></span>
                            <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                        </a>
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/staff/BlogController?service=listBlog" class="ttr-material-button"><span class="ttr-label"><fmt:message key="blog"/></span></a></li>
                            <li><a href="${pageContext.request.contextPath}/staff/BlogController?service=addBlog" class="ttr-material-button"><span class="ttr-label"><fmt:message key="add_blog"/></span></a></li>
                        </ul>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/staff/historyLog" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-clipboard"></i></span>
                            <span class="ttr-label"><fmt:message key="user_tutor_logs"/></span>
                        </a>
                    </li>
                    <li class="ttr-seperate"></li>
                </ul>
            </nav>
            <!-- Sidebar menu end -->
        </div>
    </div>
    <!-- Left sidebar menu end -->

    <!-- Main container start -->
    <main class="ttr-wrapper">
        <div class="container-fluid">
            <div class="db-breadcrumb">
                <h4 class="breadcrumb-title"><fmt:message key="staff_dashboard"/></h4>
                <ul class="db-breadcrumb-list">
                    <li><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                    <li><fmt:message key="dashboard"/></li>
                </ul>
            </div>
            <!-- Hiển thị thông báo -->
            <% if (message != null) {%>
            <div class="alert alert-success">
                <%= message%>
            </div>
            <% session.removeAttribute("message"); %>
            <% } %>
            <% if (error != null) {%>
            <div class="alert alert-danger">
                <%= error%>
            </div>
            <% request.removeAttribute("error"); %>
            <% }%>
            <div class="row">
                <!-- New Tutors -->
                <div class="col-lg-6 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4><fmt:message key="new_tutors"/></h4>
                        </div>
                        <div class="widget-inner">
                            <div class="new-user-list">
                                <ul>
                                    <%
                                        for (User newUser : newUsers) {
                                            String roleName = "Tutor"; // Vì getNewUsers() chỉ lấy RoleID = 2
                                    %>
                                    <li>
                                        <span class="new-users-pic">
                                            <img src="${pageContext.request.contextPath}/<%= newUser.getAvatar() != null ? newUser.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                                 alt="" 
                                                 onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'" />
                                        </span>
                                        <span class="new-users-text">
                                            <a href="${pageContext.request.contextPath}/profile?userID=<%= newUser.getUserID()%>" class="new-users-name"><%= newUser.getFullName()%></a>
                                            <span class="new-users-info"><%= roleName%> - <%= newUser.getIsActive() == 1 ? "Active" : "Inactive" %></span>
                                        </span>
                                        <span class="new-users-btn">
                                            <a href="${pageContext.request.contextPath}/profile?userID=<%= newUser.getUserID()%>" class="btn button-sm outline"><fmt:message key="view"/></a>
                                        </span>
                                    </li>
                                    <% } %>
                                    <% if (newUsers.isEmpty()) { %>
                                    <li><fmt:message key="no_new_tutors_found"/></li>
                                        <% }%>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Placeholder for future widget -->
                <div class="col-lg-6 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4><fmt:message key="upcoming_tasks"/></h4>
                        </div>
                        <div class="widget-inner">
                            <p><fmt:message key="placeholder_upcoming_tasks"/></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <div class="ttr-overlay"></div>

    <!-- External JavaScripts -->
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
    <script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/chart/chart.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>
</body>
</html>
