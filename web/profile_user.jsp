<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="entity.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // Lấy user từ request attribute (có thể là user khác nếu đang xem profile của user khác)
    User user = (User) request.getAttribute("user");
    if (user == null) {
        // Fallback: lấy từ session nếu không có trong request
        user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    }
    
    // Kiểm tra xem có đang xem profile của user khác không
    Boolean viewingOtherUser = (Boolean) request.getAttribute("viewingOtherUser");
    if (viewingOtherUser == null) {
        viewingOtherUser = false;
    }
%>
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
        <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE -->
        <title>G5 SmartTutor</title>

        <!-- MOBILE SPECIFIC -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
    </head>
    <body id="bg">
        <!-- Thiết lập Locale và Resource Bundle -->
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper">
            <div id="loading-icon-bx"></div>
            <!-- Header -->
            <header class="header rs-nav">
                <div class="top-bar">
                    <div class="container">
                        <div class="row d-flex justify-content-between">
                            <div class="topbar-left">
                                <ul>
                                    <li><a href="faq-1.jsp"><i class="fa fa-question-circle"></i><fmt:message key="ask_a_question"/></a></li>
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
                                                <li><a href="${pageContext.request.contextPath}/profile"><fmt:message key="my_profile"/></a></li>
                                                <li><a href="${pageContext.request.contextPath}/StudentPaymentHistory"><fmt:message key="history_payment"/></a></li>
                                                <li><a href="${pageContext.request.contextPath}/cv"><fmt:message key="become_a_tutor"/></a></li>
                                                <li><a href="${pageContext.request.contextPath}/logout"><fmt:message key="logout"/></a></li>
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
                                <a href="home"><img src="assets/images/logo.png" alt=""></a>
                            </div>
                            <button class="navbar-toggler collapsed menuicon justify-content-end" type="button" data-toggle="collapse" data-target="#menuDropdown" aria-controls="menuDropdown" aria-expanded="false" aria-label="Toggle navigation">
                                <span></span>
                                <span></span>
                                <span></span>
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
                                    <a href="home"><img src="assets/images/logo.png" alt=""></a>
                                </div>
                                <ul class="nav navbar-nav">	
                                    <li class="active"><a href="home"><fmt:message key="home"/></a></li>
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
            <!-- Content -->
            <div class="page-content bg-white">
                <div class="page-banner ovbl-dark" style="background-image:url(assets/images/banner/banner1.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white"><fmt:message key="profile"/></h1>
                        </div>
                    </div>
                </div>
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="home"><fmt:message key="home"/></a></li>
                            <li><fmt:message key="profile"/></li>
                        </ul>
                    </div>
                </div>
                
                <!-- Thông báo khi đang xem profile của user khác -->
                <% if (viewingOtherUser) { %>
                <div class="container">
                    <div class="alert alert-info" style="margin: 20px 0;">
                        <i class="fa fa-info-circle"></i> 
                        Bạn đang xem profile của: <strong><%= user.getFullName()%></strong> 
                        (<%= user.getEmail()%>)
                        <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-sm btn-outline-primary ml-3">
                            <i class="fa fa-arrow-left"></i> Quay lại Dashboard
                        </a>
                    </div>
                </div>
                <% } %>
                <div class="content-block">
                    <div class="section-area section-sp1">
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
                                        <div class="profile-social">
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
                                            <div class="tab-pane active" id="profile-detail">
                                                <div class="profile-head">
                                                    <h3><fmt:message key="profile_detail"/></h3>
                                                </div>
                                                <form class="edit-profile">
                                                    <div class="">
                                                        <div class="form-group row">
                                                            <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="email"/></label>
                                                            <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                <input class="form-control" type="email" value="<%= user.getEmail()%>" readonly>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="full_name"/></label>
                                                            <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                <input class="form-control" type="text" value="<%= user.getFullName()%>" readonly>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="phone"/></label>
                                                            <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                <input class="form-control" type="text" value="<%= user.getPhone()%>" readonly>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="dob"/></label>
                                                            <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                <input class="form-control" type="date" value="<%= user.getDob()%>" readonly>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="address"/></label>
                                                            <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                                <input class="form-control" type="text" value="<%= user.getAddress()%>" readonly>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="tab-pane" id="edit-profile">
                                                <div class="profile-head">
                                                    <h3><fmt:message key="edit_profile"/></h3>
                                                </div>
                                                <form class="edit-profile" action="profile" method="POST" enctype="multipart/form-data">
                                                    <input type="hidden" name="action" value="editProfile">
                                                    <div class="form-group row">
                                                        <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="full_name"/></label>
                                                        <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                            <input class="form-control" type="text" name="fullName" value="<%= user.getFullName()%>">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="phone"/></label>
                                                        <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                            <input class="form-control" type="text" name="phone" value="<%= user.getPhone()%>">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="dob"/></label>
                                                        <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                            <input class="form-control" type="date" name="dob" value="<%= user.getDob()%>">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="avatar"/></label>
                                                        <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                            <input class="form-control" type="file" name="avatar" accept="image/*">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label class="col-12 col-sm-3 col-md-3 col-lg-2 col-form-label"><fmt:message key="address"/></label>
                                                        <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                            <input class="form-control" type="text" name="address" value="<%= user.getAddress()%>">
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-12 col-sm-3 col-md-3 col-lg-2"></div>
                                                        <div class="col-12 col-sm-9 col-md-9 col-lg-7">
                                                            <button type="submit" class="btn btn-primary"><fmt:message key="save_changes"/></button>
                                                            <button type="reset" class="btn btn-secondary"><fmt:message key="cancel"/></button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>                                    
                                            <div class="tab-pane" id="change-password">
                                                <div class="profile-head">
                                                    <h3><fmt:message key="change_password"/></h3>
                                                </div>
                                                <form class="edit-profile" action="profile" method="POST">
                                                    <input type="hidden" name="action" value="changePassword">
                                                    <div class="form-group row">
                                                        <label class="col-12 col-sm-4 col-md-4 col-lg-3 col-form-label"><fmt:message key="current_password"/></label>
                                                        <div class="col-12 col-sm-8 col-md-8 col-lg-7">
                                                            <input class="form-control" type="password" name="currentPassword" required>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label class="col-12 col-sm-4 col-md-4 col-lg-3 col-form-label"><fmt:message key="new_password"/></label>
                                                        <div class="col-12 col-sm-8 col-md-8 col-lg-7">
                                                            <input class="form-control" type="password" name="newPassword" required>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label class="col-12 col-sm-4 col-md-4 col-lg-3 col-form-label"><fmt:message key="retype_new_password"/></label>
                                                        <div class="col-12 col-sm-8 col-md-8 col-lg-7">
                                                            <input class="form-control" type="password" name="confirmPassword" required>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-12 col-sm-4 col-md-4 col-lg-3"></div>
                                                        <div class="col-12 col-sm-8 col-md-8 col-lg-7">
                                                            <button type="submit" class="btn"><fmt:message key="save_changes"/></button>
                                                            <button type="reset" class="btn"><fmt:message key="cancel"/></button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div> 
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Xóa phần hiển thị thông báo cũ -->
                </div>
                <!-- Footer -->
                <footer>
                    <div class="footer-top">
                        <div class="pt-exebar">
                            <div class="container">
                                <div class="d-flex align-items-stretch">
                                    <div class="pt-logo mr-auto">
                                        <a href="home"><img src="assets/images/logo-white.png" alt=""/></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
            <!-- External JavaScripts -->
            <script src="assets/js/jquery.min.js"></script>
            <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
            <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
            <script src="assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
            <script src="assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
            <script src="assets/vendors/magnific-popup/magnific-popup.js"></script>
            <script src="assets/vendors/counter/waypoints-min.js"></script>
            <script src="assets/vendors/counter/counterup.min.js"></script>
            <script src="assets/vendors/imagesloaded/imagesloaded.js"></script>
            <script src="assets/vendors/masonry/masonry.js"></script>
            <script src="assets/vendors/masonry/filter.js"></script>
            <script src="assets/vendors/owl-carousel/owl.carousel.js"></script>
            <script src="assets/js/functions.js"></script>
            <script src="assets/js/contact.js"></script>
            <script src='assets/vendors/switcher/switcher.js'></script>
            <script>
                                            // Xử lý popup thông báo từ tham số URL
                                            const urlParams = new URLSearchParams(window.location.search);
                                            const message = urlParams.get('message');
                                            const error = urlParams.get('error');

                                            if (message) {
                                                alert(decodeURIComponent(message)); // Hiển thị thông báo thành công
                                                // Xóa tham số sau khi hiển thị để tránh popup lặp lại khi refresh
                                                window.history.replaceState({}, document.title, window.location.pathname);
                                            } else if (error) {
                                                alert(decodeURIComponent(error));   // Hiển thị thông báo lỗi
                                                window.history.replaceState({}, document.title, window.location.pathname);
                                            }

                                            // Chuyển tab dựa trên action (nếu cần)
                <% if ("changePassword".equals(request.getParameter("action"))) { %>
                                            $('#change-password').tab('show');
                <% } else if ("editProfile".equals(request.getParameter("action"))) { %>
                                            $('#edit-profile').tab('show');
                <% }%>
            </script>
    </body>
</html>