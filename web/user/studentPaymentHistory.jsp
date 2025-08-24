<%-- 
    Document   : studentPaymentHistory
    Created on : Mar 24, 2025, 3:01:21 PM
    Author     : minht
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
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

        <!-- FAVICONS ICON -->
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
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
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/layers.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/settings.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/navigation.css">

        <!-- CSS cho bảng và phân trang -->
        <style>
            .table-responsive {
                margin-bottom: 20px;
            }
            .table th, .table td {
                padding: 12px;
                vertical-align: middle;
            }
            .pagination-bx {
                margin-top: 20px;
            }
        </style>
    </head>
    <body id="bg">
        <%
            entity.User user = (entity.User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        %>
        <!-- Thiết lập Locale và Resource Bundle -->
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper">
            <!-- Header start -->
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
                                        <select class="header-lang-bx" onchange="window.location.href = '${pageContext.request.contextPath}/LanguageServlet?lang=' + this.value;">
                                            <option value="en" ${sessionScope.locale == null || sessionScope.locale == 'en' ? 'selected' : ''}><fmt:message key="english"/></option>
                                            <option value="vi" ${sessionScope.locale == 'vi' ? 'selected' : ''}><fmt:message key="vietnamese"/></option>
                                        </select>
                                    </li>
                                    <% if (user == null) { %>
                                    <li><a href="login"><fmt:message key="login"/></a></li>
                                    <li><a href="User?service=registerUser"><fmt:message key="register"/></a></li>
                                        <% } else {%>
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
                                    <% }%>
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
                                    <a href="home"><img src="${pageContext.request.contextPath}/assets/Images/logo.png" alt=""></a>
                                </div>
                                <ul class="nav navbar-nav">    
                                    <li><a href="home"><fmt:message key="home"/></a></li>
                                    <li><a href="Tutor"><fmt:message key="our_tutor"/></a></li>
                                    <li><a href="ViewBlog"><fmt:message key="blog"/></a></li>
                                </ul>
                                <div class="nav-social-link">
                                    <a href="javascript:;"><i class="fa fa-facebook"></i></a>
                                    <a href="javascript:;"><i class="fa fa-google-plus"></i></a>
                                    <a href="javascript:;"><i class="fa fa-linkedin"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <!-- Header end -->

            <!-- Page content start -->
            <div class="page-content bg-white">
                <!-- Page banner -->
                <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/banner/banner1.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white"><fmt:message key="history_payment"/></h1>
                        </div>
                    </div>
                </div>

                <!-- Breadcrumb -->
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="home"><fmt:message key="home"/></a></li>
                            <li><fmt:message key="history_payment"/></li>
                        </ul>
                    </div>
                </div>

                <!-- Main content -->
                <div class="content-block">
                    <div class="section-area section-sp1">
                        <div class="container">
                            <div class="row">
                                <!-- Cột chính: Bảng lịch sử thanh toán -->
                                <div class="col-lg-8 col-xl-8 col-md-7">
                                    <div class="table-responsive">
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th><fmt:message key="payment_id"/></th>
                                                    <th><fmt:message key="booking_id"/></th>
                                                    <th><fmt:message key="amount"/></th>
                                                    <th><fmt:message key="payment_date"/></th>
                                                    <th><fmt:message key="status"/></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="payment" items="${paymentHistory}">
                                                    <tr>
                                                        <td>${payment.paymentID}</td>
                                                        <td>${payment.bookingID}</td>
                                                        <td><fmt:formatNumber value="${payment.amount}" type="number" pattern="#,###" /> VNĐ</td>
                                                        <td><fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${payment.status == 'Completed'}">
                                                                    <span class="badge bg-success"><fmt:message key="completed"/></span>
                                                                </c:when>
                                                                <c:when test="${payment.status == 'Failed'}">
                                                                    <span class="badge bg-danger"><fmt:message key="failed"/></span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-warning"><fmt:message key="processing"/></span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty paymentHistory}">
                                                    <tr>
                                                        <td colspan="5" class="text-center"><fmt:message key="no_transactions"/></td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Phân trang -->
                                    <div class="pagination-bx rounded-sm gray clearfix">
                                        <ul class="pagination">
                                            <li class="previous ${currentPage == 1 || totalPages == 0 ? 'disabled' : ''}">
                                                <a href="${currentPage == 1 || totalPages == 0 ? '#' : 'StudentPaymentHistory?page='.concat(currentPage - 1)}">
                                                    <i class="ti-arrow-left"></i> <fmt:message key="prev"/>
                                                </a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="${currentPage == i ? 'active' : ''}">
                                                    <a href="StudentPaymentHistory?page=${i}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="next ${currentPage == totalPages || totalPages == 0 ? 'disabled' : ''}">
                                                <a href="${currentPage == totalPages || totalPages == 0 ? '#' : 'StudentPaymentHistory?page='.concat(currentPage + 1)}">
                                                    <fmt:message key="next"/> <i class="ti-arrow-right"></i>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <!-- Sidebar bên phải -->
                                <div class="col-lg-4 col-xl-4 col-md-5 sticky-top">
                                    <aside class="side-bar sticky-top">
                                        <!-- Widget giao dịch gần đây -->
                                        <div class="widget recent-posts-entry">
                                            <h6 class="widget-title"><fmt:message key="recent_transactions"/></h6>
                                            <div class="widget-post-bx">
                                                <c:forEach var="payment" items="${paymentHistory}" end="3">
                                                    <div class="widget-post clearfix">
                                                        <div class="ttr-post-info">
                                                            <div class="ttr-post-header">
                                                                <h6 class="post-title">
                                                                    <fmt:message key="payment_id"/>: ${payment.paymentID}
                                                                </h6>
                                                            </div>
                                                            <ul class="media-post">
                                                                <li><i class="fa fa-calendar"></i> <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm" /></li>
                                                                <li><i class="fa fa-money"></i> <fmt:formatNumber value="${payment.amount}" type="number" pattern="#,###" /> VNĐ</li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${empty paymentHistory}">
                                                    <p><fmt:message key="no_transactions"/></p>
                                                </c:if>
                                            </div>
                                        </div>
                                    </aside>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Page content end -->
            <!-- Footer start -->
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
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>
    </body>
</html>