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
        <script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.css">

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
                                        <select class="header-lang-bx" onchange="window.location.href = 'LanguageServlet?lang=' + this.value;">
                                            <option value="en" ${sessionScope.locale == null || sessionScope.locale == 'en' ? 'selected' : ''}><fmt:message key="english"/></option>
                                            <option value="vi" ${sessionScope.locale == 'vi' ? 'selected' : ''}><fmt:message key="vietnamese"/></option>
                                        </select>
                                    </li>
                                    <% if (user == null) { %>
                                    <li><a href="login"><fmt:message key="login"/></a></li>
                                    <li><a href="User?service=registerUser"><fmt:message key="register"/></a></li>
                                        <%} else {%>
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
                                                <li><a href="/logout"><fmt:message key="logout"/></a></li>
                                            </ul>
                                        </div>
                                    </li>
                                    <%}%>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="sticky-header navbar-expand-lg">
                    <div class="menu-bar clearfix">
                        <div class="container clearfix">
                            <div class="menu-logo">
                                <a href="indextutor.jsp"><img src="assets/images/logo-white.png" alt=""></a>
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
                                    <a href="indextutor.jsp"><img src="assets/images/logo.png" alt=""></a>
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
                <div class="page-banner ovbl-dark" style="background-image:url(assets/images/banner/banner1.jpg);">
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
            <footer>
                <div class="footer-top">
                    <div class="pt-exebar">
                        <div class="container">
                            <div class="d-flex align-items-stretch">
                                <div class="pt-logo mr-auto">
                                    <a href="indextutor.jsp.jsp"><img src="assets/images/logo-white.png" alt=""/></a>
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
        <script src="admin/assets/js/jquery.min.js"></script>
        <script src="admin/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="admin/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="admin/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
        <script src="admin/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="admin/assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="admin/assets/vendors/counter/waypoints-min.js"></script>
        <script src="admin/assets/vendors/counter/counterup.min.js"></script>
        <script src="admin/assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="admin/assets/vendors/masonry/masonry.js"></script>
        <script src="admin/assets/vendors/masonry/filter.js"></script>
        <script src="admin/assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src='admin/assets/vendors/scroll/scrollbar.min.js'></script>
        <script src="admin/assets/js/functions.js"></script>
        <script src="admin/assets/vendors/chart/chart.min.js"></script>
        <script src="admin/assets/js/admin.js"></script>
        <script src='admin/assets/vendors/calendar/moment.min.js'></script>
        <script src='admin/assets/vendors/calendar/fullcalendar.js'></script>
        <script src='admin/assets/vendors/switcher/switcher.js'></script>
        <script>
                                            $(document).ready(function () {
                                                var events = [];
                                                const contextPath = "${pageContext.request.contextPath}";
                                                console.log("Dữ liệu schedules:", "${schedules}");
            <c:forEach var="schedule" items="${schedules}" varStatus="loop">
                                                console.log("Schedule:", "${schedule.title}", "${schedule.start}", "${schedule.end}");
                                                events.push({
                                                    title: "${schedule.title}",
                                                    start: "${schedule.start}",
                                                    end: "${schedule.end}",
                                                    bookingID: "${schedule.bookingID}"
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
                                                    eventRender: function (event, element, view) {
                                                        // Debug: Kiểm tra giá trị
                                                        console.log("View name:", view.name, "Event:", event.title);
                                                        // Trích xuất trạng thái từ title
                                                        var titleParts = event.title.split(" - ");
                                                        var status = titleParts.length > 1 ? titleParts[titleParts.length - 1].trim().toLowerCase() : "";
                                                        console.log("Trích xuất status từ title:", status);
                                                        // Hiển thị nút "Confirm Completion" cho trạng thái không phải "completed" và không phải "pending" trong chế độ listWeek
                                                        if (view.name === "listWeek" && status !== "completed" && status !== "pending") {
                                                            console.log("Điều kiện thỏa mãn, thêm nút Confirm Completion cho sự kiện:", event.title);
                                                            var titleElement = element.find('.fc-list-item-title');
                                                            if (titleElement.length > 0) {
                                                                console.log("Tìm thấy .fc-list-item-title, thêm liên kết Confirm Completion...");
                                                                titleElement.append(
                                                                        ' <a href="javascript:void(0)" onclick="if(confirm(\'Cần đảm bảo rằng học sinh đã thực sự tham gia và xác nhận sự có mặt trong buổi học.!\')){window.location.href=\'' + contextPath + '/tutor/ViewTutorSchedule?service=confirmCompletion&bookingId=' + event.bookingID + '\';}" class="btn btn-success btn-sm confirm-btn">Confirm Completion</a>'
                                                                        );
                                                            } else {
                                                                console.log("Không tìm thấy .fc-list-item-title cho sự kiện:", event.title);
                                                            }
                                                        }
                                                    }
                                                });
                                            });
        </script>
        <style>
            /* Đẩy các nút "Review" và "Confirm Completion" sát bên phải */
            .fc-list-item-title {
                position: relative;
                padding-right: 120px; /* Tăng padding để có đủ không gian cho các nút */
            }
            .confirm-btn {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                text-decoration: none; /* Bỏ gạch chân cho liên kết */
            }
            .confirm-btn {
                right: 10px; /* Nút Confirm Completion ở cùng vị trí vì không hiển thị cùng lúc với Review */
            }
        </style>

    </body>
</html>