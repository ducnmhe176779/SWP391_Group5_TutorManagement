<%-- 
    Document   : blog-details
    Created on : Mar 1, 2025, 1:01:54 PM
    Author     : minht
--%>
<%@page import="entity.User"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Blog" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
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
        <link rel="icon" href="../error-404.jsp" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE -->
        <title>G4 SmartTutor</title>

        <!-- MOBILE SPECIFIC -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS -->
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
    </head>
    <%
        User user = (User) session.getAttribute("user");
    %>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
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

        <!-- Left sidebar menu -->
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
                    <h4 class="breadcrumb-title"><fmt:message key="blog"/></h4>
                </div>	
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="widget-inner">
                                <div class="content-block">
                                    <div class="section-area section-sp1">
                                        <div class="container">
                                            <div class="row">
                                                <!-- Left part start -->
                                                <div class="col-lg-8 col-xl-8">
                                                    <!-- blog start -->
                                                    <div class="recent-news blog-lg">
                                                        <%
                                                            Blog blog = (Blog) request.getAttribute("blog");
                                                            if (blog != null) {
                                                        %>
                                                        <div class="action-box blog-lg">
                                                            <img src="${pageContext.request.contextPath}/<%= blog.getThumbnail()%>" alt="thumbnail">
                                                        </div>
                                                        <div class="info-bx">
                                                            <ul class="media-post">
                                                                <li><i class="fa fa-calendar"></i> <%= blog.getCreatedAt() != null ? blog.getCreatedAt() : "N/A"%></li>
                                                                <li><a href="#"><i class="fa fa-user"></i> <fmt:message key="by"/> <%= blog.getAuthorName() != null ? blog.getAuthorName() : "Unknown"%></a></li>
                                                            </ul>
                                                            <h5 class="post-title"><%= blog.getTitle()%></h5>
                                                            <p><%= blog.getContent() != null ? blog.getContent() : "No content available."%></p>
                                                            <div class="ttr-divider bg-gray"><i class="icon-dot c-square"></i></div>
                                                            <div class="action-buttons">
                                                                <a href="BlogController?service=updateBlog&blogID=<%= blog.getBlogID()%>" class="btn-update"><fmt:message key="update"/></a>
                                                                <a href="BlogController?service=deleteBlog&blogID=<%= blog.getBlogID()%>" 
                                                                   class="btn-delete" 
                                                                   onclick="return confirm('<fmt:message key="confirm_delete_blog"/>');"><fmt:message key="delete"/></a>
                                                            </div>
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
                                                    <!-- blog END -->
                                                </div>
                                                <!-- Left part END -->

                                                <!-- Side bar start -->
                                                <div class="col-lg-4 col-xl-4 col-md-5 sticky-top">
                                                    <aside class="side-bar sticky-top">
                                                        <div class="widget">
                                                            <h6 class="widget-title"><fmt:message key="search"/></h6>
                                                            <div class="search-bx style-1">
                                                                <form role="search" method="post" action="BlogController">
                                                                    <input type="hidden" name="service" value="searchBlog">
                                                                    <div class="input-group">
                                                                        <input name="text" class="form-control" 
                                                                               placeholder="<fmt:message key='enter_keywords'/>" 
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
                                                                        <img src="${pageContext.request.contextPath}/<%= blog1.getThumbnail()%>" 
                                                                             width="200" height="143" alt="<%= blog1.getTitle()%>">
                                                                    </div>
                                                                    <div class="ttr-post-info">
                                                                        <div class="ttr-post-header">
                                                                            <h6 class="post-title">
                                                                                <a href="BlogController?service=detailBlog&blogID=<%= blog1.getBlogID()%>">
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
                                                                            <img src="${pageContext.request.contextPath}/${img.thumbnail}" alt="${img.title}" class="gallery-img" 
                                                                                 onclick="openImageViewer('${pageContext.request.contextPath}/${img.thumbnail}', '${img.title}')">
                                                                        </div>
                                                                    </li>
                                                                </c:forEach>
                                                                <c:if test="${empty galleryBlogs}">
                                                                    <li><div><p><fmt:message key="no_gallery"/></p></div></li>
                                                                            </c:if>
                                                            </ul>
                                                        </div>

                                                        <!-- Modal hiển thị ảnh lớn -->
                                                        <div id="imageViewer" class="image-viewer">
                                                            <span class="close-viewer" onclick="closeImageViewer()">×</span>
                                                            <img id="fullImage" src="" alt="Full Image">
                                                            <p id="imageCaption"></p>
                                                        </div>
                                                    </aside>
                                                </div>
                                                <!-- Side bar END -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <div class="ttr-overlay"></div>

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
        <script src='assets/vendors/scroll/scrollbar.min.js'></script>
        <script src="assets/js/functions.js"></script>
        <script src="assets/vendors/chart/chart.min.js"></script>
        <script src="assets/js/admin.js"></script>
        <script src='assets/vendors/calendar/moment.min.js'></script>
        <script src='assets/vendors/calendar/fullcalendar.js'></script>
        <script src='assets/vendors/switcher/switcher.js'></script>
    </body>
</html>