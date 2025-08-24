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
        <meta name="description" content="G4 SmartTutor : Smart tutor, effective learning." />
        <meta property="og:title" content="G4 SmartTutor : Smart tutor, effective learning." />
        <meta property="og:description" content="G4 SmartTutor : Smart tutor, effective learning." />
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
            <!-- <div id="loading-icon-bx"></div> -->
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
                                    <li class="active"><a href="CreateSchedule"><fmt:message key="my_schedule"/></a></li>
                                    <li><a href="bookingHistory"><fmt:message key="withdraw"/></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <div class="page-content bg-white">
                <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/banner/banner1.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white"><fmt:message key="my_schedule"/></h1>
                        </div>
                    </div>
                </div>
                <div class="container mt-5">
                    <h2 class="text-center"><fmt:message key="create_teaching_schedule"/></h2>
                    <c:if test="${not empty message}">
                        <div class="alert ${message.contains('thành công') || message.contains('successfully') ? 'alert-success' : 'alert-danger'}">
                            ${message}
                        </div>
                    </c:if>
                    <div class="card p-4 shadow mb-5">
                        <form action="CreateSchedule" method="POST">
                            <div class="mb-3">
                                <label for="subject" class="form-label"><fmt:message key="subject"/>:</label>
                                <select class="form-select" name="subject" id="subject">
                                    <c:choose>
                                        <c:when test="${not empty subjectList}">
                                            <c:forEach var="subject" items="${subjectList}">
                                                <option value="${subject.subjectID}">${subject.subjectName}</option>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <option value=""><fmt:message key="no_subjects_available"/></option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </div>

                            <!--                            <div class="mb-3">
                                                            <label for="startTime" class="form-label"><fmtmessage key="start_time"/>:</label>
                                                            <input type="datetime-local" class="form-control" name="startTime" id="startTime">
                                                        </div>-->

                            <div class="mb-3">
                                <label for="slotCount" class="form-label"><fmt:message key="slot"/>:</label>
                                <input type="number" class="form-control" name="slotCount" id="slotCount" min="1" value="1">
                            </div>

                            <div class="mb-3">
                                <label for="duration" class="form-label"><fmt:message key="duration"/>: 60 <fmt:message key="minutes"/></label>
                            </div>

                            <button type="submit" class="btn btn-primary w-100"><fmt:message key="create_schedule"/></button>
                        </form>
                    </div>
                    <h2 class="text-center"><fmt:message key="your_teaching_schedule"/></h2>
                    <div class="card p-4 shadow container">
                        <table class="table table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th><fmt:message key="subject"/></th>
                                    <th><fmt:message key="slot"/></th>
                                    <th><fmt:message key="status"/></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty scheduleList}">
                                        <c:forEach var="schedule" items="${scheduleList}">
                                            <tr>
                                                <td>${schedule.subject.subjectName}</td>
                                                <td>Slot ${schedule.slotNumber}</td>
                                                <td>${schedule.status}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="3" class="text-center"><fmt:message key="no_schedule_yet"/></td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
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
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/jquery.themepunch.tools.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/jquery.themepunch.revolution.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/extensions/revolution.extension.actions.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/extensions/revolution.extension.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/extensions/revolution.extension.kenburn.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/extensions/revolution.extension.layeranimation.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/extensions/revolution.extension.migration.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/extensions/revolution.extension.navigation.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/extensions/revolution.extension.parallax.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/extensions/revolution.extension.slideanims.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/revolution/js/extensions/revolution.extension.video.min.js"></script>
        <script>
                                            jQuery(document).ready(function () {
                                                var ttrevapi;
                                                var tpj = jQuery;
                                                if (tpj("#rev_slider_486_1").revolution == undefined) {
                                                    revslider_showDoubleJqueryError("#rev_slider_486_1");
                                                } else {
                                                    ttrevapi = tpj("#rev_slider_486_1").show().revolution({
                                                        sliderType: "standard",
                                                        jsFileLocation: "${pageContext.request.contextPath}/assets/vendors/revolution/js/",
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
                                                            type: "scroll"
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
                                                            disableFocusListener: false
                                                        }
                                                    });
                                                }
                                            });
        </script>
    </body>
</html>