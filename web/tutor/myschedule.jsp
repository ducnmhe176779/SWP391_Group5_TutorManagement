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

    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

    <!-- FullCalendar CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.css">

    <!-- Trang CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/layers.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/settings.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/revolution/css/navigation.css">

        <title>G5 SmartTutor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
        <!-- Header từ indextutor.jsp -->
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
                                <li class="active"><a href="${pageContext.request.contextPath}/tutor/schedule-management"><fmt:message key="my_schedule"/></a></li>
                                <li><a href="bookingHistory"><fmt:message key="withdraw"/></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Nội dung chính của CreateSchedule.jsp -->
        <div class="page-content bg-white">
            <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/banner/banner1.jpg);">
                <div class="container">
                    <div class="page-banner-entry">
                        <h1 class="text-white"><fmt:message key="my_schedule"/></h1>
                    </div>
                </div>
            </div>
            <div class="container mt-4">
                <a href="indextutor.jsp" class="btn btn-primary mb-3"><fmt:message key="back"/></a>
                <h3><fmt:message key="my_schedule"/></h3>
                <form method="GET" id="searchForm" class="mb-3">
                    <div class="input-group">
                        <input type="text" id="searchInput" name="search" placeholder="<fmt:message key='search_by_subject'/>" 
                               class="form-control" value="${param.search}" />
                        <button type="submit" class="btn btn-primary"><fmt:message key="search"/></button>
                    </div>
                </form>
                <div id="calendar"></div>
            </div>
        </div>

        <!-- Footer từ indextutor.jsp -->
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

    <!-- Scripts từ indextutor.jsp -->
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

    <!-- FullCalendar Scripts -->
    <script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.js"></script>

    <!-- Script cho FullCalendar -->
    <script>
        $(document).ready(function () {
            var events = [];
            const contextPath = "${pageContext.request.contextPath}";
            console.log("Dữ liệu schedules:", "${schedules}");
            <c:forEach var="schedule" items="${schedules}" varStatus="loop">
                console.log("Schedule:", "${schedule.title}", "${schedule.start}", "${schedule.end}", "${schedule.bookingStatus}");
                events.push({
                    title: "${schedule.StudentName} - ${schedule.SubjectName}", // Hiển thị tên học sinh và môn học
                    start: "${schedule.StartTime}",
                    end: "${schedule.EndTime}",
                    bookingID: "${schedule.ScheduleID}",
                    bookingStatus: "${schedule.Status}"
                });
            </c:forEach>
            console.log("Mảng events sau khi xử lý:", events);

            if (events.length === 0) {
                $('#calendar').html('<p class="text-center text-danger"><fmt:message key="no_schedule"/></p>');
            }
            $('#calendar').fullCalendar({
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay,listWeek'
                },
                editable: true,
                eventLimit: true,
                events: events,
                eventRender: function(event, element, view) {
                    // Thêm logic hiển thị nút "Review" nếu cần
                }
            });
        });
    </script>
</body>
</html>