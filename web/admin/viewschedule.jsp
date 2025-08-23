<%-- 
    Document   : viewschedule
    Created on : Mar 22, 2025
    Author     : Heizxje
--%>
<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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

        <!-- Custom Styles -->
        <style>
            .table-responsive table {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            .table-responsive th, .table-responsive td {
                padding: 12px 20px;
                text-align: left;
                border: 1px solid #ddd;
            }
            .table-responsive th {
                background-color: #2196F3;
                color: white;
            }
            .table-responsive tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            .table-responsive tr:hover {
                background-color: #ddd;
            }
            .pagination {
                text-align: center;
                margin-top: 20px;
            }
            .pagination a {
                padding: 10px 20px;
                margin: 0 5px;
                text-decoration: none;
                background-color: #2196F3;
                color: white;
                border-radius: 5px;
                transition: background-color 0.3s;
            }
            .pagination a:hover {
                background-color: #1976D2;
            }
            .pagination a.active {
                background-color: #1976D2;
                font-weight: bold;
            }
            .pagination a.disabled {
                background-color: #ddd;
                cursor: not-allowed;
            }
            .action-links button {
                background-color: #2196F3;
                color: white;
                border: none;
                padding: 5px 10px;
                cursor: pointer;
            }
            .action-links button:hover {
                background-color: #1976D2;
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
                                <li><a href="${pageContext.request.contextPath}/admin/AdminListRated" class="ttr-material-button"><span class="ttr-label"><fmt:message key="tutor_reviews"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/RequestCV" class="ttr-material-button"><span class="ttr-label"><fmt:message key="status_cv"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/ViewBooking" class="ttr-material-button"><span class="ttr-label"><fmt:message key="booking_manage"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/AdminViewSchedule" class="ttr-material-button"><span class="ttr-label"><fmt:message key="view_schedule"/></span></a></li>
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
                                <li><a href="${pageContext.request.contextPath}/admin/ReportManager" class="ttr-material-button"><span class="ttr-label"><fmt:message key="report"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-credit-card"></i></span>
                                <span class="ttr-label"><fmt:message key="payment"/></span>
                                <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                            </a>
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/admin/approveWithdrawal" class="ttr-material-button"><span class="ttr-label"><fmt:message key="request_withdrawal"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/PaymentHistory" class="ttr-material-button"><span class="ttr-label"><fmt:message key="view_history_payment"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/systemRevenue" class="ttr-material-button"><span class="ttr-label"><fmt:message key="system_revenue"/></span></a></li>
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

        <!-- Main content -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title"><fmt:message key="view_schedule"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/admin/index"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                        <li><fmt:message key="view_schedule"/></li>
                    </ul>
                </div>
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="available_schedules"/></h4>
                            </div>
                            <div class="table-responsive">
                                <table>
                                    <thead>
                                        <tr>
                                            <th><fmt:message key="schedule_id"/></th>
                                            <th><fmt:message key="tutor_id"/></th>
                                            <th><fmt:message key="start_time"/></th>
                                            <th><fmt:message key="end_time"/></th>
                                            <th><fmt:message key="subject_id"/></th>
                                            <th><fmt:message key="is_booked"/></th>
                                            <th><fmt:message key="action"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="schedule" items="${schedules}">
                                            <tr>
                                                <td>${schedule.scheduleID}</td>
                                                <td>${schedule.tutorID}</td>
                                                <td><fmt:formatDate value="${schedule.startTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td><fmt:formatDate value="${schedule.endTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td>${schedule.subjectID}</td>
                                                <td>${schedule.booked ? fmt.message(key='yes') : fmt.message(key='no')}</td>
                                                <td class="action-links">
                                                    <form action="${pageContext.request.contextPath}/admin/ViewSchedule" method="POST" onsubmit="return confirmApprove()">
                                                        <input type="hidden" name="scheduleID" value="${schedule.scheduleID}">
                                                        <button type="submit"><fmt:message key="approve"/></button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty schedules}">
                                            <tr>
                                                <td colspan="7" class="text-center"><fmt:message key="no_schedules_found"/></td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                            <!-- Pagination -->
                            <div class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/admin/ViewSchedule?page=${currentPage - 1}"><fmt:message key="previous"/></a>
                                </c:if>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="${pageContext.request.contextPath}/admin/ViewSchedule?page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/admin/ViewSchedule?page=${currentPage + 1}"><fmt:message key="next"/></a>
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
        <script type="text/javascript">
                                                        function confirmApprove() {
                                                            return confirm("<fmt:message key='confirm_approve_schedule'/>");
                                                        }
        </script>
    </body>
</html>