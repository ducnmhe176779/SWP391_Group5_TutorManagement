<%@page import="entity.User"%>
<%@page import="entity.Subject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="${not empty sessionScope.locale ? sessionScope.locale : 'en'}">
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
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- PAGE TITLE -->
        <title>G5 SmartTutor - Update Subject</title>

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
        
        <style>
            .error { color: red; margin-bottom: 10px; font-weight: bold; padding: 10px; background-color: #f8d7da; border-radius: 4px; }
            .success { color: green; margin-bottom: 10px; font-weight: bold; padding: 10px; background-color: #d4edda; border-radius: 4px; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 5px; font-weight: 600; }
            .form-group input, .form-group textarea, .form-group select { 
                width: 100%; 
                padding: 10px; 
                box-sizing: border-box; 
                border: 1px solid #ddd; 
                border-radius: 4px;
                font-size: 14px;
            }
            .submit-btn {
                background-color: #007bff;
                border-color: #007bff;
                padding: 10px 20px;
                font-size: 16px;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s ease;
                color: white;
                border: none;
                margin-right: 10px;
            }
            .submit-btn:hover {
                background-color: #0056b3;
                border-color: #0056b3;
            }
            .btn-secondary {
                background-color: #6c757d;
                border-color: #6c757d;
                padding: 10px 20px;
                font-size: 16px;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                transition: all 0.3s ease;
                color: white;
            }
            .btn-secondary:hover {
                background-color: #545b62;
                border-color: #545b62;
                color: white;
                text-decoration: none;
            }
        </style>
    </head>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        // Kiểm tra quyền staff
        if (user.getRoleID() != 4) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        // Lấy subject từ request attribute
        Subject subject = (Subject) request.getAttribute("subject");
        
        // Debug: In ra console để kiểm tra
        System.out.println("=== DEBUG UPDATE SUBJECT JSP ===");
        System.out.println("User: " + (user != null ? user.getFullName() : "NULL"));
        System.out.println("Subject: " + (subject != null ? "EXISTS" : "NULL"));
        if (subject != null) {
            System.out.println("Subject ID: " + subject.getSubjectID());
            System.out.println("Subject Name: " + subject.getSubjectName());
        }
    %>
    <fmt:setLocale value="${not empty sessionScope.locale ? sessionScope.locale : 'en'}"/>
    <fmt:setBundle basename="messages"/>
    
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <!-- Header -->
        <header class="ttr-header">
            <div class="ttr-header-wrapper">
                <div class="ttr-toggle-sidebar ttr-material-button">
                    <i class="ti-close ttr-open-icon"></i>
                    <i class="ti-menu ttr-close-icon"></i>
                </div>
                <div class="ttr-logo-box">
                    <div>
                        <a href="${pageContext.request.contextPath}/staff/index_staff" class="ttr-logo">
                            <img class="ttr-logo-mobile" alt="" src="${pageContext.request.contextPath}/assets/images/logo-mobile.png" width="30" height="30">
                            <img class="ttr-logo-desktop" alt="" src="${pageContext.request.contextPath}/assets/images/logo-white.png" width="160" height="27">
                        </a>
                    </div>
                </div>
                <div class="ttr-header-menu">
                    <ul class="ttr-header-navigation">
                        <li><a href="${pageContext.request.contextPath}/staff/index_staff" class="ttr-material-button ttr-submenu-toggle"><fmt:message key="home"/></a></li>
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
                            <a href="${pageContext.request.contextPath}/staff/staffprofile" class="ttr-material-button ttr-submenu-toggle">
                                <span class="ttr-user-avatar">
                                    <img alt="" 
                                         src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                         width="32" height="32"
                                         onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                </span>
                            </a>
                            <div class="ttr-header-submenu">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/staff/staffprofile"><fmt:message key="my_profile"/></a></li>
                                    <li><a href="${pageContext.request.contextPath}/logout"><fmt:message key="logout"/></a></li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Left sidebar menu start -->
        <div class="ttr-sidebar">
            <div class="ttr-sidebar-wrapper content-scroll">
                <!-- Side menu logo start -->
                <div class="ttr-sidebar-logo">
                    <a href="${pageContext.request.contextPath}/staff/index_staff"><img alt="" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27"></a>
                    <div class="ttr-sidebar-toggle-button">
                        <i class="ti-arrow-left"></i>
                    </div>
                </div>
                <!-- Side menu logo end -->
                <!-- Sidebar menu start -->
                <nav class="ttr-sidebar-navi">
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/staff/index_staff" class="ttr-material-button">
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
                <!-- Sidebar menu end -->
            </div>
        </div>

        <!-- Main content -->
        <main class="ttr-wrapper">
            <div class="container-fluid">
                <div class="db-breadcrumb">
                    <h4 class="breadcrumb-title"><fmt:message key="update_subject"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/staff/index_staff"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                        <li><a href="SubjectController?service=listSubject"><fmt:message key="subject_management"/></a></li>
                        <li><fmt:message key="update_subject"/></li>
                    </ul>
                </div>
                
                <div class="row">
                    <div class="col-lg-8 m-b30">
                        <div class="widget-box">
                            <div class="wc-title">
                                <h4><fmt:message key="update_subject"/></h4>
                            </div>
                            
                            <!-- Hiển thị thông báo lỗi -->
                            <c:if test="${not empty sessionScope.error}">
                                <div class="error">${sessionScope.error}</div>
                                <c:remove var="error" scope="session" />
                            </c:if>
                            
                            <!-- Hiển thị thông báo thành công -->
                            <c:if test="${not empty sessionScope.success}">
                                <div class="success">${sessionScope.success}</div>
                                <c:remove var="success" scope="session" />
                            </c:if>
                            
                            <div class="widget-inner">
                                <!-- Kiểm tra xem có subject không -->
                                <c:choose>
                                    <c:when test="${not empty subject}">
                                        <!-- Form cập nhật subject -->
                                        <form action="SubjectController" method="post">
                                            <input type="hidden" name="service" value="updateSubject">
                                            <input type="hidden" name="subjectID" value="${subject.subjectID}">
                                            
                                            <div class="form-group">
                                                <label for="subjectName"><fmt:message key="subject_name"/>:</label>
                                                <input type="text" class="form-control" id="subjectName" name="subjectName" 
                                                       value="${subject.subjectName}" required>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="description"><fmt:message key="description"/>:</label>
                                                <textarea class="form-control" id="description" name="description" 
                                                          rows="4" placeholder="Nhập mô tả môn học...">${subject.description}</textarea>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="status"><fmt:message key="status"/>:</label>
                                                <select class="form-control" id="status" name="status" required>
                                                    <option value="Active" ${subject.status == 'Active' ? 'selected' : ''}>
                                                        <fmt:message key="active"/>
                                                    </option>
                                                    <option value="Inactive" ${subject.status == 'Inactive' ? 'selected' : ''}>
                                                        <fmt:message key="inactive"/>
                                                    </option>
                                                </select>
                                            </div>
                                            
                                            <div class="form-group">
                                                <a href="SubjectController?service=listSubject" class="btn-secondary">
                                                    <i class="fa fa-arrow-left"></i> <fmt:message key="back"/>
                                                </a>
                                                <button type="submit" name="submit" class="submit-btn">
                                                    <i class="fa fa-save"></i> <fmt:message key="update_subject"/>
                                                </button>
                                            </div>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Không có subject -->
                                        <div class="error">
                                            <h4><fmt:message key="subject_not_found"/></h4>
                                            <p>Không thể tìm thấy thông tin môn học. Vui lòng kiểm tra lại hoặc quay về danh sách môn học.</p>
                                            <a href="SubjectController?service=listSubject" class="btn-secondary">
                                                <i class="fa fa-arrow-left"></i> <fmt:message key="back_to_list"/>
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Thông tin môn học hiện tại -->
                    <c:if test="${not empty subject}">
                        <div class="col-lg-4 m-b30">
                            <div class="widget-box">
                                <div class="wc-title">
                                    <h4><fmt:message key="subject_info"/></h4>
                                </div>
                                <div class="widget-inner">
                                    <div class="form-group">
                                        <label><strong><fmt:message key="subject_id"/>:</strong></label>
                                        <p>${subject.subjectID}</p>
                                    </div>
                                    <div class="form-group">
                                        <label><strong><fmt:message key="subject_name"/>:</strong></label>
                                        <p>${subject.subjectName}</p>
                                    </div>
                                    <div class="form-group">
                                        <label><strong><fmt:message key="current_status"/>:</strong></label>
                                        <span class="badge ${subject.status == 'Active' ? 'badge-success' : 'badge-danger'}">
                                            ${subject.status}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
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
        <script src='${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js'></script>
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/chart/chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
        <script src='${pageContext.request.contextPath}/assets/vendors/calendar/moment.min.js'></script>
        <script src='${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.js'></script>
        <script src='${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js'></script>
        
        <script>
            // Xác nhận trước khi cập nhật
            document.querySelector('form')?.addEventListener('submit', function(e) {
                if (!confirm('Bạn có chắc chắn muốn cập nhật môn học này?')) {
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html>
