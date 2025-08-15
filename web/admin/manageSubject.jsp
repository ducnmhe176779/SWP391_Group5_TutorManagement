<%@page import="entity.User"%>
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

        <link rel="icon" href="${pageContext.request.contextPath}/error-404.jsp" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <title>G5 SmartTutor</title>

        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

        <style>
            .message { color: green; margin-bottom: 10px; font-weight: bold; }
            .error { color: red; margin-bottom: 10px; font-weight: bold; }
            
            .table { background-color: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            .table thead th { background-color: #007bff !important; color: white !important; border: none !important; padding: 15px 12px !important; font-weight: 600 !important; }
            .table tbody tr:hover { background-color: #f8f9ff !important; transform: translateY(-1px); }
            
            .btn-update { background-color: #007bff !important; color: white !important; padding: 8px 16px !important; border-radius: 4px !important; text-decoration: none !important; margin-right: 8px !important; }
            .btn-deactivate { background-color: #6c757d !important; color: white !important; padding: 8px 16px !important; border-radius: 4px !important; text-decoration: none !important; }
            .btn-add-subject { background-color: #007bff !important; color: white !important; padding: 12px 24px !important; border-radius: 6px !important; text-decoration: none !important; font-weight: 600 !important; }
            
            .search-box { display: flex; align-items: center; }
            .search-input { width: 300px !important; padding: 10px 15px !important; border: 2px solid #e9ecef !important; border-radius: 25px !important; margin-right: 10px !important; }
            .btn-search { background-color: #007bff !important; color: white !important; padding: 10px 15px !important; border-radius: 50% !important; width: 45px !important; height: 45px !important; border: none !important; }
            .search-result-info { background-color: #e3f2fd !important; border: 1px solid #2196f3 !important; border-radius: 8px !important; padding: 15px 20px !important; margin-bottom: 20px !important; color: #1976d2 !important; }
            .clear-search { color: #f44336 !important; text-decoration: none !important; padding: 5px 10px !important; border-radius: 4px !important; }
            
            .pagination-info { margin-top: 20px; text-align: center; }
            .pagination-controls { display: flex; justify-content: center; align-items: center; gap: 5px; }
            .pagination-controls .btn { padding: 8px 12px; border: 1px solid #ddd; background: #fff; color: #333; text-decoration: none; border-radius: 4px; }
            .pagination-controls .btn-primary { background: #007bff; border-color: #007bff; color: #fff; }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <%
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            if (user.getRoleID() != 1) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
        %>
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <header class="ttr-header">
            <div class="ttr-header-wrapper">
                <div class="ttr-toggle-sidebar ttr-material-button">
                    <i class="ti-close ttr-open-icon"></i>
                    <i class="ti-menu ttr-close-icon"></i>
                </div>
                <div class="ttr-logo-box">
                    <div>
                        <a href="${pageContext.request.contextPath}/admin" class="ttr-logo">
                            <img class="ttr-logo-mobile" alt="" src="${pageContext.request.contextPath}/assets/images/logo-mobile.png" width="30" height="30">
                            <img class="ttr-logo-desktop" alt="" src="${pageContext.request.contextPath}/assets/images/logo-white.png" width="160" height="27">
                        </a>
                    </div>
                </div>
                <div class="ttr-header-menu">
                    <ul class="ttr-header-navigation">
                        <li><a href="${pageContext.request.contextPath}/admin" class="ttr-material-button ttr-submenu-toggle"><fmt:message key="home"/></a></li>
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
                            <a href="${pageContext.request.contextPath}/admin" class="ttr-material-button ttr-submenu-toggle">
                                <span class="ttr-user-avatar">
                                    <img alt="" src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" width="32" height="32" onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                </span>
                            </a>
                            <div class="ttr-header-submenu">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/admin/profile">My Profile</a></li>
                                    <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="ttr-sidebar">
            <div class="ttr-sidebar-wrapper content-scroll">
                <div class="ttr-sidebar-logo">
                    <a href="${pageContext.request.contextPath}/admin"><img alt="" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27"></a>
                    <div class="ttr-sidebar-toggle-button">
                        <i class="ti-arrow-left"></i>
                    </div>
                </div>
                <nav class="ttr-sidebar-navi">
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-home"></i></span>
                                <span class="ttr-label"><fmt:message key="dashboard"/></span>
                            </a>
                        </li>
                        <li>
                            <a href="#" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-briefcase"></i></span>
                                <span class="ttr-label"><fmt:message key="subject_management"/></span>
                                <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                            </a>
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject" class="ttr-material-button"><span class="ttr-label"><fmt:message key="control_subject"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/addSubject.jsp" class="ttr-material-button"><span class="ttr-label"><fmt:message key="add_subject"/></span></a></li>
                            </ul>
                        </li>
                        <li class="ttr-seperate"></li>
                    </ul>
                </nav>
            </div>
        </div>

        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title"><fmt:message key="subject_management"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/admin"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                        <li><fmt:message key="subject_management"/></li>
                    </ul>
                </div>
                <div class="row">
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="subject_list"/></h4>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="${pageContext.request.contextPath}/admin/addSubject.jsp" class="btn btn-add-subject"><fmt:message key="add_subject"/></a>
                                    <div class="search-box">
                                        <form action="${pageContext.request.contextPath}/admin/AdminSubjectController" method="get" class="d-flex">
                                            <input type="hidden" name="service" value="listSubject">
                                            <input type="text" name="search" class="form-control search-input" placeholder="Tìm kiếm môn học..." value="${param.search}">
                                            <button type="submit" class="btn btn-search">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${not empty sessionScope.message}">
                                <div class="message">${sessionScope.message}</div>
                                <c:remove var="message" scope="session" />
                            </c:if>
                            <c:if test="${not empty sessionScope.error}">
                                <div class="error">${sessionScope.error}</div>
                                <c:remove var="error" scope="session" />
                            </c:if>
                            
                            <c:if test="${not empty param.search}">
                                <div class="search-result-info">
                                    <i class="fa fa-search"></i>
                                    Kết quả tìm kiếm cho: "<strong>${param.search}</strong>"
                                    <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject" class="clear-search">
                                        <i class="fa fa-times"></i> Xóa tìm kiếm
                                    </a>
                                </div>
                            </c:if>
                            
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><fmt:message key="id"/></th>
                                            <th><fmt:message key="subject_name"/></th>
                                            <th><fmt:message key="description"/></th>
                                            <th><fmt:message key="status"/></th>
                                            <th><fmt:message key="actions"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="subject" items="${subjectList}">
                                            <tr>
                                                <td>${subject.subjectID}</td>
                                                <td>${subject.subjectName}</td>
                                                <td>${subject.description}</td>
                                                <td><fmt:message key="${subject.status == 'Active' ? 'active' : 'inactive'}"/></td>
                                                <td class="action-links">
                                                    <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=updateSubject&subjectID=${subject.subjectID}" class="btn btn-update"><fmt:message key="update"/></a>
                                                    <c:if test="${subject.status == 'Active'}">
                                                        <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=deleteSubject&subjectID=${subject.subjectID}" class="btn btn-deactivate" onclick="return confirm('<fmt:message key="confirm_deactivate_subject"/> ${subject.subjectID}?')"><fmt:message key="deactivate"/></a>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <c:if test="${empty subjectList}">
                                    <p class="error"><fmt:message key="no_subjects_found"/></p>
                                </c:if>
                                
                                <c:if test="${totalRecords > 0}">
                                    <div class="pagination-info">
                                        <div class="pagination-stats">
                                            <fmt:message key="showing"/> ${startIndex} - ${endIndex} <fmt:message key="of"/> ${totalRecords} <fmt:message key="subjects"/>
                                        </div>
                                        
                                        <div class="pagination-controls">
                                            <c:if test="${currentPage > 1}">
                                                <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject&page=1<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.tutorSearch}">&tutorSearch=${param.tutorSearch}</c:if>" class="btn btn-sm">
                                                    <i class="fa fa-angle-double-left"></i> <fmt:message key="first"/>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject&page=${currentPage - 1}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.tutorSearch}">&tutorSearch=${param.tutorSearch}</c:if>" class="btn btn-sm">
                                                    <i class="fa fa-angle-left"></i> <fmt:message key="previous"/>
                                                </a>
                                            </c:if>
                                            
                                            <c:forEach var="i" begin="1" end="${totalPages}">
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <span class="btn btn-sm btn-primary">${i}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject&page=${i}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.tutorSearch}">&tutorSearch=${param.tutorSearch}</c:if>" class="btn btn-sm">${i}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject&page=${currentPage + 1}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.tutorSearch}">&tutorSearch=${param.tutorSearch}</c:if>" class="btn btn-sm">
                                                    <fmt:message key="next"/> <i class="fa fa-angle-right"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject&page=${totalPages}<c:if test="${not empty param.search}">&search=${param.search}</c:if><c:if test="${not empty param.tutorSearch}">&tutorSearch=${param.tutorSearch}</c:if>" class="btn btn-sm">
                                                    <fmt:message key="last"/> <i class="fa fa-angle-double-right"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="tutor_subject_list"/></h4>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="search-box">
                                        <form action="${pageContext.request.contextPath}/admin/AdminSubjectController" method="get" class="d-flex">
                                            <input type="hidden" name="service" value="listSubject">
                                            <input type="text" name="tutorSearch" class="form-control search-input" placeholder="Tìm kiếm tutor-subject..." value="${param.tutorSearch}">
                                            <button type="submit" class="btn btn-search">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${not empty param.tutorSearch}">
                                <div class="search-result-info">
                                    <i class="fa fa-search"></i>
                                    Kết quả tìm kiếm tutor-subject cho: "<strong>${param.tutorSearch}</strong>"
                                    <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject<c:if test="${not empty param.search}">&search=${param.search}</c:if>" class="clear-search">
                                        <i class="fa fa-times"></i> Xóa tìm kiếm
                                    </a>
                                </div>
                            </c:if>
                            
                            <div class="widget-inner">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><fmt:message key="tutor_id"/></th>
                                            <th><fmt:message key="username"/></th>
                                            <th><fmt:message key="subject_id"/></th>
                                            <th><fmt:message key="description"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="tutorSubject" items="${tutorSubjectList}">
                                            <tr>
                                                <td>${tutorSubject.tutorID}</td>
                                                <td>${tutorSubject.userName}</td>
                                                <td>${tutorSubject.subjectID}</td>
                                                <td>${tutorSubject.description}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <c:if test="${empty tutorSubjectList}">
                                    <p class="error"><fmt:message key="no_tutor_subjects_found"/></p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <div class="ttr-overlay"></div>

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
        <script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/calendar/moment.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>
    </body>
</html>
