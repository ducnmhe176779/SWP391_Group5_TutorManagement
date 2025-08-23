<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entity.User"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
        <!-- META -->
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

        <!-- FAVICONS ICON -->
        <link rel="icon" href="${pageContext.request.contextPath}/error-404.jsp" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE -->
        <title>G4 SmartTutor</title>

        <!-- MOBILE SPECIFIC -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

        <!-- CSS bổ sung cho thông báo -->
        <style>
            .alert-success {
                color: #155724;
                background-color: #d4edda;
                border-color: #c3e6cb;
                padding: 15px;
                margin-bottom: 20px;
                border: 1px solid transparent;
                border-radius: 4px;
            }
            .alert-danger {
                color: #721c24;
                background-color: #f8d7da;
                border-color: #f5c6cb;
                padding: 15px;
                margin-bottom: 20px;
                border: 1px solid transparent;
                border-radius: 4px;
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
        %>
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <!-- Header -->
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
                        <li><a href="${pageContext.request.contextPath}/admin/index" class="ttr-material-button ttr-submenu-toggle"><fmt:message key="home"/></a></li>
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

        <!-- Sidebar -->
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
                                <li><a href="AdminSubjectController" class="ttr-material-button"><span class="ttr-label"><fmt:message key="subject_management"/></span></a></li>
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

        <!-- Main Content -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title"><fmt:message key="admin_profile"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/admin/index"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                        <li><fmt:message key="admin_profile"/></li>
                    </ul>
                </div>
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="your_profile"/></h4>
                            </div>
                            <div class="widget-inner">
                                <div class="container">
                                    <div class="row">
                                        <div class="col-lg-3 col-md-4 col-sm-12 m-b30">
                                            <div class="profile-bx text-center">
                                                <div class="user-profile-thumb">
                                                    <img src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                                         alt="Avatar" 
                                                         onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'" />
                                                </div>
                                                <div class="profile-info">
                                                    <h4><%= user.getFullName()%></h4>
                                                    <span><%= user.getEmail()%></span>
                                                </div>
                                                <div class="profile-tabnav">
                                                    <ul class="nav nav-tabs">
                                                        <li class="nav-item">
                                                            <a class="nav-link active" data-toggle="tab" href="#profile-detail"><i class="ti-user"></i><fmt:message key="profile_detail"/></a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a class="nav-link" data-toggle="tab" href="#edit-profile"><i class="ti-pencil-alt"></i><fmt:message key="edit_profile"/></a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a class="nav-link" data-toggle="tab" href="#change-password"><i class="ti-lock"></i><fmt:message key="change_password"/></a>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-9 col-md-8 col-sm-12 m-b30">
                                            <div class="profile-content-bx">
                                                <div class="tab-content">
                                                    <!-- Profile Detail -->
                                                    <div class="tab-pane active" id="profile-detail">
                                                        <div class="profile-head">
                                                            <h3><fmt:message key="profile_detail"/></h3>
                                                        </div>
                                                        <form class="edit-profile">
                                                            <div>
                                                                <div class="form-group row" style="padding-left: 30px;padding-right: 10px;padding-top: 10px;">
                                                                    <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="email"/></label>
                                                                    <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                        <input class="form-control" type="email" value="<%= user.getEmail()%>" readonly>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                    <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="full_name"/></label>
                                                                    <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                        <input class="form-control" type="text" value="<%= user.getFullName()%>" readonly>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                    <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="phone"/></label>
                                                                    <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                        <input class="form-control" type="text" value="<%= user.getPhone()%>" readonly>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                    <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="date_of_birth"/></label>
                                                                    <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                        <input class="form-control" type="date" value="<%= user.getDob()%>" readonly>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                    <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="address"/></label>
                                                                    <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                        <input class="form-control" type="text" value="<%= user.getAddress()%>" readonly>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>

                                                    <!-- Edit Profile -->
                                                    <div class="tab-pane" id="edit-profile">
                                                        <div class="profile-head">
                                                            <h3><fmt:message key="edit_profile"/></h3>
                                                        </div>
                                                        <form class="edit-profile" action="adminprofile" method="POST" enctype="multipart/form-data">
                                                            <input type="hidden" name="action" value="editProfile">
                                                            <div class="form-group row" style="padding-left: 30px;padding-right: 10px;padding-top: 10px;">
                                                                <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="full_name"/></label>
                                                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                    <input class="form-control" type="text" name="fullName" value="<%= user.getFullName()%>">
                                                                </div>
                                                            </div>
                                                            <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="phone"/></label>
                                                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                    <input class="form-control" type="text" name="phone" value="<%= user.getPhone()%>">
                                                                </div>
                                                            </div>
                                                            <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="date_of_birth"/></label>
                                                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                    <input class="form-control" type="date" name="dob" value="<%= user.getDob()%>">
                                                                </div>
                                                            </div>
                                                            <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="avatar"/></label>
                                                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                    <input class="form-control" type="file" name="avatar" accept="image/*">
                                                                </div>
                                                            </div>
                                                            <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="address"/></label>
                                                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                    <input class="form-control" type="text" name="address" value="<%= user.getAddress()%>">
                                                                </div>
                                                            </div>
                                                            <div class="row" style="padding-left: 30px;padding-right: 10px;padding-bottom: 10px;">
                                                                <div class="col-12 col-sm-3 col-md-3 col-lg-2"></div>
                                                                <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                    <button type="submit" class="btn btn-primary"><fmt:message key="save_changes"/></button>
                                                                    <button type="reset" class="btn btn-secondary"><fmt:message key="cancel"/></button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>

                                                    <!-- Change Password -->
                                                    <div class="tab-pane" id="change-password">
                                                        <div class="profile-head">
                                                            <h3><fmt:message key="change_password"/></h3>
                                                        </div>
                                                        <form class="edit-profile" action="adminprofile" method="POST">
                                                            <input type="hidden" name="action" value="changePassword">
                                                            <div class="form-group row" style="padding-left: 30px;padding-right: 10px;padding-top: 10px;">
                                                                <label class="col-12 col-sm-4 col-md-4 col-lg-3 col-form-label"><fmt:message key="current_password"/></label>
                                                                <div class="col-12 col-sm-8 col-md-8 col-lg-7">
                                                                    <input class="form-control" type="password" name="currentPassword" required>
                                                                </div>
                                                            </div>
                                                            <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                <label class="col-12 col-sm-4 col-md-4 col-lg-3 col-form-label"><fmt:message key="new_password"/></label>
                                                                <div class="col-12 col-sm-8 col-md-8 col-lg-7">
                                                                    <input class="form-control" type="password" name="newPassword" required>
                                                                </div>
                                                            </div>
                                                            <div class="form-group row" style="padding-left: 30px;padding-right: 10px;">
                                                                <label class="col-12 col-sm-4 col-md-4 col-lg-3 col-form-label"><fmt:message key="confirm_new_password"/></label>
                                                                <div class="col-12 col-sm-8 col-md-8 col-lg-7">
                                                                    <input class="form-control" type="password" name="confirmPassword" required>
                                                                </div>
                                                            </div>
                                                            <div class="row" style="padding-left: 30px;padding-right: 10px;padding-bottom: 10px;">
                                                                <div class="col-12 col-sm-4 col-md-4 col-lg-3"></div>
                                                                <div class="col-12 col-sm-8 col-md-8 col-lg-7">
                                                                    <button type="submit" class="btn btn-primary"><fmt:message key="save_changes"/></button>
                                                                    <button type="reset" class="btn btn-secondary"><fmt:message key="cancel"/></button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
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
        <script src="${pageContext.request.contextPath}/assets/vendors/calendar/moment.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>
        <script>
            <% if (session.getAttribute("message") != null || session.getAttribute("error") != null) { %>
            <% if ("changePassword".equals(request.getParameter("action"))) { %>
            $('#change-password').tab('show');
            <% } else { %>
            $('#edit-profile').tab('show');
            <% } %>
            <% }%>
        </script>
    </body>
</html>