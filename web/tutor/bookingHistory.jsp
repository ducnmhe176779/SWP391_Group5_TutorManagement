<%-- 
    Document   : bookingHistory
    Created on : Mar 27, 2025
    Author     : [minht]
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="entity.User"%>

<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />
    <meta name="description" content="G4 SmartTutor: Empowering Tutors for Effective Teaching" />
    <meta property="og:title" content="G4 SmartTutor: Empowering Tutors for Effective Teaching" />
    <meta property="og:description" content="G4 SmartTutor: Empowering Tutors for Effective Teaching" />
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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/layers.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/settings.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/navigation.css">
   
</head>
<body id="bg">
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleID() != 3) { // RoleID 3 là tutor
            response.sendRedirect("login");
            return;
        }
    %>
    <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
    <fmt:setBundle basename="messages"/>

    <div class="page-wraper">
        <!-- Header từ indextutor.jsp (giữ nguyên) -->
        <header class="header rs-nav header-transparent">
            <div class="top-bar">
                <div class="container">
                    <div class="row d-flex justify-content-between">
                        <div class="topbar-left">
                            <ul>
                                <li><a href="#"><i class="fa fa-question-circle"></i><fmt:message key="ask_a_question"/></a></li>
                                <li><a href="#"><i class="fa fa-envelope-o"></i><fmt:message key="support_email"/></a></li>
                            </ul>
                        </div>
                        <div class="topbar-right">
                            <ul>
                                <li>
                                    <select class="header-lang-bx" onchange="window.location.href = '${pageContext.request.contextPath}/LanguageServlet?lang=' + this.value;">
                                        <option value="en" ${sessionScope.locale == null || sessionScope.locale == 'en' ? 'selected' : ''}><fmt:message key="english"/></option>
                                        <option value="vi" ${sessionScope.locale == 'vi' ? 'selected' : ''}><fmt:message key="vietnamese"/></option>
                                    </select>
                                </li>
                                <li>
                                    <div class="ttr-header-submenu">
                                        <ul>
                                            <li>
                                                <a href="tutorprofile" class="ttr-material-button ttr-submenu-toggle">
                                                    <span class="ttr-user-avatar">
                                                        <img alt="" 
                                                             src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                                             width="32" height="32"
                                                             onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                                    </span>
                                                </a>
                                            </li>
                                            <li><a href="tutorprofile"><fmt:message key="my_profile"/></a></li>
                                            <li><a href="ViewTutorSchedule"><fmt:message key="view_schedule"/></a></li>
                                            <li><a href="${pageContext.request.contextPath}/logout"><fmt:message key="logout"/></a></li>
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
                            <a href="indextutor.jsp"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt=""></a>
                        </div>
                        <button class="navbar-toggler collapsed menuicon justify-content-end" type="button" data-toggle="collapse" data-target="#menuDropdown" aria-controls="menuDropdown" aria-expanded="false" aria-label="Toggle navigation">
                            <span></span><span></span><span></span>
                        </button>
                        <div class="nav-search-bar">
                            <form action="#">
                                <input name="search" value="" type="text" class="form-control" placeholder="<fmt:message key='type_to_search'/>">
                                <span><i class="ti-search"></i></span>
                            </form>
                            <span id="search-remove"><i class="ti-close"></i></span>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Nội dung chính của bookingHistory.jsp -->
        <div class="page-content bg-white">
            <!-- Page banner -->
            <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/banner/banner1.jpg);">
                <div class="container">
                    <div class="page-banner-entry">
                        <h1 class="text-white">Lịch Sử Booking</h1>
                    </div>
                </div>
            </div>

            <!-- Breadcrumb -->
            <div class="breadcrumb-row">
                <div class="container">
                    <ul class="list-inline">
                        <li><a href="indextutor.jsp"><fmt:message key="home"/></a></li>
                        <li><fmt:message key="withdraw"/></li>
                    </ul>
                </div>
            </div>

            <!-- Main content -->
            <div class="content-block">
                <div class="section-area section-sp1">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12">
                                <div class="courses-post">
                                    <div class="ttr-post-info">
                                        <div class="ttr-post-content">
                                            <form method="get" action="${pageContext.request.contextPath}/tutor/bookingHistory" class="filter-form">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="month">Chọn Tháng:</label>
                                                            <select name="month" id="month" class="form-control">
                                                                <option value="">Tất cả</option>
                                                                <c:forEach var="month" items="${availableMonths}">
                                                                    <option value="${month}" ${month == selectedMonth ? 'selected' : ''}>Tháng ${month}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="searchField">Tìm kiếm theo:</label>
                                                            <select name="searchField" id="searchField" class="form-control">
                                                                <option value="BookingID" ${searchField == 'BookingID' ? 'selected' : ''}>Booking ID</option>
                                                                <option value="BookingDate" ${searchField == 'BookingDate' ? 'selected' : ''}>Ngày (dd/MM/yyyy)</option>
                                                            </select>
                                                            <input type="text" name="search" value="${search}" class="form-control" placeholder="Nhập giá trị tìm kiếm">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="totalOption">Tổng Thu Nhập Theo:</label>
                                                            <select name="totalOption" id="totalOption" class="form-control">
                                                                <option value="all" ${totalOption == 'all' ? 'selected' : ''}>Tất cả</option>
                                                                <option value="currentMonth" ${totalOption == 'currentMonth' ? 'selected' : ''}>Tháng Đã Chọn</option>
                                                                <option value="filtered" ${totalOption == 'filtered' ? 'selected' : ''}>Theo Bộ Lọc</option>
                                                            </select>
                                                            <input type="submit" value="Lọc và Tìm kiếm" class="btn btn-primary">
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Ẩn các tham số để giữ giá trị khi submit form -->
                                                <input type="hidden" name="sortBy" value="${sortBy}">
                                                <input type="hidden" name="sortOrder" value="${sortOrder}">
                                                <input type="hidden" name="page" value="${currentPage}">
                                            </form>

                                            <c:if test="${not empty message}">
                                                <div class="alert alert-success">${message}</div>
                                            </c:if>
                                            <c:if test="${not empty error}">
                                                <div class="alert alert-danger">${error}</div>
                                            </c:if>

                                            <!-- Hiển thị bảng nếu có dữ liệu cho trang hiện tại -->
                                            <c:if test="${not empty earnings}">
                                                <div class="table-responsive">
                                                    <table class="table table-bordered table-striped">
                                                        <thead>
                                                            <tr>
                                                                <th>
                                                                    <a href="${pageContext.request.contextPath}/tutor/bookingHistory?sortBy=BookingID&sortOrder=${sortBy == 'BookingID' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&month=${selectedMonth}&searchField=${searchField}&totalOption=${totalOption}&page=${currentPage}">
                                                                        Booking ID ${sortBy == 'BookingID' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                                    </a>
                                                                </th>
                                                                <th>
                                                                    <a href="${pageContext.request.contextPath}/tutor/bookingHistory?sortBy=BookingDate&sortOrder=${sortBy == 'BookingDate' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&month=${selectedMonth}&searchField=${searchField}&totalOption=${totalOption}&page=${currentPage}">
                                                                        Ngày ${sortBy == 'BookingDate' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                                    </a>
                                                                </th>
                                                                <th>
                                                                    <a href="${pageContext.request.contextPath}/tutor/bookingHistory?sortBy=HourlyRate&sortOrder=${sortBy == 'HourlyRate' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&month=${selectedMonth}&searchField=${searchField}&totalOption=${totalOption}&page=${currentPage}">
                                                                        Giá/Giờ ${sortBy == 'HourlyRate' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                                    </a>
                                                                </th>
                                                                <th>
                                                                    <a href="${pageContext.request.contextPath}/tutor/bookingHistory?sortBy=TotalEarnings&sortOrder=${sortBy == 'TotalEarnings' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&month=${selectedMonth}&searchField=${searchField}&totalOption=${totalOption}&page=${currentPage}">
                                                                        Tổng Thu Nhập ${sortBy == 'TotalEarnings' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                                    </a>
                                                                </th>
                                                                <th>
                                                                    <a href="${pageContext.request.contextPath}/tutor/bookingHistory?sortBy=SytemCommissionRate&sortOrder=${sortBy == 'SytemCommissionRate' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&month=${selectedMonth}&searchField=${searchField}&totalOption=${totalOption}&page=${currentPage}">
                                                                        Hệ thống ${sortBy == 'SytemCommissionRate' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                                    </a>
                                                                </th>
                                                                <th>
                                                                    <a href="${pageContext.request.contextPath}/tutor/bookingHistory?sortBy=EarningsAfterCommission&sortOrder=${sortBy == 'EarningsAfterCommission' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&month=${selectedMonth}&searchField=${searchField}&totalOption=${totalOption}&page=${currentPage}">
                                                                        Thu Nhập Sau Hoa Hồng ${sortBy == 'EarningsAfterCommission' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                                    </a>
                                                                </th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="earning" items="${earnings}">
                                                                <tr>
                                                                    <td>${earning.bookingID}</td>
                                                                    <td><fmt:formatDate value="${earning.bookingDate}" pattern="dd/MM/yyyy"/></td>
                                                                    <td><fmt:formatNumber value="${earning.hourlyRate}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ</td>
                                                                    <td><fmt:formatNumber value="${earning.totalEarnings}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ</td>
                                                                    <td><fmt:formatNumber value="${earning.sytemCommissionRate}" type="percent"/></td>
                                                                    <td><fmt:formatNumber value="${earning.earningsAfterCommission}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ</td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:if>

                                            <!-- Hiển thị thông báo nếu không có dữ liệu cho trang hiện tại -->
                                            <c:if test="${empty earnings}">
                                                <div class="alert alert-info">Không tìm thấy booking nào cho trang này.</div>
                                            </c:if>

                                            <!-- Hiển thị thanh phân trang nếu có ít nhất 1 bản ghi -->
                                            <c:if test="${totalRecords > 0}">
                                                <div class="pagination justify-content-center">
                                                    <c:if test="${currentPage > 1}">
                                                        <a href="${pageContext.request.contextPath}/tutor/bookingHistory?page=${currentPage - 1}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}&month=${selectedMonth}&searchField=${searchField}&totalOption=${totalOption}" 
                                                           class="btn btn-outline-primary">Previous</a>
                                                    </c:if>
                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <a href="${pageContext.request.contextPath}/tutor/bookingHistory?page=${i}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}&month=${selectedMonth}&searchField=${searchField}&totalOption=${totalOption}" 
                                                           class="btn ${i == currentPage ? 'btn-primary' : 'btn-outline-primary'}">${i}</a>
                                                    </c:forEach>
                                                    <c:if test="${currentPage < totalPages}">
                                                        <a href="${pageContext.request.contextPath}/tutor/bookingHistory?page=${currentPage + 1}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}&month=${selectedMonth}&searchField=${searchField}&totalOption=${totalOption}" 
                                                           class="btn btn-outline-primary">Next</a>
                                                    </c:if>
                                                </div>
                                            </c:if>

                                            <!-- Hiển thị tổng thu nhập nếu có dữ liệu -->
                                            <c:if test="${totalRecords > 0}">
                                                <div class="alert alert-info mt-3">
                                                    Tổng Thu Nhập Sau Hoa Hồng: <strong><fmt:formatNumber value="${totalEarnings}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ</strong>
                                                </div>
                                            </c:if>

                                            <div class="mt-3">
                                                <a href="${pageContext.request.contextPath}/tutor/withdrawRequest" class="btn btn-success">Đi đến Yêu Cầu Rút Tiền</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer từ indextutor.jsp (giữ nguyên) -->
        <footer>
            <div class="footer-top">
                <div class="pt-exebar">
                    <div class="container">
                        <div class="d-flex align-items-stretch">
                            <div class="pt-logo mr-auto">
                                <a href="indextutor.jsp"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt=""/></a>
                            </div>
                            <div class="pt-btn-join">
                                <a href="#" class="btn"><fmt:message key="join_now"/></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
        <button class="back-to-top fa fa-chevron-up"></button>
    </div>

    <!-- Scripts - Same as index page -->
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
    <script src='${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js'></script>
</body>
</html>