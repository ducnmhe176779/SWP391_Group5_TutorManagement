<%@page import="entity.Payment"%>
<%@page import="entity.HistoryLog"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="entity.User, java.util.List, java.util.ArrayList, java.util.Map"%>

<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />
        <meta name="description" content="G5 SmartTutor : Smart tutor, effective learning." />
        <meta property="og:title" content="G5 SmartTutor : Smart tutor, effective learning." />
        <meta property="og:description" content="G5 SmartTutor : Smart tutor, effective learning." />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <link rel="icon" href="${pageContext.request.contextPath}/error-404.jsp" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <title>G5 SmartTutor</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

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
            .row {
                display: flex;
                flex-wrap: wrap;
                margin-right: -15px;
                margin-left: -15px;
            }
            .col-lg-4 {
                flex: 0 0 33.333333%;
                max-width: 33.333333%;
                padding-right: 15px;
                padding-left: 15px;
                box-sizing: border-box;
            }
            .col-md-6, .col-lg-3, .col-xl-3, .col-sm-6, .col-12 {
                padding-right: 15px;
                padding-left: 15px;
                box-sizing: border-box;
            }
            .widget-box {
                background: #fff;
                border: 1px solid #e5e5e5;
                border-radius: 4px;
                box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
                margin-bottom: 30px;
            }
            .wc-title {
                padding: 15px;
                border-bottom: 1px solid #e5e5e5;
            }
            .widget-inner {
                padding: 15px;
            }
            .m-b30 {
                margin-bottom: 30px;
            }
            .wc-stats, .counter, .wc-number {
                font-size: 14px !important;
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
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
            Double totalProfit = (Double) request.getAttribute("totalProfit");
            if (totalProfit == null) {
                totalProfit = 0.0;
            }
            Integer totalRatings = (Integer) request.getAttribute("totalRatings");
            if (totalRatings == null) {
                totalRatings = 0;
            }
            Integer totalUsers = (Integer) request.getAttribute("totalUsers");
            if (totalUsers == null) {
                totalUsers = 0;
            }
            Integer totalBookings = (Integer) request.getAttribute("totalBookings");
            if (totalBookings == null) {
                totalBookings = 0;
            }
        %>
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
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
                        <a href="${pageContext.request.contextPath}/admin/index" class="ttr-logo">
                            <img class="ttr-logo-mobile" alt="" src="${pageContext.request.contextPath}/assets/images/logo-mobile.png" width="30" height="30">
                            <img class="ttr-logo-desktop" alt="" src="${pageContext.request.contextPath}/assets/images/logo-white.png" width="160" height="27">
                        </a>
                    </div>
                </div>
                <div class="ttr-header-menu">
                    <ul class="ttr-header-navigation">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/index" class="ttr-material-button ttr-submenu-toggle"><fmt:message key="home"/></a>
                        </li>
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
                            <a href="${pageContext.request.contextPath}/admin/adminprofile" class="ttr-material-button ttr-submenu-toggle">
                                <span class="ttr-user-avatar">
                                    <img alt="" 
                                         src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                         width="32" height="32"
                                         onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                </span>
                            </a>
                            <div class="ttr-header-submenu">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/admin/adminprofile"><fmt:message key="my_profile"/></a></li>
                                    <li><a href="${pageContext.request.contextPath}/logout"><fmt:message key="logout"/></a></li>
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
                <div class="ttr-sidebar-logo">
                    <a href="${pageContext.request.contextPath}/admin/index"><img alt="" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27"></a>
                    <div class="ttr-sidebar-toggle-button">
                        <i class="ti-arrow-left"></i>
                    </div>
                </div>
                <nav class="ttr-sidebar-navi">
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/index" class="ttr-material-button">
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
                                <li><a href="${pageContext.request.contextPath}/admin/TutorList" class="ttr-material-button"><span class="ttr-label"><fmt:message key="tutor_list"/></span></a></li>
                                <li><a href="AdminListRated" class="ttr-material-button"><span class="ttr-label"><fmt:message key="tutor_reviews"/></span></a></li>
                                <li><a href="RequestCV" class="ttr-material-button"><span class="ttr-label"><fmt:message key="status_cv"/></span></a></li>
                                <li><a href="ViewBooking" class="ttr-material-button"><span class="ttr-label"><fmt:message key="booking_manage"/></span></a></li>
                                <li><a href="AdminViewSchedule" class="ttr-material-button"><span class="ttr-label"><fmt:message key="view_schedule"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/AdminSubjectController" class="ttr-material-button"><span class="ttr-label"><fmt:message key="subject_management"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-user"></i></span>
                                <span class="ttr-label"><fmt:message key="staff_management"/></span>
                                <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                            </a>
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/admin/StaffList" class="ttr-material-button"><span class="ttr-label"><fmt:message key="staff_list"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/StaffManage" class="ttr-material-button"><span class="ttr-label"><fmt:message key="add_new_staff"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-id-badge"></i></span>
                                <span class="ttr-label"><fmt:message key="user_management"/></span>
                                <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                            </a>
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/admin/UserList" class="ttr-material-button"><span class="ttr-label"><fmt:message key="user_list"/></span></a></li>
                                <li><a href="ReportManager" class="ttr-material-button"><span class="ttr-label"><fmt:message key="report"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-credit-card"></i></span>
                                <span class="ttr-label"><fmt:message key="payment"/></span>
                                <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                            </a>
                            <ul>
                                <li><a href="approveWithdrawal" class="ttr-material-button"><span class="ttr-label"><fmt:message key="request_withdrawal"/></span></a></li>
                                <li><a href="PaymentHistory" class="ttr-material-button"><span class="ttr-label"><fmt:message key="view_history_payment"/></span></a></li>
                                <li><a href="systemRevenue" class="ttr-material-button"><span class="ttr-label"><fmt:message key="system_revenue"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/historyLog" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-clipboard"></i></span>
                                <span class="ttr-label"><fmt:message key="history_log"/></span>
                            </a>
                        </li>
                        <li class="ttr-seperate"></li>
                    </ul>
                </nav>
            </div>
        </div>
        <!-- Left sidebar menu end -->

        <!-- Main container start -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title"><fmt:message key="dashboard"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/admin/index"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
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
                <!-- Card -->
                <div class="row">
                    <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                        <div class="widget-card widget-bg1">
                            <div class="wc-item">
                                <h4 class="wc-title"><fmt:message key="total_payments"/></h4>
                                <span class="wc-des"><fmt:message key="all_completed_payments"/></span>
                                <%@ page import="java.text.DecimalFormat" %>
                                <%
                                    DecimalFormat df = new DecimalFormat("#,###");
                                    String formattedProfit = df.format((long) totalProfit.doubleValue());
                                %>
                                <span class="wc-stats" style="top: 30px;">
                                    VND<span class="counter"><%= formattedProfit%></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                        <div class="widget-card widget-bg2">
                            <div class="wc-item">
                                <h4 class="wc-title"><fmt:message key="total_rating"/></h4>
                                <span class="wc-des"><fmt:message key="all_tutor_ratings"/></span>
                                <span class="wc-stats counter" style="top: 30px;">
                                    <%= totalRatings%>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                        <div class="widget-card widget-bg3">
                            <div class="wc-item">
                                <h4 class="wc-title"><fmt:message key="total_booking"/></h4>
                                <span class="wc-des"><fmt:message key="confirmed_completed"/></span>
                                <span class="wc-stats counter" style="top: 30px;">
                                    <%= totalBookings%>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                        <div class="widget-card widget-bg4">
                            <div class="wc-item">
                                <h4 class="wc-title"><fmt:message key="total_users"/></h4>
                                <span class="wc-des"><fmt:message key="all_registered_users"/></span>
                                <span class="wc-stats counter" style="top: 30px;">
                                    <%= totalUsers%>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Card END -->
                <div class="row">
                    <!-- History Log -->
                    <div class="col-lg-4 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="history_log"/></h4>
                            </div>
                            <div class="widget-inner">
                                <div class="noti-box-list">
                                    <ul>
                                        <%
                                            List<HistoryLog> logs = (List<HistoryLog>) request.getAttribute("logs");
                                            if (logs == null) {
                                                logs = new ArrayList<>();
                                            }
                                            int maxLogs = Math.min(5, logs.size());
                                            for (int i = 0; i < maxLogs; i++) {
                                                HistoryLog log = logs.get(i);
                                                String iconClass = "fa fa-info-circle";
                                                String bgClass = "dashbg-gray";
                                                String actionText = log.getActionType() != null ? log.getActionType() : "Unknown";
                                                switch (actionText.toLowerCase()) {
                                                    case "login":
                                                        iconClass = "fa fa-sign-in";
                                                        bgClass = "dashbg-primary";
                                                        break;
                                                    case "logout":
                                                        iconClass = "fa fa-sign-out";
                                                        bgClass = "dashbg-red";
                                                        break;
                                                    case "create":
                                                        iconClass = "fa fa-plus";
                                                        bgClass = "dashbg-green";
                                                        break;
                                                    case "update":
                                                        iconClass = "fa fa-edit";
                                                        bgClass = "dashbg-yellow";
                                                        break;
                                                    case "delete":
                                                        iconClass = "fa fa-trash";
                                                        bgClass = "dashbg-red";
                                                        break;
                                                    default:
                                                        iconClass = "fa fa-info-circle";
                                                        bgClass = "dashbg-gray";
                                                        break;
                                                }
                                        %>
                                        <li>
                                            <span class="notification-icon <%= bgClass%>">
                                                <i class="<%= iconClass%>"></i>
                                            </span>
                                            <span class="notification-text">
                                                <span><%= log.getFullName() != null ? log.getFullName() : "Anonymous"%></span> 
                                                <%= actionText%>: <%= log.getDetails() != null ? log.getDetails() : "No details"%>
                                            </span>
                                            <span class="notification-time">
                                                <span><%= log.getLogDate() != null ? new java.text.SimpleDateFormat("dd MMM").format(log.getLogDate()) : "N/A"%></span>
                                            </span>
                                        </li>
                                        <%
                                            }
                                            if (maxLogs == 0) {
                                        %>
                                        <li><fmt:message key="no_history_logs"/></li>
                                            <% } %>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- New Users List -->
                    <div class="col-lg-4 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="new_users"/></h4>
                            </div>
                            <div class="widget-inner">
                                <div class="new-user-list">
                                    <ul>
                                        <%
                                            for (User newUser : newUsers) {
                                                String roleName = "";
                                                switch (newUser.getRoleID()) {
                                                    case 1:
                                                        roleName = "Admin";
                                                        break;
                                                    case 2:
                                                        roleName = "User";
                                                        break;
                                                    case 3:
                                                        roleName = "Tutor";
                                                        break;
                                                    case 4:
                                                        roleName = "Staff";
                                                        break;
                                                    default:
                                                        roleName = "Unknown";
                                                        break;
                                                }
                                        %>
                                        <li>
                                            <span class="new-users-pic">
                                                <img src="${pageContext.request.contextPath}/<%= newUser.getAvatar() != null ? newUser.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                                     alt="" 
                                                     onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'" />
                                            </span>
                                            <span class="new-users-text">
                                                <a href="${pageContext.request.contextPath}/admin/UserList?userId=<%= newUser.getUserID()%>" class="new-users-name"><%= newUser.getFullName()%> </a>
                                                <span class="new-users-info"><%= roleName%></span>
                                            </span>
                                            <span class="new-users-btn">
                                                <a href="${pageContext.request.contextPath}/admin/UserList?userId=<%= newUser.getUserID()%>" class="btn button-sm outline"><fmt:message key="view"/></a>
                                            </span>
                                        </li>
                                        <% } %>
                                        <% if (newUsers.isEmpty()) { %>
                                        <li><fmt:message key="no_new_users"/></li>
                                            <% }%>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- History Payment -->
                    <div class="col-lg-4 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="history_payment"/></h4>
                            </div>
                            <div class="widget-inner">
                                <div class="orders-list">
                                    <ul>
                                        <%
                                            List<Payment> recentPayments = (List<Payment>) request.getAttribute("recentPayments");
                                            if (recentPayments == null) {
                                                recentPayments = new ArrayList<>();
                                            }
                                            int maxPayments = Math.min(5, recentPayments.size());
                                            for (int i = 0; i < maxPayments; i++) {
                                                Payment payment = recentPayments.get(i);
                                                String statusClass = "red";
                                                String statusText = "Unpaid";
                                                if ("Completed".equalsIgnoreCase(payment.getStatus())) {
                                                    statusClass = "green";
                                                    statusText = "Paid";
                                                }
                                        %>
                                        <li>
                                            <span class="orders-title">
                                                <a href="PaymentHistory" class="orders-title-name"><fmt:message key="payment"/> #<%= payment.getPaymentID()%></a>
                                                <span class="orders-info"><fmt:message key="booking"/> #<%= payment.getBookingID()%> | <fmt:message key="date"/> <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(payment.getPaymentDate())%></span>
                                            </span>
                                            <span class="orders-btn">
                                                <a href="PaymentHistory" class="btn button-sm <%= statusClass%>"><%= statusText%></a>
                                            </span>
                                        </li>
                                        <%
                                            }
                                            if (maxPayments == 0) {
                                        %>
                                        <li><fmt:message key="no_recent_payments"/></li>
                                            <% }%>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div class="ttr-overlay"></div>

        <!-- External JavaScripts -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/magnific-popup/magnific-popup.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/counter/waypoints-min.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/counter/counterup.min.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/imagesloaded/imagesloaded.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/masonry/masonry.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/masonry/filter.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/owl-carousel/owl.carousel.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/js/functions.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/js/admin.js?ts=<%= System.currentTimeMillis()%>"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js?ts=<%= System.currentTimeMillis()%>"></script>
    </body>
</html>
