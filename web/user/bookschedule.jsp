<%@page import="entity.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
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

        <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <title>G5 SmartTutor</title>
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
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper">
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
                                <a href="home"><img src="assets/images/logo-white.png" alt=""></a>
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
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <div class="page-content bg-white">
                <div class="page-banner ovbl-dark" style="background-image:url(assets/images/banner/banner1.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white"><fmt:message key="book_schedule"/></h1>
                        </div>
                    </div>
                </div>
                <div class="container mt-4">
                    <a href="myschedule" class="btn btn-dark mb-3"><fmt:message key="back"/></a><br>
                    <div class="row">
                        <aside class="col-md-3">
                            <h4><fmt:message key="subject"/>:</h4>
                            <form action="bookschedule" method="GET">
                                <select name="subjectId" onchange="this.form.submit()">
                                    <option value="" ${empty param.subjectId ? 'selected' : ''}><fmt:message key="all"/></option>
                                    <c:forEach var="subject" items="${subjectList}">
                                        <option value="${subject.subjectID}" ${subject.subjectID eq param.subjectId ? 'selected' : ''}>
                                            ${subject.subjectName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </form>
                            <h4 class="mt-3"><fmt:message key="tutor"/>:</h4>
                            <ul class="list-group mb-3">
                                <c:choose>
                                    <c:when test="${empty tutorList}">
                                        <li class="list-group-item text-danger">
                                            <fmt:message key="no_tutor_for_subject"/> 
                                            <c:forEach var="subject" items="${subjectList}">
                                                <c:if test="${subject.subjectID eq param.subjectId}">
                                                    ${subject.subjectName}
                                                </c:if>
                                            </c:forEach>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="tutor" items="${tutorList}">
                                            <li class="list-group-item ${param.tutorId == tutor.tutorID ? 'active' : ''}">
                                                <a href="bookschedule?subjectId=${param.subjectId}&tutorId=${tutor.tutorID}">
                                                    ${tutor.cv.user.fullName}
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </aside>
                        <main class="col-md-9">
                            <div class="container mb-3">
                                <h2><fmt:message key="book_schedule"/></h2>
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger">${error}</div>
                                </c:if>
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success">${success}</div>
                                </c:if>
                                <c:if test="${empty param.tutorId or empty param.subjectId}">
                                    <div class="alert alert-warning"><fmt:message key="select_subject_tutor"/></div>
                                </c:if>
                                <c:if test="${not empty selectedTutor}">
                                    <div class="card mt-4">
                                        <div class="card-header">
                                            <h4>${selectedTutor.cv.user.fullName}</h4>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p><strong><fmt:message key="avatar"/>:</strong> <img src="${selectedTutor.cv.user.avatar}" alt="Avatar" style="width:100px; height:100px; border-radius:5%;" /></p>
                                                    <p><strong><fmt:message key="email"/>:</strong> ${selectedTutor.cv.user.email}</p>
                                                    <p><strong><fmt:message key="phone"/>:</strong> ${selectedTutor.cv.user.phone}</p>
                                                    <p><strong><fmt:message key="rating"/>:</strong> ${selectedTutor.rating}</p>
                                                </div>
                                                <div class="col-md-6">
                                                    <p><strong><fmt:message key="education"/>:</strong> ${selectedTutor.cv.education}</p>
                                                    <p><strong><fmt:message key="experience"/>:</strong> ${selectedTutor.cv.experience}</p>
                                                    <p><strong><fmt:message key="certificates"/>:</strong> ${selectedTutor.cv.certificates}</p>
                                                </div>
                                            </div>
                                            <h4><fmt:message key="booking_slot"/>:</h4>
                                            <form action="PaymentDetail" method="post">
                                                <table class="table table-bordered mt-3">
                                                    <thead>
                                                        <tr>
                                                            <th><fmt:message key="select"/></th>
                                                            <th><fmt:message key="schedule_id"/></th>
                                                            <th><fmt:message key="start_time"/></th>
                                                            <th><fmt:message key="end_time"/></th>
                                                            <th><fmt:message key="duration_min"/></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="schedule" items="${scheduleList}">
                                                            <tr>
                                                                <td><input type="radio" name="scheduleIds" value="${schedule.scheduleID}"></td>
                                                                <td>${schedule.scheduleID}</td>
                                                                <td><fmt:formatDate value="${schedule.startTime}" pattern="dd/MM/yyyy 'at time:' HH:mm" /></td>
                                                                <td><fmt:formatDate value="${schedule.endTime}" pattern="dd/MM/yyyy 'at time:' HH:mm" /></td>
                                                                <td>
                                                                    <c:set var="duration" value="${(schedule.endTime.time - schedule.startTime.time) / 60000}" />
                                                                    ${duration}
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                                <input type="hidden" name="tutorId" value="${param.tutorId}">
                                                <input type="hidden" name="subjectId" value="${param.subjectId}">
                                                <button type="submit" class="btn btn-primary"><fmt:message key="booking"/></button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </main>
                    </div>
                </div>
            </div>
            <footer>
                <div class="footer-top">
                    <div class="pt-exebar">
                        <div class="container">
                            <div class="d-flex align-items-stretch">
                                <div class="pt-logo mr-auto">
                                    <a href="home.jsp"><img src="assets/images/logo-white.png" alt=""/></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
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
        <script src="assets/vendors/revolution/js/jquery.themepunch.tools.min.js"></script>
        <script src="assets/vendors/revolution/js/jquery.themepunch.revolution.min.js"></script>
        <script src="assets/vendors/revolution/js/extensions/revolution.extension.actions.min.js"></script>
        <script src="assets/vendors/revolution/js/extensions/revolution.extension.carousel.min.js"></script>
        <script src="assets/vendors/revolution/js/extensions/revolution.extension.kenburn.min.js"></script>
        <script src="assets/vendors/revolution/js/extensions/revolution.extension.layeranimation.min.js"></script>
        <script src="assets/vendors/revolution/js/extensions/revolution.extension.migration.min.js"></script>
        <script src="assets/vendors/revolution/js/extensions/revolution.extension.navigation.min.js"></script>
        <script src="assets/vendors/revolution/js/extensions/revolution.extension.parallax.min.js"></script>
        <script src="assets/vendors/revolution/js/extensions/revolution.extension.slideanims.min.js"></script>
        <script src="assets/vendors/revolution/js/extensions/revolution.extension.video.min.js"></script>
        <script>
                                    jQuery(document).ready(function () {
                                        var ttrevapi;
                                        var tpj = jQuery;
                                        if (tpj("#rev_slider_486_1").revolution == undefined) {
                                            revslider_showDoubleJqueryError("#rev_slider_486_1");
                                        } else {
                                            ttrevapi = tpj("#rev_slider_486_1").show().revolution({
                                                sliderType: "standard",
                                                jsFileLocation: "assets/vendors/revolution/js/",
                                                sliderLayout: "fullwidth",
                                                dottedOverlay: "none",
                                                delay: 9000,
                                                navigation: {
                                                    keyboardNavigation: "on",
                                                    keyboard_direction: "horizontal",
                                                    mouseScrollNavigation: "off",
                                                    mouseScrollReverse: "default",
                                                    onHoverStop: "on",
                                                    touch: {
                                                        touchenabled: "on",
                                                        swipe_threshold: 75,
                                                        swipe_min_touches: 1,
                                                        swipe_direction: "horizontal",
                                                        drag_block_vertical: false
                                                    },
                                                    arrows: {
                                                        style: "uranus",
                                                        enable: true,
                                                        hide_onmobile: false,
                                                        hide_onleave: false,
                                                        tmp: '',
                                                        left: {h_align: "left", v_align: "center", h_offset: 10, v_offset: 0},
                                                        right: {h_align: "right", v_align: "center", h_offset: 10, v_offset: 0}
                                                    }
                                                },
                                                viewPort: {
                                                    enable: true,
                                                    outof: "pause",
                                                    visible_area: "80%",
                                                    presize: false
                                                },
                                                responsiveLevels: [1240, 1024, 778, 480],
                                                visibilityLevels: [1240, 1024, 778, 480],
                                                gridwidth: [1240, 1024, 778, 480],
                                                gridheight: [768, 600, 600, 600],
                                                lazyType: "none",
                                                parallax: {
                                                    type: "scroll",
                                                    origo: "enterpoint",
                                                    speed: 400,
                                                    levels: [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 46, 47, 48, 49, 50, 55],
                                                    type: "scroll",
                                                },
                                                shadow: 0,
                                                spinner: "off",
                                                stopLoop: "off",
                                                stopAfterLoops: -1,
                                                stopAtSlide: -1,
                                                shuffle: "off",
                                                autoHeight: "off",
                                                hideThumbsOnMobile: "off",
                                                hideSliderAtLimit: 0,
                                                hideCaptionAtLimit: 0,
                                                hideAllCaptionAtLilmit: 0,
                                                debugMode: false,
                                                fallbacks: {
                                                    simplifyAll: "off",
                                                    nextSlideOnWindowFocus: "off",
                                                    disableFocusListener: false,
                                                }
                                            });
                                        }
                                    });
        </script>
    </body>
</html>