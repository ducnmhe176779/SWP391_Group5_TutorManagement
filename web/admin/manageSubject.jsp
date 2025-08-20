<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>G5 SmartTutor</title>

        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/custom-blue.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/force-blue.css">

        <style>
            .message { color: green; margin-bottom: 10px; font-weight: bold; }
            .error { color: red; margin-bottom: 10px; font-weight: bold; }
            
            .search-container {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 15px;
            }
            
            .search-box {
                flex: 1;
                min-width: 250px;
            }
            
            .search-box input {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }
            
            .search-box input:focus {
                border-color: #1e40af;
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(30, 64, 175, 0.25);
            }
            
            .search-results-info {
                margin-top: 20px;
                text-align: center;
                padding: 15px;
                background: #e3f2fd;
                border: 1px solid #2196f3;
                border-radius: 8px;
                color: #1976d2;
                font-size: 16px;
                font-weight: 500;
            }
            
            .pagination-container {
                margin-top: 20px;
                text-align: center;
            }
            
            .pagination-controls {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                flex-wrap: wrap;
            }
            
            .pagination-btn {
                padding: 8px 12px;
                border: 1px solid #ddd;
                background: #fff;
                color: #333;
                text-decoration: none;
                border-radius: 4px;
                transition: all 0.3s ease;
                font-size: 14px;
            }
            
            .pagination-btn:hover {
                background: #1e40af;
                color: #fff;
                border-color: #1e40af;
            }
            
            .pagination-current {
                padding: 8px 12px;
                background: #1e40af;
                color: #fff;
                border: 1px solid #1e40af;
                border-radius: 4px;
                font-size: 14px;
                font-weight: bold;
            }
            
            .pagination-arrow {
                padding: 8px 12px;
                border: 1px solid #ddd;
                background: #fff;
                color: #333;
                text-decoration: none;
                border-radius: 4px;
                transition: all 0.3s ease;
                font-size: 14px;
                min-width: 40px;
                text-align: center;
            }
            
            .pagination-arrow:hover {
                background: #1e40af;
                color: #fff;
                border-color: #1e40af;
            }
            
            .pagination-ellipsis {
                padding: 8px 12px;
                color: #666;
                font-size: 14px;
                font-weight: bold;
            }
            
            @media (max-width: 768px) {
                .search-container {
                    flex-direction: column;
                    align-items: stretch;
                }
                
                .search-box {
                    min-width: auto;
                    margin-bottom: 15px;
                }
            }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <%
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        %>
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
                        <a href="${pageContext.request.contextPath}/admin/index" class="ttr-logo">
                            <img class="ttr-logo-mobile" alt="" src="${pageContext.request.contextPath}/assets/images/logo-mobile.png" width="30" height="30">
                            <img class="ttr-logo-desktop" alt="" src="${pageContext.request.contextPath}/assets/images/logo-white.png" width="160" height="27">
                        </a>
                    </div>
                </div>
                <div class="ttr-header-menu">
                    <ul class="ttr-header-navigation">
                        <li><a href="${pageContext.request.contextPath}/admin/index" class="ttr-material-button ttr-submenu-toggle"><fmt:message key="home"/></a></li>
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
                            <a href="${pageContext.request.contextPath}/admin/adminprofile" class="ttr-material-button ttr-submenu-toggle">
                                <span class="ttr-user-avatar">
                                    <img alt="" 
                                         src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                         width="32" height="32"
                                         onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                </span>
                            </a>
                            <div class="ttr-header-submenu">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/admin/adminprofile"><fmt:message key="my_profile"/></a></li>
                                    <li><a href="${pageContext.request.contextPath}/logout"><fmt:message key="logout"/></a></li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Sidebar -->
        <div class="ttr-sidebar">
            <div class="ttr-sidebar-wrapper content-scroll">
                <div class="ttr-sidebar-logo">
                    <a href="${pageContext.request.contextPath}/admin/index"><img alt="" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27"></a>
                    <div class="ttr-sidebar-toggle-button">
                        <i class="ti-arrow-left"></i>
                    </div>
                </div>
                <nav class="ttr-sidebar-navi">
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/index" class="ttr-material-button">
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
                                <li><a href="${pageContext.request.contextPath}/admin/TutorList" class="ttr-material-button"><span class="ttr-label"><fmt:message key="tutor_list"/></span></a></li>
                                <li><a href="AdminListRated" class="ttr-material-button"><span class="ttr-label"><fmt:message key="tutor_reviews"/></span></a></li>
                                <li><a href="RequestCV" class="ttr-material-button"><span class="ttr-label"><fmt:message key="status_cv"/></span></a></li>
                                <li><a href="ViewBooking" class="ttr-material-button"><span class="ttr-label"><fmt:message key="booking_manage"/></span></a></li>
                                <li><a href="AdminViewSchedule" class="ttr-material-button"><span class="ttr-label"><fmt:message key="view_schedule"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject&size=5&tutorSize=5" class="ttr-material-button"><span class="ttr-label"><fmt:message key="subject_management"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-user"></i></span>
                                <span class="ttr-label"><fmt:message key="staff_management"/></span>
                                <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                            </a>
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/admin/StaffList" class="ttr-material-button"><span class="ttr-label"><fmt:message key="staff_list"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/StaffManage" class="ttr-material-button"><span class="ttr-label"><fmt:message key="add_new_staff"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-id-badge"></i></span>
                                <span class="ttr-label"><fmt:message key="user_management"/></span>
                                <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                            </a>
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/admin/UserList" class="ttr-material-button"><span class="ttr-label"><fmt:message key="user_list"/></span></a></li>
                                <li><a href="ReportManager" class="ttr-material-button"><span class="ttr-label"><fmt:message key="report"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-credit-card"></i></span>
                                <span class="ttr-label"><fmt:message key="payment"/></span>
                                <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                            </a>
                            <ul>
                                <li><a href="approveWithdrawal" class="ttr-material-button"><span class="ttr-label"><fmt:message key="request_withdrawal"/></span></a></li>
                                <li><a href="PaymentHistory" class="ttr-material-button"><span class="ttr-label"><fmt:message key="view_history_payment"/></span></a></li>
                                <li><a href="systemRevenue" class="ttr-material-button"><span class="ttr-label"><fmt:message key="system_revenue"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/historyLog" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-clipboard"></i></span>
                                <span class="ttr-label"><fmt:message key="history_log"/></span>
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
                    <h4 class="breadcrumb-title"><fmt:message key="subject_management"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/admin/index"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                        <li><fmt:message key="subject_management"/></li>
                    </ul>
                </div>
                <div class="row">
                    <!-- Bảng 1: Danh sách môn học -->
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="subject_list"/></h4>
                                <a href="${pageContext.request.contextPath}/admin/addSubject.jsp" class="btn" style="margin-top: 6px;"><fmt:message key="add_subject"/></a>
                            </div>
                            
                            <!-- Hiển thị thông báo -->
                            <c:if test="${not empty sessionScope.message}">
                                <div class="message">${sessionScope.message}</div>
                                <c:remove var="message" scope="session" />
                            </c:if>
                            <c:if test="${not empty sessionScope.error}">
                                <div class="error">${sessionScope.error}</div>
                                <c:remove var="error" scope="session" />
                            </c:if>
                            
                            <!-- Thanh tìm kiếm -->
                            <form method="GET" action="${pageContext.request.contextPath}/admin/AdminSubjectController" style="margin-bottom: 20px;">
                                <input type="hidden" name="service" value="listSubject">
                                <input type="hidden" name="size" value="5">
                                <div class="search-container">
                                    <div class="search-box">
                                        <input type="text" id="subjectSearch" name="search" placeholder="Tìm kiếm môn học..."  
                                               value="${searchTerm != null ? searchTerm : ''}">
                                    </div>
                                    <button type="submit" class="btn" style="margin: 0; padding: 10px 20px; font-weight: 500;">Tìm kiếm</button>
                                </div>
                            </form>
                            
                            <div class="table-responsive">
                                <table id="subjectTable">
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
                                                    <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=updateSubject&subjectID=${subject.subjectID}" class="btn"><fmt:message key="update"/></a>
                                                    <c:if test="${subject.status == 'Active'}">
                                                        <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=deleteSubject&subjectID=${subject.subjectID}" class="btn" onclick="return confirm('Are you sure you want to deactivate subject ${subject.subjectID}?')"><fmt:message key="deactivate"/></a>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <c:if test="${empty subjectList}">
                                    <p class="error"><fmt:message key="no_subjects_found"/></p>
                                </c:if>
                                
                                <!-- Phân trang cho Subject List -->
                                <c:choose>
                                    <c:when test="${not empty searchTerm}">
                                        <div class="search-results-info">
                                            <span>Kết quả tìm kiếm: ${fn:length(subjectList)} môn học phù hợp với "${searchTerm}"</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${totalPages > 1}">
                                            <div class="pagination-container">
                                                <div class="pagination-controls">
                                                    <!-- Nút Previous -->
                                                    <c:if test="${currentPage > 1}">
                                                        <a href="?page=${currentPage - 1}&size=${pageSize}&search=${param.search}" class="pagination-btn pagination-arrow">
                                                            <i class="fa fa-chevron-left"></i>
                                                        </a>
                                                    </c:if>
                                                    
                                                    <!-- Các số trang -->
                                                    <c:choose>
                                                        <c:when test="${totalPages <= 7}">
                                                            <c:forEach var="i" begin="1" end="${totalPages}">
                                                                <c:choose>
                                                                    <c:when test="${i == currentPage}">
                                                                        <span class="pagination-current">${i}</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="?page=${i}&size=${pageSize}&search=${param.search}" class="pagination-btn">${i}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <!-- Luôn hiển thị trang 1 -->
                                                            <c:choose>
                                                                <c:when test="${currentPage == 1}">
                                                                    <span class="pagination-current">1</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="?page=1&size=${pageSize}&search=${param.search}" class="pagination-btn">1</a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            
                                                            <!-- Hiển thị dấu ... nếu cần -->
                                                            <c:if test="${currentPage > 3}">
                                                                <span class="pagination-ellipsis">...</span>
                                                            </c:if>
                                                            
                                                            <!-- Hiển thị các trang xung quanh currentPage -->
                                                            <c:forEach var="i" begin="${currentPage - 1}" end="${currentPage + 1}">
                                                                <c:if test="${i > 1 && i < totalPages}">
                                                                    <c:choose>
                                                                        <c:when test="${i == currentPage}">
                                                                            <span class="pagination-current">${i}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="?page=${i}&size=${pageSize}&search=${param.search}" class="pagination-btn">${i}</a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:if>
                                                            </c:forEach>
                                                            
                                                            <!-- Hiển thị dấu ... nếu cần -->
                                                            <c:if test="${currentPage < totalPages - 2}">
                                                                <span class="pagination-ellipsis">...</span>
                                                            </c:if>
                                                            
                                                            <!-- Luôn hiển thị trang cuối -->
                                                            <c:if test="${totalPages > 1}">
                                                                <c:choose>
                                                                    <c:when test="${i == currentPage}">
                                                                        <span class="pagination-current">${totalPages}</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="?page=${totalPages}&size=${pageSize}&search=${param.search}" class="pagination-btn">${totalPages}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    
                                                    <!-- Nút Next -->
                                                    <c:if test="${currentPage < totalPages}">
                                                        <a href="?page=${currentPage + 1}&size=${pageSize}&search=${param.search}" class="pagination-btn pagination-arrow">
                                                            <i class="fa fa-chevron-right"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Bảng 2: Danh sách Tutor-Subject -->
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="tutor_subject_list"/></h4>
                            </div>
                            
                            <div class="widget-inner">
                                <table id="tutorSubjectTable">
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
                                
                                <!-- Phân trang cho Tutor-Subject List -->
                                <c:if test="${totalTutorSubjectPages > 1}">
                                    <div class="pagination-container">
                                        <div class="pagination-controls">
                                            <!-- Nút Previous -->
                                            <c:if test="${currentTutorSubjectPage > 1}">
                                                <a href="?tutorPage=${currentTutorSubjectPage - 1}&tutorSize=${tutorSubjectPageSize}" class="pagination-btn pagination-arrow">
                                                    <i class="fa fa-chevron-left"></i>
                                                </a>
                                            </c:if>
                                            
                                            <!-- Các số trang -->
                                            <c:forEach var="i" begin="1" end="${totalTutorSubjectPages}">
                                                <c:choose>
                                                    <c:when test="${i == currentTutorSubjectPage}">
                                                        <span class="pagination-current">${i}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="?tutorPage=${i}&tutorSize=${tutorSubjectPageSize}" class="pagination-btn">${i}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            
                                            <!-- Nút Next -->
                                            <c:if test="${currentTutorSubjectPage < totalTutorSubjectPages}">
                                                <a href="?tutorPage=${currentTutorSubjectPage + 1}&tutorSize=${tutorSubjectPageSize}" class="pagination-btn pagination-arrow">
                                                    <i class="fa fa-chevron-right"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <div class="ttr-overlay"></div>

        <!-- External JavaScripts -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/admin/assets/js/admin.js"></script>
    </body>
</html>
