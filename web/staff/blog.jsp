<%-- 
    Document   : blog-classic-sidebar
    Created on : Feb 26, 2025, 2:21:45 PM
    Author     : minht
--%>
<%@page import="entity.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Blog" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
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
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE -->
        <title>G5 SmartTutor</title>

        <!-- MOBILE SPECIFIC -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
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

        <!-- Main container -->
        <c:if test="${not empty error}">
            <div style="color: red; font-weight: bold;">
                ${error}
            </div>
        </c:if>

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
                                                <div class="col-lg-8 col-xl-8 col-md-7">
                                                    <!-- Blog grid -->
                                                    <div id="masonry" class="ttr-blog-grid-3 row">
                                                        <%
                                                            List<Blog> listBlog = (List<Blog>) request.getAttribute("blogList");
                                                            if (listBlog != null && !listBlog.isEmpty()) {
                                                                for (Blog blog : listBlog) {
                                                        %>
                                                        <div class="post action-card col-xl-6 col-lg-6 col-md-12 col-xs-12 m-b40">
                                                            <div class="recent-news">
                                                                <div class="action-box">
                                                                    <img src="${pageContext.request.contextPath}/<%= blog.getThumbnail()%>" alt="thumbnail" 
                                                                         style="width: 400px; height: 250px; object-fit: contain;" />
                                                                </div>
                                                                <div class="info-bx">
                                                                    <ul class="media-post">
                                                                        <li><i class="fa fa-calendar"></i><%= blog.getCreatedAt()%></li>
                                                                        <li><i class="fa fa-user"></i><fmt:message key="by"/> <%= blog.getAuthorName()%></li>
                                                                    </ul>
                                                                    <h5 class="post-title">
                                                                        <a href="BlogController?service=detailBlog&blogID=<%= blog.getBlogID()%>"><%= blog.getTitle()%></a>
                                                                    </h5>
                                                                    <p><%= blog.getSummary()%></p>
                                                                </div>
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
                                                    <!-- Blog grid END -->

                                                    <!-- Pagination -->
                                                    <div class="pagination-bx rounded-sm gray clearfix">
                                                        <ul class="pagination">
                                                            <li class="previous ${currentPage == 1 ? 'disabled' : ''}">
                                                                <a href="${currentPage == 1 ? '#' : 'BlogController?service=listBlog&page='.concat(currentPage - 1)}">
                                                                    <i class="ti-arrow-left"></i> <fmt:message key="prev"/>
                                                                </a>
                                                            </li>
                                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                                <li class="${currentPage == i ? 'active' : ''}">
                                                                    <a href="BlogController?service=listBlog&page=${i}">${i}</a>
                                                                </li>
                                                            </c:forEach>
                                                            <li class="next ${currentPage == totalPages ? 'disabled' : ''}">
                                                                <a href="${currentPage == totalPages ? '#' : 'BlogController?service=listBlog&page='.concat(currentPage + 1)}">
                                                                    <fmt:message key="next"/> <i class="ti-arrow-right"></i>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    <!-- Pagination END -->
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
                                                                        for (Blog blog : recentBlogs) {
                                                                %>
                                                                <div class="widget-post clearfix">
                                                                    <div class="ttr-post-media">
                                                                        <img src="${pageContext.request.contextPath}/<%= blog.getThumbnail()%>" 
                                                                             width="200" height="143" alt="<%= blog.getTitle()%>">
                                                                    </div>
                                                                    <div class="ttr-post-info">
                                                                        <div class="ttr-post-header">
                                                                            <h6 class="post-title">
                                                                                <a href="BlogController?service=detailBlog&blogID=<%= blog.getBlogID()%>">
                                                                                    <%= blog.getTitle()%>
                                                                                </a>
                                                                            </h6>
                                                                        </div>
                                                                        <ul class="media-post">
                                                                            <li><i class="fa fa-calendar"></i> <%= blog.getCreatedAt()%></li>
                                                                            <li><i class="fa fa-user"></i><%= blog.getAuthorName()%></li>
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
        <script src='${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js'></script>
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
        <script src='${pageContext.request.contextPath}/assets/vendors/calendar/moment.min.js'></script>
        <script src='${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.js'></script>
        <script src='${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js'></script>
    </body>
</html>