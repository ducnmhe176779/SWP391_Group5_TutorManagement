<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <meta name="description" content="G5 SmartTutor : Smart tutor, effective learning." />
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
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

        <!-- Thêm style cho thông báo -->
        <style>
            .message {
                color: green;
                margin-bottom: 10px;
                font-weight: bold;
            }
            .error {
                color: red;
                margin-bottom: 10px;
                font-weight: bold;
            }
            
            /* Style cho bảng - thay đổi màu từ tím sang xanh */
            .table {
                background-color: #fff;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .table thead th {
                background-color: #007bff !important; /* Màu xanh thay vì tím */
                color: white !important;
                border: none !important;
                padding: 15px 12px !important;
                font-weight: 600 !important;
                text-transform: uppercase !important;
                font-size: 14px !important;
                letter-spacing: 0.5px !important;
            }
            
            .table tbody tr {
                transition: all 0.3s ease;
            }
            
            .table tbody tr:hover {
                background-color: #f8f9ff !important; /* Màu xanh nhạt khi hover */
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,123,255,0.1);
            }
            
            .table tbody td {
                padding: 15px 12px !important;
                border-bottom: 1px solid #e9ecef !important;
                vertical-align: middle !important;
            }
            
            /* Style cho nút trong bảng */
            .btn-update {
                background-color: #007bff !important;
                border-color: #007bff !important;
                color: white !important;
                padding: 8px 16px !important;
                border-radius: 4px !important;
                text-decoration: none !important;
                display: inline-block !important;
                margin-right: 8px !important;
                transition: all 0.3s ease !important;
            }
            
            .btn-update:hover {
                background-color: #0056b3 !important;
                border-color: #0056b3 !important;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,123,255,0.3);
            }
            
            .btn-deactivate {
                background-color: #6c757d !important;
                border-color: #6c757d !important;
                color: white !important;
                padding: 8px 16px !important;
                border-radius: 4px !important;
                text-decoration: none !important;
                display: inline-block !important;
                transition: all 0.3s ease !important;
            }
            
            .btn-deactivate:hover {
                background-color: #545b62 !important;
                border-color: #545b62 !important;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(108,117,125,0.3);
            }
            
            /* Style cho nút Add Subject */
            .btn-add-subject {
                background-color: #007bff !important;
                border-color: #007bff !important;
                color: white !important;
                padding: 12px 24px !important;
                border-radius: 6px !important;
                text-decoration: none !important;
                display: inline-block !important;
                font-weight: 600 !important;
                transition: all 0.3s ease !important;
                margin-bottom: 20px !important;
            }
            
            .btn-add-subject:hover {
                background-color: #0056b3 !important;
                border-color: #0056b3 !important;
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(0,123,255,0.3);
                color: white !important;
                text-decoration: none !important;
            }
            
            /* Style cho phân trang */
            .pagination-info {
                margin-top: 20px;
                text-align: center;
            }
            
            .pagination-stats {
                margin-bottom: 15px;
                color: #666;
                font-size: 14px;
            }
            
            .pagination-controls {
                display: flex;
                justify-content: center;
                align-items: center;
                flex-wrap: wrap;
                gap: 5px;
            }
            
            .pagination-controls .btn {
                padding: 8px 12px;
                border: 1px solid #ddd;
                background: #fff;
                color: #333;
                text-decoration: none;
                border-radius: 4px;
                transition: all 0.3s ease;
            }
            
            .pagination-controls .btn:hover {
                background: #f8f9fa;
                border-color: #007bff;
                color: #007bff;
            }
            
            .pagination-controls .btn-primary {
                background: #007bff;
                border-color: #007bff;
                color: #fff;
            }
            
            .pagination-controls .btn-primary:hover {
                background: #0056b3;
                border-color: #0056b3;
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

        <!-- Sidebar -->
        <div class="ttr-sidebar">
            <div class="ttr-sidebar-wrapper content-scroll">
                <div class="ttr-sidebar-logo">
                    <a href="${pageContext.request.contextPath}/staff/dashboard"><img alt="" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27"></a>
                    <div class="ttr-sidebar-toggle-button">
                        <i class="ti-arrow-left"></i>
                    </div>
                </div>
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
            </div>
        </div>

        <!-- Main content -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title"><fmt:message key="subject_management"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                        <li><fmt:message key="subject_management"/></li>
                    </ul>
                </div>
                <div class="row">
                    <!-- Bảng 1: Danh sách môn học -->
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="subject_list"/></h4>
                                <a href="${pageContext.request.contextPath}/staff/SubjectController?service=addSubject" class="btn btn-add-subject"><fmt:message key="add_subject"/></a>
                            </div>
                            <!-- Hiển thị thông báo -->
                            <c:if test="${not empty sessionScope.message}">
                                <div class="message">${sessionScope.message}</div>
                                <c:remove var="message" scope="session" />
                            </c:if>
                            <c:if test="${not empty sessionScope.error}">
                                <div class="error">${sessionScope.error}</div>
                                <c:remove var="error" scope="session" />
                            </c:if>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><fmt:message key="id"/></th>
                                            <th><fmt:message key="subject_name"/></th>
                                            <th><fmt:message key="description"/></th>
                                            <th><fmt:message key="status"/></th>
                                            <th><fmt:message key="actions"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="subject" items="${subjectList}">
                                            <tr>
                                                <td>${subject.subjectID}</td>
                                                <td>${subject.subjectName}</td>
                                                <td>${subject.description}</td>
                                                <td><fmt:message key="${subject.status == 'Active' ? 'active' : 'inactive'}"/></td>
                                                <td class="action-links">
                                                    <a href="${pageContext.request.contextPath}/staff/SubjectController?service=updateSubject&subjectID=${subject.subjectID}" class="btn btn-update"><fmt:message key="update"/></a>
                                                    <c:if test="${subject.status == 'Active'}">
                                                        <a href="${pageContext.request.contextPath}/staff/SubjectController?service=deleteSubject&subjectID=${subject.subjectID}" class="btn btn-deactivate" onclick="return confirm('<fmt:message key="confirm_deactivate_subject"/> ${subject.subjectID}?')"><fmt:message key="deactivate"/></a>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <c:if test="${empty subjectList}">
                                    <p class="error"><fmt:message key="no_subjects_found"/></p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <!-- Bảng 2: Danh sách Tutor-Subject với UserName -->
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="tutor_subject_list"/></h4>
                            </div>
                            <div class="widget-inner">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><fmt:message key="tutor_id"/></th>
                                            <th><fmt:message key="username"/></th>
                                            <th><fmt:message key="subject_id"/></th>
                                            <th><fmt:message key="description"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="tutorSubject" items="${tutorSubjectList}">
                                            <tr>
                                                <td>${tutorSubject.tutorID}</td>
                                                <td>${tutorSubject.userName}</td>
                                                <td>${tutorSubject.subjectID}</td>
                                                <td>${tutorSubject.description}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <c:if test="${empty tutorSubjectList}">
                                    <p class="error"><fmt:message key="no_tutor_subjects_found"/></p>
                                </c:if>
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
        <script src="${pageContext.request.contextPath}/assets/vendors/calendar/moment.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>
    </body>
</html>
