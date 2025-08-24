<%@page import="entity.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Blog" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

        <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <title>G4 SmartTutor</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
        <link rel="stylesheet" type="text/css" href="assets/vendors/revolution/css/layers.css">
        <link rel="stylesheet" type="text/css" href="assets/vendors/revolution/css/settings.css">
        <link rel="stylesheet" type="text/css" href="assets/vendors/revolution/css/navigation.css">
    </head>
    <body id="bg">
        <%
            User user = (User) session.getAttribute("user");
        %>
        <!-- Thiết lập Locale và Resource Bundle -->
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper">
            <!-- Tạm thời loại bỏ loading-icon-bx -->
            <!-- <div id="loading-icon-bx"></div> -->
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
                                    <% } %>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="sticky-header navbar-expand-lg">
                    <div class="menu-bar clearfix">
                        <div class="container clearfix">
                            <div class="menu-logo">
                                <a href="home"><img src="assets/images/logo-white.png" alt=""></a>
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
                                    <a href="home"><img src="assets/images/logo.png" alt=""></a>
                                </div>
                                <ul class="nav navbar-nav">    
                                    <li><a href="home"><fmt:message key="home"/></a></li>
                                    <li><a href="Tutor"><fmt:message key="our_tutor"/></a></li>
                                    <li class="active"><a href="ViewBlog"><fmt:message key="blog"/></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <div class="page-content bg-white">
                <div class="page-banner ovbl-dark" style="background-image:url(assets/images/banner/banner2.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white"><fmt:message key="blog_details"/></h1>
                        </div>
                    </div>
                </div>
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="home"><fmt:message key="home"/></a></li>
                            <li><a href="ViewBlog"><fmt:message key="blog_classic_sidebar"/></a></li>
                            <li><fmt:message key="blog_details"/></li>
                        </ul>
                    </div>
                </div>
                <div class="content-block">
                    <div class="section-area section-sp1">
                        <div class="container">
                            <div class="row">
                                <div class="col-lg-8 col-xl-8">
                                    <div class="recent-news blog-lg">
                                        <%
                                            Blog blog = (Blog) request.getAttribute("blog");
                                            if (blog != null) {
                                        %>
                                        <div class="action-box blog-lg">
                                            <img src="<%= blog.getThumbnail()%>" alt="<%= blog.getTitle()%>">
                                        </div>
                                        <div class="info-bx">
                                            <ul class="media-post">
                                                <li><i class="fa fa-calendar"></i> <%= blog.getCreatedAt() != null ? blog.getCreatedAt() : "N/A"%></li>
                                                <li><a href="#"><i class="fa fa-user"></i> <fmt:message key="by"/> <%= blog.getAuthorName() != null ? blog.getAuthorName() : "Unknown"%></a></li>
                                            </ul>
                                            <h5 class="post-title"><%= blog.getTitle()%></h5>
                                            <p><%= blog.getContent() != null ? blog.getContent() : "No content available."%></p>
                                            <div class="ttr-divider bg-gray"><i class="icon-dot c-square"></i></div>
                                        </div>
                                        <%
                                        } else {
                                        %>
                                        <div class="info-bx">
                                            <p><fmt:message key="no_post"/></p>
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                                <div class="col-lg-4 col-xl-4 col-md-5 sticky-top">
                                    <aside class="side-bar sticky-top">
                                        <div class="widget">
                                            <h6 class="widget-title"><fmt:message key="search"/></h6>
                                            <div class="search-bx style-1">
                                                <form role="search" method="post" action="ViewBlog">
                                                    <input type="hidden" name="service" value="searchBlog">
                                                    <div class="input-group">
                                                        <input name="text" class="form-control" 
                                                               placeholder="<fmt:message key='enter_your_keywords'/>" 
                                                               type="text" 
                                                               value="${keyword != null ? keyword : ''}">
                                                        <span class="input-group-btn">
                                                            <button type="submit" class="fa fa-search text-primary"></button>
                                                        </span>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                        <div class="widget recent-posts-entry">
                                            <h6 class="widget-title"><fmt:message key="recent_posts"/></h6>
                                            <div class="widget-post-bx">
                                                <%
                                                    List<Blog> recentBlogs = (List<Blog>) request.getAttribute("recentBlogs");
                                                    if (recentBlogs != null && !recentBlogs.isEmpty()) {
                                                        for (Blog blog1 : recentBlogs) {
                                                %>
                                                <div class="widget-post clearfix">
                                                    <div class="ttr-post-media">
                                                        <img src="<%= blog1.getThumbnail()%>" 
                                                             width="200" height="143" alt="<%= blog1.getTitle()%>">
                                                    </div>
                                                    <div class="ttr-post-info">
                                                        <div class="ttr-post-header">
                                                            <h6 class="post-title">
                                                                <a href="ViewBlog?service=detailBlog&blogID=<%= blog1.getBlogID()%>">
                                                                    <%= blog1.getTitle()%>
                                                                </a>
                                                            </h6>
                                                        </div>
                                                        <ul class="media-post">
                                                            <li><i class="fa fa-calendar"></i> <%= blog1.getCreatedAt()%></li>
                                                            <li><a href="#"><i class="fa fa-comments-o"></i><%= blog1.getAuthorName()%></a></li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <%
                                                    }
                                                } else {
                                                %>
                                                <p><fmt:message key="no_post"/></p>
                                                <%
                                                    }
                                                %>
                                            </div>
                                        </div>
                                        <div class="widget widget_gallery gallery-grid-4">
                                            <h6 class="widget-title"><fmt:message key="our_gallery"/></h6>
                                            <ul class="gallery-list">
                                                <c:forEach var="img" items="${galleryBlogs}">
                                                    <li>
                                                        <div>
                                                            <img src="${img.thumbnail}" alt="${img.title}" class="gallery-img" onclick="openImageViewer('${img.thumbnail}', '${img.title}')">
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                                <c:if test="${empty galleryBlogs}">
                                                    <li><div><p><fmt:message key="null_gallery"/></p></div></li>
                                                            </c:if>
                                            </ul>
                                        </div>
                                        <div id="imageViewer" class="image-viewer">
                                            <span class="close-viewer" onclick="closeImageViewer()">×</span>
                                            <img id="fullImage" src="" alt="Full Image">
                                            <p id="imageCaption"></p>
                                        </div>
                                    </aside>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
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
                <button class="back-to-top fa fa-chevron-up"></button>
            </div>
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
                                                document.addEventListener('DOMContentLoaded', function () {
                                                    console.log('Trang blog-details đã load xong');
                                                    var loadingIcon = document.getElementById('loading-icon-bx');
                                                    if (loadingIcon) {
                                                        loadingIcon.style.display = 'none';
                                                    }
                                                });
            </script>
    </body>
</html>