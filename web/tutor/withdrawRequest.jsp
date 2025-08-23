<%-- 
    Document   : withdrawRequest
    Created on : Mar 27, 2025
    Author     : [Your Name]
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
                            <div class="menu-links navbar-collapse collapse justify-content-start" id="menuDropdown">
                                <div class="menu-logo">
                                    <a href="indextutor.jsp"><img src="${pageContext.request.contextPath}/assets/images/logo.png" alt=""></a>
                                </div>
                                <ul class="nav navbar-nav">
                                    <li><a href="indextutor.jsp"><fmt:message key="home"/></a></li>
                                    <li><a href="CreateSchedule"><fmt:message key="my_schedule"/></a></li>
                                    <li class="active"><a href="bookingHistory"><fmt:message key="withdraw"/></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Nội dung chính của withdrawRequest.jsp -->
            <div class="page-content bg-white">
                <!-- Page banner -->
                <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/banner/banner1.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white">Yêu Cầu Rút Tiền</h1>
                        </div>
                    </div>
                </div>

                <!-- Breadcrumb -->
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="indextutor.jsp"><fmt:message key="home"/></a></li>
                            <li><a href="bookingHistory"><fmt:message key="withdraw"/></a></li>
                            <li>Yêu Cầu Rút Tiền</li>
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
                                                <c:if test="${not empty message}">
                                                    <div class="alert alert-success">${message}</div>
                                                </c:if>
                                                <c:if test="${not empty error}">
                                                    <div class="alert alert-danger">${error}</div>
                                                </c:if>

                                                <h2>Các Tháng Có Thu Nhập Chưa Rút</h2>
                                                <c:if test="${empty months}">
                                                    <div class="alert alert-info">Không có thu nhập nào để rút.</div>
                                                </c:if>
                                                <c:if test="${not empty months}">
                                                    <form method="post" action="${pageContext.request.contextPath}/tutor/withdrawRequest" class="form-container">
                                                        <div class="form-group">
                                                            <label for="month">Chọn Tháng:</label>
                                                            <select name="month" id="month" onchange="updateTotal(this.value)" class="form-control">
                                                                <c:forEach var="month" items="${months}">
                                                                    <c:set var="isApproved" value="false" />
                                                                    <c:forEach var="request" items="${requests}">
                                                                        <c:if test="${request.month == month && request.withdrawStatus == 'Approved'}">
                                                                            <c:set var="isApproved" value="true" />
                                                                        </c:if>
                                                                    </c:forEach>
                                                                    <c:if test="${!isApproved}">
                                                                        <option value="${month}">${month}</option>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="totalEarnings">Tổng Thu Nhập:</label>
                                                            <input type="text" id="totalEarnings" readonly class="form-control">
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="content">Thông Tin Tài Khoản Ngân Hàng:</label>
                                                            <textarea name="content" id="content" rows="3" required placeholder="Nhập thông tin tài khoản ngân hàng (VD: STK: 123456789 - Ngân hàng ABC)" class="form-control"></textarea>
                                                        </div>
                                                        <div class="mt-3">
                                                            <input type="submit" class="btn btn-success" value="Gửi Yêu Cầu Rút Tiền">
                                                        </div>
                                                    </form>
                                                </c:if>

                                                <h2>Lịch Sử Yêu Cầu Rút Tiền</h2>
                                                <form method="get" action="${pageContext.request.contextPath}/tutor/withdrawRequest" class="filter-form">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label for="searchField">Tìm kiếm theo:</label>
                                                                <select name="searchField" id="searchField" class="form-control">
                                                                    <option value="WithdrawStatus" ${searchField == 'WithdrawStatus' ? 'selected' : ''}>Trạng Thái</option>
                                                                    <option value="RequestDate" ${searchField == 'RequestDate' ? 'selected' : ''}>Ngày Gửi</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label for="search" >Giá trị tìm kiếm:</label>
                                                                <input type="text" name="search" value="${search}" class="form-control" placeholder="${searchField == 'RequestDate' ? 'VD: 15, 03/2025, 2025' : 'VD: Pending'}">
                                                                <input type="submit" class="btn btn-success" value="Tìm kiếm">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </form>

                                                <c:if test="${empty requests}">
                                                    <div class="alert alert-info">Không tìm thấy yêu cầu rút tiền nào.</div>
                                                </c:if>
                                                <c:if test="${not empty requests}">
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered table-striped">
                                                            <thead>
                                                                <tr>
                                                                    <th>Tháng</th>
                                                                    <th>Tổng Thu Nhập Sau Hoa Hồng (VND)</th>
                                                                    <th>Trạng Thái</th>
                                                                    <th>Nội Dung</th>
                                                                    <th>
                                                                        <a href="${pageContext.request.contextPath}/tutor/withdrawRequest?sortBy=RequestDate&sortOrder=${sortBy == 'RequestDate' && sortOrder == 'asc' ? 'desc' : 'asc'}&search=${search}&searchField=${searchField}">
                                                                            Ngày Gửi ${sortBy == 'RequestDate' ? (sortOrder == 'asc' ? '↑' : '↓') : ''}
                                                                        </a>
                                                                    </th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="request" items="${requests}">
                                                                    <tr>
                                                                        <td>${request.month}</td>
                                                                        <td><fmt:formatNumber value="${request.totalEarningsAfterCommission}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ</td>
                                                                        <td>${request.withdrawStatus}</td>
                                                                        <td>${request.content}</td>
                                                                        <td><fmt:formatDate value="${request.requestDate}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </c:if>

                                                <div class="mt-3">
                                                    <a href="${pageContext.request.contextPath}/tutor/bookingHistory" class="btn btn-success">Quay lại Lịch Sử Booking</a>
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

        <!-- Scripts - Same as indextutor.jsp -->
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

        <!-- Script từ withdrawRequest.jsp -->
        <script>
                                                                const monthEarnings = {
            <c:forEach var="entry" items="${monthEarnings}" varStatus="loop">
                                                                    "${entry.key}": ${entry.value}${loop.last ? '' : ','}
            </c:forEach>
                                                                };

                                                                function updateTotal(month) {
                                                                    const total = monthEarnings[month] || 0;
                                                                    document.getElementById('totalEarnings').value = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(total);
                                                                }

                                                                if (document.getElementById('month')) {
                                                                    updateTotal(document.getElementById('month').value);
                                                                }
        </script>
    </body>
</html>