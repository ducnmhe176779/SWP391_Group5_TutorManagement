<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
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
        <link rel="icon" href="${pageContext.request.contextPath}/error-404.jsp" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE -->
        <title>G5 SmartTutor</title>

        <!-- MOBILE SPECIFIC -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
        
        <!-- Custom Blue Color Override -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/custom-blue.css">

        <!-- Thêm style cho thông báo -->
        <style>
            .message {
                color: green;
                margin-bottom: 10px;
                font-weight: bold;
            }
            .error {
                color: red;
                margin-bottom: 10px;
                font-weight: bold;
            }
            
            
            
            /* Style cho thanh tìm kiếm và sắp xếp */
            .search-sort-container {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                margin-bottom: 20px;
            }
            
            .search-box input {
                border: 1px solid #ced4da;
                transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            }
            
            .search-box input:focus {
                border-color: #1e40af;
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(30, 64, 175, 0.25);
            }
            
            .sort-controls select {
                border: 1px solid #ced4da;
                transition: border-color 0.15s ease-in-out;
            }
            
            .sort-controls select:focus {
                border-color: #1e40af;
                outline: 0;
            }
            
            /* CSS ĐƠN GIẢN để sửa lỗi font chữ bị trồng lên nhau */
            .sort-controls label {
                font-family: Arial, sans-serif !important;
                font-size: 14px !important;
                font-weight: normal !important;
                line-height: 1.2 !important;
                color: #333 !important;
                white-space: nowrap !important;
                display: inline-block !important;
                margin-right: 10px !important;
                padding: 5px 0 !important;
                letter-spacing: normal !important;
                word-spacing: normal !important;
            }
            
                         /* Style cho search results info */
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
             
             /* Style cho pagination */
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
             
             /* Responsive design */
             @media (max-width: 768px) {
                 .search-sort-container {
                     flex-direction: column;
                     align-items: stretch;
                 }
                 
                 .search-box {
                     min-width: auto;
                     margin-bottom: 15px;
                 }
                 
                 .sort-controls {
                     flex-direction: column;
                     align-items: stretch;
                     gap: 10px;
                 }
                 
                 .pagination-controls {
                     gap: 5px;
                 }
                 
                 .pagination-btn {
                     padding: 6px 10px;
                     font-size: 13px;
                 }
             }
        </style>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar staff">
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

        <!-- Sidebar -->
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

        <!-- Main content -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title"><fmt:message key="subject_management"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                        <li><fmt:message key="subject_management"/></li>
                    </ul>
                </div>
                <div class="row">
                    <!-- Bảng 1: Danh sách môn học -->
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="subject_list"/></h4>
                                <a href="${pageContext.request.contextPath}/staff/SubjectController?service=addSubject" class="btn" style="margin-top: 6px;"><fmt:message key="add_subject"/></a>
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
                            
                            <!-- Thanh tìm kiếm và sắp xếp -->
                            <form method="GET" action="${pageContext.request.contextPath}/staff/SubjectController" style="margin-bottom: 20px;">
                                <input type="hidden" name="service" value="listSubject">
                                <input type="hidden" name="size" value="5">
                                <div class="search-sort-container" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
                                    <!-- Tìm kiếm -->
                                    <div class="search-box" style="flex: 1; min-width: 250px;">
                                        <input type="text" id="subjectSearch" name="search" placeholder="Tìm kiếm môn học..." 
                                               value="${searchTerm != null ? searchTerm : ''}"
                                               style="width: 100%; padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;">
                                    </div>
                                    
                                    <!-- Sắp xếp -->
                                    <div class="sort-controls" style="display: flex; gap: 15px; align-items: center; flex-wrap: nowrap;">
                                        <label for="sortField" style="margin: 0; font-weight: normal; color: #333; font-family: Arial, sans-serif; font-size: 14px; line-height: 1.2; white-space: nowrap; display: inline-block; padding: 5px 0; margin-right: 10px;">Sắp xếp theo:</label>
                                        <select id="sortField" name="sortField" style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; letter-spacing: 0.5px; min-width: 130px; text-rendering: optimizeLegibility;">
                                            <option value="subjectID" ${sortField == 'subjectID' ? 'selected' : ''}>ID</option>
                                            <option value="subjectName" ${sortField == 'subjectName' ? 'selected' : ''}>Tên môn học</option>
                                            <option value="status" ${sortField == 'status' ? 'selected' : ''}>Trạng thái</option>
                                        </select>
                                        <select id="sortOrder" name="sortOrder" style="padding: 10px 15px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; letter-spacing: 0.5px; min-width: 100px; text-rendering: optimizeLegibility;">
                                            <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                                            <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                                        </select>
                                        <button type="submit" class="btn" style="margin: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; font-size: 14px; line-height: 1.6; letter-spacing: 0.5px; text-rendering: optimizeLegibility; padding: 10px 20px; font-weight: 500;">Tìm kiếm</button>
                                        <button type="button" id="resetBtn" class="btn" style="margin: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; font-size: 14px; line-height: 1.6; letter-spacing: 0.5px; text-rendering: optimizeLegibility; padding: 10px 20px; font-weight: 500;">Reset</button>
                                    </div>
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
                                                    <a href="${pageContext.request.contextPath}/staff/SubjectController?service=updateSubject&subjectID=${subject.subjectID}" class="btn"><fmt:message key="update"/></a>
                                                    <c:if test="${subject.status == 'Active'}">
                                                        <a href="${pageContext.request.contextPath}/staff/SubjectController?service=deleteSubject&subjectID=${subject.subjectID}" class="btn" onclick="return confirm('<fmt:message key="confirm_deactivate_subject"/> ${subject.subjectID}?')"><fmt:message key="deactivate"/></a>
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
                                     <c:when test="${isSearchMode}">
                                         <!-- Chế độ search: Hiển thị tất cả kết quả tìm kiếm -->
                                         <div class="search-results-info">
                                             <span>Kết quả tìm kiếm: ${fn:length(subjectList)} môn học phù hợp với "${searchTerm}"</span>
                                         </div>
                                         <!-- Ẩn pagination khi search -->
                                     </c:when>
                                     <c:otherwise>
                                         <!-- Chế độ bình thường: Hiển thị pagination -->
                                         <c:if test="${totalPages > 1}">
                                                                                           <div class="pagination-container">
                                                  <div class="pagination-controls">
                                                      <!-- Nút Previous -->
                                                      <c:if test="${currentPage > 1}">
                                                          <a href="?page=${currentPage - 1}&size=${pageSize}&search=${param.search}&sortField=${param.sortField}&sortOrder=${param.sortOrder}" class="pagination-btn pagination-arrow">
                                                              <i class="fa fa-chevron-left"></i>
                                                          </a>
                                                      </c:if>
                                                      
                                                      <!-- Các số trang với logic hiển thị thông minh -->
                                                      <c:choose>
                                                          <c:when test="${totalPages <= 7}">
                                                              <!-- Nếu ít hơn 7 trang, hiển thị tất cả -->
                                                              <c:forEach var="i" begin="1" end="${totalPages}">
                                                                  <c:choose>
                                                                      <c:when test="${i == currentPage}">
                                                                          <span class="pagination-current">${i}</span>
                                                                      </c:when>
                                                                      <c:otherwise>
                                                                          <a href="?page=${i}&size=${pageSize}&search=${param.search}&sortField=${param.sortField}&sortOrder=${param.sortOrder}" class="pagination-btn">${i}</a>
                                                                      </c:otherwise>
                                                                  </c:choose>
                                                              </c:forEach>
                                                          </c:when>
                                                          <c:otherwise>
                                                              <!-- Nếu nhiều hơn 7 trang, hiển thị thông minh -->
                                                              <!-- Luôn hiển thị trang 1 -->
                                                              <c:choose>
                                                                  <c:when test="${currentPage == 1}">
                                                                      <span class="pagination-current">1</span>
                                                                  </c:when>
                                                                  <c:otherwise>
                                                                      <a href="?page=1&size=${pageSize}&search=${param.search}&sortField=${param.sortField}&sortOrder=${param.sortOrder}" class="pagination-btn">1</a>
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
                                                                              <a href="?page=${i}&size=${pageSize}&search=${param.search}&sortField=${param.sortField}&sortOrder=${param.sortOrder}" class="pagination-btn">${i}</a>
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
                                                                      <c:when test="${currentPage == totalPages}">
                                                                          <span class="pagination-current">${totalPages}</span>
                                                                      </c:when>
                                                                      <c:otherwise>
                                                                          <a href="?page=${totalPages}&size=${pageSize}&search=${param.search}&sortField=${param.sortField}&sortOrder=${param.sortOrder}" class="pagination-btn">${totalPages}</a>
                                                                      </c:otherwise>
                                                                  </c:choose>
                                                              </c:if>
                                                          </c:otherwise>
                                                      </c:choose>
                                                      
                                                      <!-- Nút Next -->
                                                      <c:if test="${currentPage < totalPages}">
                                                          <a href="?page=${currentPage + 1}&size=${pageSize}&search=${param.search}&sortField=${param.sortField}&sortOrder=${param.sortOrder}" class="pagination-btn pagination-arrow">
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
                    <!-- Bảng 2: Danh sách Tutor-Subject với UserName -->
                    <div class="col-lg-12 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="tutor_subject_list"/></h4>
                            </div>
                            
                            <!-- Thanh tìm kiếm và sắp xếp cho Tutor-Subject -->
                            <div class="search-sort-container" style="margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
                                <!-- Tìm kiếm -->
                                <div class="search-box" style="flex: 1; min-width: 250px;">
                                    <input type="text" id="tutorSubjectSearch" placeholder="Tìm kiếm tutor-subject..." 
                                           style="width: 100%; padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;">
                                </div>
                                
                                <!-- Sắp xếp -->
                                <div class="sort-controls" style="display: flex; gap: 15px; align-items: center; flex-wrap: nowrap;">
                                    <label for="tutorSortField" style="margin: 0; font-weight: normal; color: #333; font-family: Arial, sans-serif; font-size: 14px; line-height: 1.2; white-space: nowrap; display: inline-block; padding: 5px 0; margin-right: 10px;">Sắp xếp theo:</label>
                                    <select id="tutorSortField" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.5; letter-spacing: 0.3px; min-width: 120px; text-rendering: optimizeLegibility;">
                                        <option value="tutorID">Tutor ID</option>
                                        <option value="userName">Username</option>
                                        <option value="subjectID">Subject ID</option>
                                    </select>
                                    <select id="tutorSortOrder" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.5; letter-spacing: 0.3px; min-width: 100px; text-rendering: optimizeLegibility;">
                                        <option value="asc">Tăng dần</option>
                                        <option value="desc">Giảm dần</option>
                                    </select>
                                    <button id="tutorSortBtn" class="btn" style="margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 14px; line-height: 1.5; letter-spacing: 0.3px; text-rendering: optimizeLegibility;">Sắp xếp</button>
                                </div>
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
        <script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/calendar/moment.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>
        
        <!-- Script xử lý tìm kiếm và sắp xếp -->
        <script>
            
             
             $(document).ready(function() {
                // Lưu trữ dữ liệu gốc
                let originalSubjectData = [];
                let originalTutorSubjectData = [];
                
                // Lấy dữ liệu từ bảng
                function getTableData(tableId) {
                    const rows = $(tableId + ' tbody tr');
                    const data = [];
                    rows.each(function() {
                        const row = $(this);
                        const cells = row.find('td');
                        const rowData = {
                            element: row,
                            data: []
                        };
                        cells.each(function() {
                            rowData.data.push($(this).text().trim());
                        });
                        data.push(rowData);
                    });
                    return data;
                }
                
                // Khởi tạo dữ liệu
                originalSubjectData = getTableData('#subjectTable');
                originalTutorSubjectData = getTableData('#tutorSubjectTable');
                
                                 // Tìm kiếm cho Subject List - Chỉ xử lý client-side filtering khi không submit form
                 $('#subjectSearch').on('input', function() {
                     // Chỉ áp dụng client-side filtering khi không có search term trong URL
                     const urlParams = new URLSearchParams(window.location.search);
                     const urlSearchTerm = urlParams.get('search');
                     
                     if (!urlSearchTerm || urlSearchTerm === '') {
                         const searchTerm = $(this).val().toLowerCase();
                         filterTable('#subjectTable tbody tr', searchTerm, [1, 2]); // Tìm theo tên môn học và mô tả
                     }
                 });
                
                // Tìm kiếm cho Tutor-Subject List
                $('#tutorSubjectSearch').on('input', function() {
                    const searchTerm = $(this).val().toLowerCase();
                    filterTable('#tutorSubjectTable tbody tr', searchTerm, [0, 1, 2, 3]); // Tìm theo tất cả cột
                });
                
                // Hàm lọc bảng
                function filterTable(selector, searchTerm, columns) {
                    $(selector).each(function() {
                        const row = $(this);
                        let showRow = false;
                        
                        if (searchTerm === '') {
                            showRow = true;
                        } else {
                            columns.forEach(function(colIndex) {
                                const cellText = row.find('td').eq(colIndex).text().toLowerCase();
                                if (cellText.includes(searchTerm)) {
                                    showRow = true;
                                }
                            });
                        }
                        
                        row.toggle(showRow);
                    });
                }
                
                // Sắp xếp cho Subject List
                $('#sortBtn').on('click', function() {
                    const sortField = $('#sortField').val();
                    const sortOrder = $('#sortOrder').val();
                    sortTable('#subjectTable tbody', sortField, sortOrder, originalSubjectData);
                });
                
                // Sắp xếp cho Tutor-Subject List
                $('#tutorSortBtn').on('click', function() {
                    const sortField = $('#tutorSortField').val();
                    const sortOrder = $('#tutorSortOrder').val();
                    sortTable('#tutorSubjectTable tbody', sortField, sortOrder, originalTutorSubjectData);
                });
                
                // Hàm sắp xếp bảng
                function sortTable(tbodySelector, sortField, sortOrder, originalData) {
                    const tbody = $(tbodySelector);
                    const rows = tbody.find('tr').toArray();
                    
                    // Xác định index cột để sắp xếp
                    let columnIndex = 0;
                    switch(sortField) {
                        case 'subjectID':
                        case 'tutorID':
                            columnIndex = 0;
                            break;
                        case 'subjectName':
                        case 'userName':
                            columnIndex = 1;
                            break;
                        case 'status':
                            columnIndex = 3;
                            break;
                        case 'subjectID_tutor':
                            columnIndex = 2;
                            break;
                        default:
                            columnIndex = 0;
                    }
                    
                    // Sắp xếp rows
                    rows.sort(function(a, b) {
                        const aValue = $(a).find('td').eq(columnIndex).text().trim();
                        const bValue = $(b).find('td').eq(columnIndex).text().trim();
                        
                        // Xử lý số
                        if (!isNaN(aValue) && !isNaN(bValue)) {
                            return sortOrder === 'asc' ? 
                                parseInt(aValue) - parseInt(bValue) : 
                                parseInt(bValue) - parseInt(aValue);
                        }
                        
                        // Xử lý text
                        if (sortOrder === 'asc') {
                            return aValue.localeCompare(bValue);
                        } else {
                            return bValue.localeCompare(aValue);
                        }
                    });
                    
                    // Cập nhật bảng
                    tbody.empty();
                    rows.forEach(function(row) {
                        tbody.append(row);
                    });
                }
                
                // Thêm thông báo khi không có kết quả tìm kiếm
                function showNoResultsMessage(tableId, message) {
                    const tbody = $(tableId + ' tbody');
                    const noResultsRow = tbody.find('.no-results-message');
                    
                    if (tbody.find('tr:visible').length === 0) {
                        if (noResultsRow.length === 0) {
                            tbody.append('<tr class="no-results-message"><td colspan="5" style="text-align: center; padding: 20px; color: #666;">' + message + '</td></tr>');
                        }
                    } else {
                        noResultsRow.remove();
                    }
                }
                
                // Cập nhật hàm filterTable để hiển thị thông báo
                const originalFilterTable = filterTable;
                filterTable = function(selector, searchTerm, columns) {
                    originalFilterTable(selector, searchTerm, columns);
                    
                    if (selector.includes('subjectTable')) {
                        showNoResultsMessage('#subjectTable', 'Không tìm thấy môn học nào phù hợp');
                    } else if (selector.includes('tutorSubjectTable')) {
                        showNoResultsMessage('#tutorSubjectTable', 'Không tìm thấy tutor-subject nào phù hợp');
                    }
                };
                
                // Xử lý nút Reset
                $('#resetBtn').on('click', function() {
                    // Reset form và submit
                    $('#subjectSearch').val('');
                    $('#sortField').val('subjectID');
                    $('#sortOrder').val('asc');
                    
                    // Submit form để reset về trang 1
                    $(this).closest('form').submit();
                });
                
                // Thêm chức năng reset cho tutor-subject
                function addResetButtons() {
                    $('.search-sort-container').each(function() {
                        const container = $(this);
                        if (container.find('.reset-btn').length === 0) {
                            const resetBtn = $('<button class="btn reset-btn" style="margin-left: 10px;">Reset</button>');
                            container.find('.sort-controls').append(resetBtn);
                            
                            resetBtn.on('click', function() {
                                const searchInput = container.find('input[type="text"]');
                                const sortField = container.find('select:first');
                                const sortOrder = container.find('select:last');
                                
                                searchInput.val('');
                                sortField.val(sortField.find('option:first').val());
                                sortOrder.val('asc');
                                
                                // Reset bảng
                                if (container.closest('.widget-box').find('#subjectTable').length > 0) {
                                    filterTable('#subjectTable tbody tr', '', [1, 2]);
                                } else {
                                    filterTable('#tutorSubjectTable tbody tr', '', [0, 1, 2, 3]);
                                }
                            });
                        }
                    });
                }
                
                // Thêm nút reset sau khi trang load
                setTimeout(addResetButtons, 100);
            });
        </script>
    </body>
</html>
