<%-- 
    Document   : approveWithdrawal
    Created on : Mar 27, 2025
    Author     : [Your Name]
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="entity.User"%>

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
            .alert-info {
                color: #0c5460;
                background-color: #d1ecf1;
                border-color: #bee5eb;
                padding: 15px;
                margin-bottom: 20px;
                border: 1px solid transparent;
                border-radius: 4px;
            }
            .pagination a {
                margin: 0 5px;
                padding: 5px 10px;
                text-decoration: none;
            }
            .pagination a.current {
                background-color: #007bff;
                color: white;
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

        <!-- Main content -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title"><fmt:message key="request_withdrawal"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/admin/index"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                        <li><fmt:message key="request_withdrawal"/></li>
                    </ul>
                </div>

                <div class="widget-box">
                    <div class="wc-title">
                        <h4><fmt:message key="withdrawal_request_list"/></h4>
                    </div>
                    <div class="widget-inner">
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">${message}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form method="get" action="${pageContext.request.contextPath}/admin/approveWithdrawal" class="filter-form">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="searchField"><fmt:message key="search_by"/></label>
                                        <select name="searchField" id="searchField" class="form-control">
                                            <option value="TutorName" ${searchField == 'TutorName' ? 'selected' : ''}><fmt:message key="tutor_name"/></option>
                                            <option value="WithdrawStatus" ${searchField == 'WithdrawStatus' ? 'selected' : ''}><fmt:message key="status"/></option>
                                            <option value="RequestDate" ${searchField == 'RequestDate' ? 'selected' : ''}><fmt:message key="request_date"/></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="search"><fmt:message key="search_value"/></label>
                                        <input type="text" name="search" value="${search}" class="form-control" 
                                               placeholder="${searchField == 'RequestDate' ? 'VD: 15, 03/2025, 2025' : searchField == 'TutorName' ? 'VD: Nguyễn Văn A' : 'VD: Pending'}">
                                        <input type="hidden" name="sortBy" value="${sortBy}">
                                        <input type="hidden" name="sortOrder" value="${sortOrder}">
                                        <input type="submit" class="btn btn-success" value="<fmt:message key='search'/>">
                                    </div>
                                </div>
                            </div>
                        </form>

                        <c:if test="${empty requests}">
                            <div class="alert alert-info"><fmt:message key="no_withdrawal_requests"/></div>
                        </c:if>
                        <c:if test="${not empty requests}">
                            <div class="table-responsive">
                                <table class="table table-bordered table-striped">
                                    <thead>
                                        <tr>
                                            <th><fmt:message key="request_id"/></th>
                                            <th><fmt:message key="tutor_id"/></th>
                                            <th><fmt:message key="tutor_name"/></th>
                                            <th><fmt:message key="month"/></th>
                                            <th>
                                                <a href="${pageContext.request.contextPath}/admin/approveWithdrawal?sortBy=TotalEarningsAfterCommission&sortOrder=${sortBy == 'TotalEarningsAfterCommission' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&searchField=${searchField}">
                                                    <fmt:message key="total_earnings"/> (VND) ${sortBy == 'TotalEarningsAfterCommission' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                </a>
                                            </th>
                                            <th>
                                                <a href="${pageContext.request.contextPath}/admin/approveWithdrawal?sortBy=WithdrawStatus&sortOrder=${sortBy == 'WithdrawStatus' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&searchField=${searchField}">
                                                    <fmt:message key="status"/> ${sortBy == 'WithdrawStatus' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                </a>
                                            </th>
                                            <th><fmt:message key="content"/></th>
                                            <th>
                                                <a href="${pageContext.request.contextPath}/admin/approveWithdrawal?sortBy=RequestDate&sortOrder=${sortBy == 'RequestDate' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&searchField=${searchField}">
                                                    <fmt:message key="request_date"/> ${sortBy == 'RequestDate' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                </a>
                                            </th>
                                            <th><fmt:message key="admin_id"/></th>
                                            <th><fmt:message key="actions"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="request" items="${requests}">
                                            <tr>
                                                <td>${request.requestID}</td>
                                                <td>${request.tutorID}</td>
                                                <td>${request.tutorName}</td>
                                                <td>${request.month}</td>
                                                <td><fmt:formatNumber value="${request.totalEarningsAfterCommission}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ</td>
                                                <td><fmt:message key="${request.withdrawStatus.toLowerCase()}"/></td>
                                                <td>${request.content}</td>
                                                <td><fmt:formatDate value="${request.requestDate}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                                <td>${request.adminID == 0 ? '<fmt:message key="not_processed"/>' : request.adminID}</td>
                                                <td class="action-buttons">
                                                    <c:if test="${request.withdrawStatus == 'Pending'}">
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/approveWithdrawal" style="display:inline;">
                                                            <input type="hidden" name="requestID" value="${request.requestID}">
                                                            <input type="hidden" name="action" value="approve">
                                                            <input type="submit" class="btn btn-primary" value="<fmt:message key='approve'/>">
                                                        </form>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/approveWithdrawal" style="display:inline;">
                                                            <input type="hidden" name="requestID" value="${request.requestID}">
                                                            <input type="hidden" name="action" value="reject">
                                                            <input type="submit" class="btn btn-danger" value="<fmt:message key='reject'/>">
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${request.withdrawStatus != 'Pending'}">
                                                        <span><fmt:message key="processed"/></span>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Phân trang -->
                            <div class="pagination">
                                <c:if test="${totalPages > 1}">
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <a href="${pageContext.request.contextPath}/admin/approveWithdrawal?page=${i}&sortBy=${sortBy}&sortOrder=${sortOrder}&search=${search}&searchField=${searchField}"
                                           class="${i == currentPage ? 'current' : ''}">${i}</a>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </c:if>

                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/admin/index" class="btn btn-success"><fmt:message key="back_to_dashboard"/></a>
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