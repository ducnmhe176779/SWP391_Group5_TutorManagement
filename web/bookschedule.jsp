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
        
        <!-- Custom CSS for Enhanced Booking Page -->
        <style>
            .booking-page {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
            }
            
            .page-content {
                background: transparent !important;
            }
            
            .page-banner {
                background: rgba(0,0,0,0.3) !important;
                backdrop-filter: blur(10px);
            }
            
            .main-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.1);
                margin: -50px 0 50px 0;
                position: relative;
                z-index: 10;
                padding: 40px;
            }
            
            .sidebar {
                background: linear-gradient(145deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                border: 1px solid rgba(255,255,255,0.2);
            }
            
            .sidebar h4 {
                color: #2c3e50;
                font-weight: 700;
                margin-bottom: 20px;
                font-size: 18px;
                border-bottom: 3px solid #3498db;
                padding-bottom: 10px;
            }
            
            .subject-select select {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e9ecef;
                border-radius: 10px;
                font-size: 14px;
                transition: all 0.3s ease;
                background: white;
            }
            
            .subject-select select:focus {
                border-color: #3498db;
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
                outline: none;
            }
            
            .tutor-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            
            .tutor-list li {
                margin: 8px 0;
                border-radius: 10px;
                transition: all 0.3s ease;
            }
            
            .tutor-list li a {
                display: block;
                padding: 15px 20px;
                color: #2c3e50;
                text-decoration: none;
                border-radius: 10px;
                transition: all 0.3s ease;
                border: 2px solid transparent;
            }
            
            .tutor-list li a:hover {
                background: linear-gradient(135deg, #3498db, #2980b9);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
            }
            
            .tutor-list li.active a {
                background: linear-gradient(135deg, #e74c3c, #c0392b);
                color: white;
                border-color: #c0392b;
                box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
            }
            
            .tutor-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 20px;
                padding: 30px;
                color: white;
                box-shadow: 0 15px 35px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }
            
            .tutor-header {
                text-align: center;
                margin-bottom: 30px;
            }
            
            .tutor-avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                border: 5px solid rgba(255,255,255,0.3);
                object-fit: cover;
                margin: 0 auto 20px;
                display: block;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            }
            
            .tutor-name {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 10px;
                text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            }
            
            .tutor-info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-top: 30px;
            }
            
            .info-item {
                background: rgba(255,255,255,0.1);
                padding: 20px;
                border-radius: 15px;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255,255,255,0.2);
                transition: all 0.3s ease;
            }
            
            .info-item:hover {
                background: rgba(255,255,255,0.2);
                transform: translateY(-5px);
            }
            
            .info-item strong {
                display: block;
                margin-bottom: 8px;
                font-size: 12px;
                text-transform: uppercase;
                opacity: 0.8;
                letter-spacing: 1px;
            }
            
            .info-item div {
                font-size: 16px;
                font-weight: 600;
            }
            
            .booking-section {
                background: white;
                border-radius: 20px;
                padding: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }
            
            .booking-section h4 {
                color: #2c3e50;
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 25px;
                text-align: center;
                border-bottom: 3px solid #3498db;
                padding-bottom: 15px;
            }
            
            .schedule-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            
            .schedule-table th {
                background: linear-gradient(135deg, #3498db, #2980b9);
                color: white;
                padding: 18px 15px;
                text-align: left;
                font-weight: 600;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            
            .schedule-table td {
                padding: 18px 15px;
                border-bottom: 1px solid #e9ecef;
                vertical-align: middle;
                transition: all 0.3s ease;
            }
            
            .schedule-table tr:hover td {
                background: #f8f9fa;
                transform: scale(1.01);
            }
            
            .radio-custom {
                width: 22px;
                height: 22px;
                accent-color: #3498db;
                cursor: pointer;
            }
            
            .btn-booking {
                background: linear-gradient(135deg, #27ae60, #2ecc71);
                border: none;
                color: white;
                padding: 15px 40px;
                border-radius: 50px;
                font-weight: 600;
                font-size: 16px;
                transition: all 0.3s ease;
                margin-top: 25px;
                text-transform: uppercase;
                letter-spacing: 1px;
                box-shadow: 0 5px 15px rgba(39, 174, 96, 0.4);
            }
            
            .btn-booking:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(39, 174, 96, 0.6);
                background: linear-gradient(135deg, #2ecc71, #27ae60);
            }
            
            .btn-back {
                background: linear-gradient(135deg, #f39c12, #e67e22);
                border: none;
                color: white;
                padding: 12px 25px;
                border-radius: 25px;
                font-weight: 600;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
                margin-bottom: 30px;
            }
            
            .btn-back:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(243, 156, 18, 0.4);
                color: white;
                text-decoration: none;
            }
            
            .no-schedules {
                text-align: center;
                padding: 40px;
                color: #7f8c8d;
            }
            
            .no-schedules i {
                font-size: 4rem;
                color: #bdc3c7;
                margin-bottom: 20px;
            }
            
            .page-title {
                color: #2c3e50;
                font-size: 36px;
                font-weight: 700;
                text-align: center;
                margin-bottom: 30px;
                text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            
            @media (max-width: 768px) {
                .main-container {
                    margin: -30px 0 30px 0;
                    padding: 20px;
                }
                
                .tutor-info-grid {
                    grid-template-columns: 1fr;
                }
                
                .page-title {
                    font-size: 28px;
                }
            }
        </style>
    </head>
    <body id="bg">
        <%
            User user = (User) session.getAttribute("user");
        %>
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper booking-page">
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
                                                <li><a href="myschedule"><fmt:message key="my_schedule"/></a></li>
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
                <div class="main-container">
                    <a href="Tutor" class="btn-back">
                        <i class="fa fa-arrow-left"></i> <fmt:message key="back"/>
                    </a>
                    
                    <h1 class="page-title"><fmt:message key="book_schedule"/></h1>
                    
                    <div class="row">
                        <aside class="col-md-3">
                            <div class="sidebar">
                                <h4><fmt:message key="subject"/>:</h4>
                                <div class="subject-select">
                                    <form action="BookSchedule" method="GET">
                                        <select name="subjectId" onchange="this.form.submit()">
                                            <option value="" ${empty param.subjectId ? 'selected' : ''}><fmt:message key="all"/></option>
                                            <c:forEach var="subject" items="${allSubjects}">
                                                <option value="${subject.subjectID}" ${subject.subjectID eq param.subjectId ? 'selected' : ''}>
                                                    ${subject.subjectName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </form>
                </div>
                
                                <h4 class="mt-3"><fmt:message key="tutor"/>:</h4>
                                <ul class="tutor-list">
                                    <c:choose>
                                        <c:when test="${empty tutorsBySubject}">
                                            <li class="text-danger">
                                                <fmt:message key="no_tutor_for_subject"/> 
                                                <c:forEach var="subject" items="${allSubjects}">
                                                    <c:if test="${subject.subjectID eq param.subjectId}">
                                                        ${subject.subjectName}
                                                    </c:if>
                                                </c:forEach>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="tutor" items="${tutorsBySubject}">
                                                <li class="${param.tutorId == tutor[0] ? 'active' : ''}">
                                                    <a href="BookSchedule?subjectId=${param.subjectId}&tutorId=${tutor[0]}">
                                                        ${tutor[1]}
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                        </ul>
                    </div>
                        </aside>
                        
                        <main class="col-md-9">
                            <div class="container-fluid">
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger">${error}</div>
                                </c:if>
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success">${success}</div>
                                </c:if>
                                <c:if test="${empty param.tutorId or empty param.subjectId}">
                                    <div class="alert alert-warning"><fmt:message key="select_subject_tutor"/></div>
                                </c:if>
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger">${error}</div>
                                </c:if>
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success">${success}</div>
                                </c:if>
                                <c:if test="${empty param.tutorId or empty param.subjectId}">
                                    <div class="alert alert-warning"><fmt:message key="select_subject_tutor"/></div>
                                </c:if>
                                <c:if test="${not empty selectedTutorId and selectedTutorId > 0}">
                                    <div class="tutor-card">
                                        <div class="tutor-header">
                                                                                         <!-- Debug: Avatar value = "${tutorAvatar}" -->
                                             <c:choose>
                                                 <c:when test="${not empty tutorAvatar and tutorAvatar != 'uploads/default_avatar.jpg'}">
                                                     <img src="${pageContext.request.contextPath}/${tutorAvatar}" alt="Avatar" class="tutor-avatar" onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                                 </c:when>
                                                 <c:otherwise>
                                                     <img src="${pageContext.request.contextPath}/uploads/default_avatar.jpg" alt="Avatar" class="tutor-avatar">
                                                 </c:otherwise>
                                             </c:choose>
                                            <h3 class="tutor-name">${tutorName}</h3>
                </div>
                
                                        <div class="tutor-info-grid">
                                            <div class="info-item">
                                                <strong><fmt:message key="email"/></strong>
                                                <div>${tutorEmail}</div>
                                            </div>
                                            <div class="info-item">
                                                <strong><fmt:message key="phone"/></strong>
                                                <div>${tutorPhone}</div>
                                            </div>
                                            <div class="info-item">
                                                <strong><fmt:message key="rating"/></strong>
                                                <div>${tutorRating}</div>
                        </div>
                                            <div class="info-item">
                                                <strong><fmt:message key="education"/></strong>
                                                <div>${tutorEducation}</div>
                        </div>
                                            <div class="info-item">
                                                <strong><fmt:message key="experience"/></strong>
                                                <div>${tutorExperience}</div>
                                </div>
                                            <div class="info-item">
                                                <strong><fmt:message key="certificates"/></strong>
                                                <div>${tutorCertificates}</div>
                                </div>
                            </div>
                        </div>
                        
                                    <div class="booking-section">
                                        <h4><fmt:message key="booking_slot"/></h4>
                        <c:choose>
                            <c:when test="${not empty scheduleList}">
                                                    <form action="PaymentDetail" method="post">
                                                        <table class="schedule-table">
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
                                                                        <td><input type="radio" name="scheduleIds" value="${schedule.scheduleID}" class="radio-custom"></td>
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
                                                        <input type="hidden" name="tutorId" value="${selectedTutorId}">
                                                        <input type="hidden" name="subjectId" value="${selectedSubjectId}">
                                                        <div class="text-center">
                                                            <button type="submit" class="btn-booking">
                                                                <i class="fa fa-calendar-check"></i> <fmt:message key="booking"/>
                                        </button>
                                    </div>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div class="no-schedules">
                                    <i class="fa fa-calendar-times"></i>
                                    <h4><fmt:message key="no_available_schedules"/></h4>
                                </div>
                            </c:otherwise>
                        </c:choose>
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
