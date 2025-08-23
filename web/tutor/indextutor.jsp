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
        <meta name="description" content="G5 SmartTutor: Empowering Tutors for Effective Teaching" />
        <meta property="og:title" content="G5 SmartTutor: Empowering Tutors for Effective Teaching" />
        <meta property="og:description" content="G5 SmartTutor: Empowering Tutors for Effective Teaching" />
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
                                    <li class="active"><a href="indextutor.jsp"><fmt:message key="home"/></a></li>
                                    <li><a href="CreateSchedule"><fmt:message key="my_schedule"/></a></li>
                                    <li><a href="bookingHistory"><fmt:message key="withdraw"/></a></li>
                                </ul>
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
                                <li data-index="rs-100" 
                                    data-transition="parallaxvertical" 
                                    data-slotamount="default" 
                                    data-hideafterloop="0" 
                                    data-hideslideonmobile="off" 
                                    data-easein="default" 
                                    data-easeout="default" 
                                    data-masterspeed="default" 
                                    data-thumb="error-404.html" 
                                    data-rotate="0" 
                                    data-fstransition="fade" 
                                    data-fsmasterspeed="1500" 
                                    data-fsslotamount="7" 
                                    data-saveperformance="off" 
                                    data-title="<fmt:message key='home'/>" 
                                    data-description="<fmt:message key='manage_teaching_efficiently'/>">
                                    <img src="${pageContext.request.contextPath}/assets/images/slider/slide1.jpg" alt="" 
                                         data-bgposition="center center" 
                                         data-bgfit="cover" 
                                         data-bgrepeat="no-repeat" 
                                         data-bgparallax="10" 
                                         class="rev-slidebg" 
                                         data-no-retina />

                                    <div class="tp-caption tp-shape tp-shapewrapper " 
                                         id="slide-100-layer-1" 
                                         data-x="['center','center','center','center']" data-hoffset="['0','0','0','0']" 
                                         data-y="['middle','middle','middle','middle']" data-voffset="['0','0','0','0']" 
                                         data-width="full"
                                         data-height="full"
                                         data-whitespace="nowrap"
                                         data-type="shape" 
                                         data-basealign="slide" 
                                         data-responsive_offset="off" 
                                         data-responsive="off"
                                         data-frames='[{"from":"opacity:0;","speed":1,"to":"o:1;","delay":0,"ease":"Power4.easeOut"},{"delay":"wait","speed":1,"to":"opacity:0;","ease":"Power4.easeOut"}]'
                                         data-textAlign="['left','left','left','left']"
                                         data-paddingtop="[0,0,0,0]"
                                         data-paddingright="[0,0,0,0]"
                                         data-paddingbottom="[0,0,0,0]"
                                         data-paddingleft="[0,0,0,0]"
                                         style="z-index: 5;background-color:rgba(2, 0, 11, 0.80);border-color:rgba(0, 0, 0, 0);border-width:0px;"> </div>	
                                    <div class="tp-caption Newspaper-Title tp-resizeme" 
                                         id="slide-100-layer-2" 
                                         data-x="['center','center','center','center']" 
                                         data-hoffset="['0','0','0','0']" 
                                         data-y="['top','top','top','top']" 
                                         data-voffset="['250','250','250','240']" 
                                         data-fontsize="['50','50','50','30']"
                                         data-lineheight="['55','55','55','35']"
                                         data-width="full"
                                         data-height="none"
                                         data-whitespace="normal"
                                         data-type="text" 
                                         data-responsive_offset="on" 
                                         data-frames='[{"from":"y:[-100%];z:0;rX:0deg;rY:0;rZ:0;sX:1;sY:1;skX:0;skY:0;","mask":"x:0px;y:0px;s:inherit;e:inherit;","speed":1500,"to":"o:1;","delay":1000,"ease":"Power3.easeInOut"},{"delay":"wait","speed":1000,"to":"auto:auto;","mask":"x:0;y:0;s:inherit;e:inherit;","ease":"Power3.easeInOut"}]'
                                         data-textAlign="['center','center','center','center']"
                                         data-paddingtop="[0,0,0,0]"
                                         data-paddingright="[0,0,0,0]"
                                         data-paddingbottom="[10,10,10,10]"
                                         data-paddingleft="[0,0,0,0]"
                                         style="z-index: 6; font-family:rubik; font-weight:700; text-align:center; white-space: normal;">
                                        <fmt:message key="welcome_tutor"/> <%= user.getFullName()%>
                                    </div>
                                    <div class="tp-caption Newspaper-Subtitle tp-resizeme" 
                                         id="slide-100-layer-3" 
                                         data-x="['center','center','center','center']" 
                                         data-hoffset="['0','0','0','0']" 
                                         data-y="['top','top','top','top']" 
                                         data-voffset="['320','320','320','290']" 
                                         data-width="['800','800','700','420']"
                                         data-height="['100','100','100','120']"
                                         data-whitespace="unset"
                                         data-type="text" 
                                         data-responsive_offset="on"
                                         data-frames='[{"from":"y:[-100%];z:0;rX:0deg;rY:0;rZ:0;sX:1;sY:1;skX:0;skY:0;","mask":"x:0px;y:0px;s:inherit;e:inherit;","speed":1500,"to":"o:1;","delay":1000,"ease":"Power3.easeInOut"},{"delay":"wait","speed":1000,"to":"auto:auto;","mask":"x:0;y:0;s:inherit;e:inherit;","ease":"Power3.easeInOut"}]'
                                         data-textAlign="['center','center','center','center']"
                                         data-paddingtop="[0,0,0,0]"
                                         data-paddingright="[0,0,0,0]"
                                         data-paddingbottom="[0,0,0,0]"
                                         data-paddingleft="[0,0,0,0]"
                                         style="z-index: 7; text-transform:capitalize; white-space: unset; color:#fff; font-family:rubik; font-size:18px; line-height:28px; font-weight:400;">
                                        <fmt:message key="manage_teaching_efficiently"/>
                                    </div>
                                </li>
                            </ul>
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