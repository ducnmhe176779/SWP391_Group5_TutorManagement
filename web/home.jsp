<%@ page import="entity.User" %>
<%@page import="model.DAOTutorRating"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
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

        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <title>G5 SmartTutor</title>
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
            DAOTutorRating dao = new DAOTutorRating();
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
                                    <li><a href="login.jsp"><fmt:message key="login"/></a></li>
                                    <li><a href="register.jsp"><fmt:message key="register"/></a></li>
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
                                                <li><a href="profile.jsp"><fmt:message key="my_profile"/></a></li>
                                                <li><a href="StudentPaymentHistory.jsp"><fmt:message key="history_payment"/></a></li>
                                                <li><a href="cv.jsp"><fmt:message key="become_a_tutor"/></a></li>
                                                <li><a href="logout.jsp"><fmt:message key="logout"/></a></li>
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
                            <div class="secondary-menu">
                                <div class="secondary-inner">
                                    <ul>
                                        <!--                                    <li><a href="javascript:;" class="btn-link"><i class="fa fa-facebook"></i></a></li>
                                                                            <li><a href="javascript:;" class="btn-link"><i class="fa fa-google-plus"></i></a></li>
                                                                            <li><a href="javascript:;" class="btn-link"><i class="fa fa-linkedin"></i></a></li>
                                                                            <li class="search-btn"><button id="quik-search-btn" type="button" class="btn-link"><i class="fa fa-search"></i></button></li>-->
                                    </ul>
                                </div>
                            </div>
                            <div class="nav-search-bar">
                                <form action="#">
                                    <input name="search" value="" type="text" class="form-control" placeholder="<fmt:message key='type_to_search'/>">
                                    <span><i class="ti-search"></i></span>
                                </form>
                                <span id="search-remove"><i class="ti-close"></i></span>
                            </div>
                            <div class="menu-links navbar-collapse collapse justify-content-start" id="menuDropdown">
                                <div class="menu-logo">
                                    <a href="home"><img src="${pageContext.request.contextPath}/assets/images/logo.png" alt=""></a>
                                </div>
                                <ul class="nav navbar-nav">    
                                    <li class="active"><a href="home"><fmt:message key="home"/></a></li>
                                    <li><a href="Tutor"><fmt:message key="our_tutor"/></a></li>
                                    <li><a href="ViewBlog"><fmt:message key="blog"/></a></li>
                                        <c:if test="${sessionScope.user != null && sessionScope.user.roleID == 3}">
                                        <li><a href="CreateSchedule"><fmt:message key="view_schedule"/></a></li>
                                        </c:if>
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

            <div class="page-content bg-white">
                <div class="rev-slider">
                    <div id="rev_slider_486_1_wrapper" class="rev_slider_wrapper fullwidthbanner-container" data-alias="news-gallery36" data-source="gallery" style="margin:0px auto;background-color:#ffffff;padding:0px;margin-top:0px;margin-bottom:0px;">
                        <div id="rev_slider_486_1" class="rev_slider fullwidthabanner" style="display:none;" data-version="5.3.0.2">
                            <ul>
                                <li data-index="rs-100" data-transition="parallaxvertical" data-slotamount="default" data-hideafterloop="0" data-hideslideonmobile="off" data-easein="default" data-easeout="default" data-masterspeed="default" data-thumb="error-404.html" data-rotate="0" data-fstransition="fade" data-fsmasterspeed="1500" data-fsslotamount="7" data-saveperformance="off" data-title="A STUDY ON HAPPINESS" data-description="Science says that Women are generally happier">
                                    <img src="${pageContext.request.contextPath}/assets/images/slider/slide1.jpg" alt="" data-bgposition="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-bgparallax="10" class="rev-slidebg" data-no-retina />
                                    <div class="tp-caption tp-shape tp-shapewrapper" id="slide-100-layer-1" data-x="['center','center','center','center']" data-hoffset="['0','0','0','0']" data-y="['middle','middle','middle','middle']" data-voffset="['0','0','0','0']" data-width="full" data-height="full" data-whitespace="nowrap" data-type="shape" data-basealign="slide" data-responsive_offset="off" data-responsive="off" data-frames='[{"from":"opacity:0;","speed":1,"to":"o:1;","delay":0,"ease":"Power4.easeOut"},{"delay":"wait","speed":1,"to":"opacity:0;","ease":"Power4.easeOut"}]' data-textAlign="['left','left','left','left']" data-paddingtop="[0,0,0,0]" data-paddingright="[0,0,0,0]" data-paddingbottom="[0,0,0,0]" data-paddingleft="[0,0,0,0]" style="z-index: 5;background-color:rgba(2, 0, 11, 0.80);border-color:rgba(0, 0, 0, 0);border-width:0px;"></div>    
                                    <div class="tp-caption Newspaper-Title tp-resizeme" id="slide-100-layer-2" data-x="['center','center','center','center']" data-hoffset="['0','0','0','0']" data-y="['top','top','top','top']" data-voffset="['250','250','250','240']" data-fontsize="['50','50','50','30']" data-lineheight="['55','55','55','35']" data-width="full" data-height="none" data-whitespace="normal" data-type="text" data-responsive_offset="on" data-frames='[{"from":"y:[-100%];z:0;rX:0deg;rY:0;rZ:0;sX:1;sY:1;skX:0;skY:0;","mask":"x:0px;y:0px;s:inherit;e:inherit;","speed":1500,"to":"o:1;","delay":1000,"ease":"Power3.easeInOut"},{"delay":"wait","speed":1000,"to":"auto:auto;","mask":"x:0;y:0;s:inherit;e:inherit;","ease":"Power3.easeInOut"}]' data-textAlign="['center','center','center','center']" data-paddingtop="[0,0,0,0]" data-paddingright="[0,0,0,0]" data-paddingbottom="[10,10,10,10]" data-paddingleft="[0,0,0,0]" style="z-index: 6; font-family:rubik; font-weight:700; text-align:center; white-space: normal;">
                                        <fmt:message key="welcome_message"/>
                                    </div>
                                    <div class="tp-caption Newspaper-Subtitle tp-resizeme" id="slide-100-layer-3" data-x="['center','center','center','center']" data-hoffset="['0','0','0','0']" data-y="['top','top','top','top']" data-voffset="['210','210','210','210']" data-width="none" data-height="none" data-whitespace="nowrap" data-type="text" data-responsive_offset="on" data-frames='[{"from":"y:[-100%];z:0;rX:0deg;rY:0;rZ:0;sX:1;sY:1;skX:0;skY:0;","mask":"x:0px;y:0px;s:inherit;e:inherit;","speed":1500,"to":"o:1;","delay":1000,"ease":"Power3.easeInOut"},{"delay":"wait","speed":1000,"to":"auto:auto;","mask":"x:0;y:0;s:inherit;e:inherit;","ease":"Power3.easeInOut"}]' data-textAlign="['center','center','center','center']" data-paddingtop="[0,0,0,0]" data-paddingright="[0,0,0,0]" data-paddingbottom="[0,0,0,0]" data-paddingleft="[0,0,0,0]" style="z-index: 7; white-space: nowrap; color:#fff; font-family:rubik; font-size:18px; font-weight:400;">
                                        <fmt:message key="better_education"/>
                                    </div>
                                    <div class="tp-caption Newspaper-Subtitle tp-resizeme" id="slide-100-layer-4" data-x="['center','center','center','center']" data-hoffset="['0','0','0','0']" data-y="['top','top','top','top']" data-voffset="['320','320','320','290']" data-width="['800','800','700','420']" data-height="['100','100','100','120']" data-whitespace="unset" data-type="text" data-responsive_offset="on" data-frames='[{"from":"y:[-100%];z:0;rX:0deg;rY:0;rZ:0;sX:1;sY:1;skX:0;skY:0;","mask":"x:0px;y:0px;s:inherit;e:inherit;","speed":1500,"to":"o:1;","delay":1000,"ease":"Power3.easeInOut"},{"delay":"wait","speed":1000,"to":"auto:auto;","mask":"x:0;y:0;s:inherit;e:inherit;","ease":"Power3.easeInOut"}]' data-textAlign="['center','center','center','center']" data-paddingtop="[0,0,0,0]" data-paddingright="[0,0,0,0]" data-paddingbottom="[0,0,0,0]" data-paddingleft="[0,0,0,0]" style="z-index: 7; text-transform:capitalize; white-space: unset; color:#fff; font-family:rubik; font-size:18px; line-height:28px; font-weight:400;">
                                        <fmt:message key="g5_description"/>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="content-block">
                        <div class="section-area content-inner service-info-bx">
                            <div class="container">
                                <div class="row">
                                    <div class="col-lg-4 col-md-4 col-sm-6">
                                        <div class="service-bx">
                                            <div class="action-box">
                                                <img src="${pageContext.request.contextPath}/assets/images/our-services/pic1.jpg" alt="">
                                            </div>
                                            <div class="info-bx text-center">
                                                <div class="feature-box-sm radius bg-white">
                                                    <i class="fa fa-bank text-primary"></i>
                                                </div>
                                                <h4><a href="Tutor"><fmt:message key="all_tutors"/></a></h4>
                                                <a href="Tutor" class="btn radius-xl"><fmt:message key="view_more"/></a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-6">
                                        <div class="service-bx">
                                            <div class="action-box">
                                                <img src="${pageContext.request.contextPath}/assets/images/our-services/pic2.jpg" alt="">
                                            </div>
                                            <div class="info-bx text-center">
                                                <div class="feature-box-sm radius bg-white">
                                                    <i class="fa fa-book text-primary"></i>
                                                </div>
                                                <h4><a href="Tutor"><fmt:message key="all_subjects"/></a></h4>
                                                <a href="Tutor" class="btn radius-xl"><fmt:message key="view_more"/></a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-4 col-sm-12">
                                        <div class="service-bx m-b0">
                                            <div class="action-box">
                                                <img src="${pageContext.request.contextPath}/assets/images/our-services/pic3.jpg" alt="">
                                            </div>
                                            <div class="info-bx text-center">
                                                <div class="feature-box-sm radius bg-white">
                                                    <i class="fa fa-file-text-o text-primary"></i>
                                                </div>
                                                <h4><a href="myschedule"><fmt:message key="my_schedule"/></a></h4>
                                                <a href="myschedule" class="btn radius-xl"><fmt:message key="view_more"/></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="section-area section-sp2 popular-courses-bx">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-12 heading-bx left">
                                        <h2 class="title-head"><fmt:message key="top_tutors"/></h2>
                                        <p><fmt:message key="top_tutors_desc"/></p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="courses-carousel owl-carousel owl-btn-1 col-12 p-lr0">
                                        <c:forEach var="tutor" items="${topTutors}">
                                            <div class="item">
                                                <div class="cours-bx">
                                                    <div class="action-box">
                                                        <img src="${tutor.cv.user.avatar}" alt="Avatar">
                                                        <a href="Tutor" class="btn"><fmt:message key="view_more"/></a>
                                                    </div>
                                                    <div class="info-bx text-center">
                                                        <h5><a href="#">${tutor.cv.user.fullName}</a></h5>
                                                    </div>
                                                    <div class="cours-more-info">
                                                        <div class="review">
                                                            <ul class="cours-star">
                                                                <c:set var="rating" value="${tutor.rating}" />
                                                                <!-- Hiển thị sao đầy đủ -->
                                                                <c:forEach var="i" begin="1" end="5">
                                                                    <c:choose>
                                                                        <c:when test="${i <= rating}">
                                                                            <li class="active"><i class="fa fa-star"></i></li>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                            <li><i class="fa fa-star"></i></li>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                            </ul>
                                                        </div>
                                                        <div class="price">
                                                            <small>${tutor.cv.user.email}</small>
                                                            <p><fmt:formatNumber value="${tutor.price}" type="number" groupingUsed="true" /> VND</p>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="section-area section-sp2 bg-fix ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/background/bg1.jpg);">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-12 text-white heading-bx left">
                                        <h2 class="title-head text-uppercase"><fmt:message key="top_subjects"/></h2>
                                        <p><fmt:message key="top_subjects_desc"/></p>
                                    </div>
                                </div>
                                <div class="testimonial-carousel owl-carousel owl-btn-1 col-12 p-lr0">
                                    <c:forEach var="subject" items="${topSubjects}" varStatus="status">
                                        <div class="item">
                                            <div class="testimonial-bx">
                                                <div class="testimonial-info">
                                                    <a href="#"><h5 class="name">Top ${status.index + 1}: ${subject.subjectName}</h5></a>
                                                    <p>Booking Count: ${subject.bookingCount}</p>
                                                </div>
                                                <div class="testimonial-content">
                                                    <p>Description: ${subject.description}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
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
                                        <a href="home"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt=""/></a>
                                    </div>
                                    <!--                                <div class="pt-social-link">
                                                                        <ul class="list-inline m-a0">
                                                                            <li><a href="#" class="btn-link"><i class="fa fa-facebook"></i></a></li>
                                                                            <li><a href="#" class="btn-link"><i class="fa fa-twitter"></i></a></li>
                                                                            <li><a href="#" class="btn-link"><i class="fa fa-linkedin"></i></a></li>
                                                                            <li><a href="#" class="btn-link"><i class="fa fa-google-plus"></i></a></li>
                                                                        </ul>
                                                                    </div>
                                                                    <div class="pt-btn-join">
                                                                        <a href="#" class="btn"><fmt:message key="join_now"/></a>
                                                                    </div>-->
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
            <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>
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
                                                        viewPort: {enable: true, outof: "pause", visible_area: "80%", presize: false},
                                                        responsiveLevels: [1240, 1024, 778, 480],
                                                        visibilityLevels: [1240, 1024, 778, 480],
                                                        gridwidth: [1240, 1024, 778, 480],
                                                        gridheight: [768, 600, 600, 600],
                                                        lazyType: "none",
                                                        parallax: {type: "scroll", origo: "enterpoint", speed: 400, levels: [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 46, 47, 48, 49, 50, 55], type: "scroll"},
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
                                                        fallbacks: {simplifyAll: "off", nextSlideOnWindowFocus: "off", disableFocusListener: false}
                                                    });
                                                }
                                            });
            </script>
    </body>
</html>