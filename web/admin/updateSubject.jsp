<%@page import="entity.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />
        <title>G5 SmartTutor - Update Subject</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
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
            .form-group input:focus, .form-group textarea:focus, .form-group select:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 0 2px rgba(0,123,255,.25);
            }
            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
                padding: 10px 20px;
                font-size: 16px;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .btn-primary:hover {
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
                margin-right: 10px;
                text-decoration: none;
                display: inline-block;
                transition: all 0.3s ease;
            }
            .btn-secondary:hover {
                background-color: #545b62;
                border-color: #545b62;
                color: white;
                text-decoration: none;
            }
            .widget-box {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 20px;
            }
            .wc-title h4 {
                color: #333;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #007bff;
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
            // Kiểm tra quyền admin
            if (user.getRoleID() != 1) {
                response.sendRedirect(request.getContextPath() + "/home");
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
                                <li><a href="${pageContext.request.contextPath}/admin/AdminListRated" class="ttr-material-button"><span class="ttr-label"><fmt:message key="tutor_reviews"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/RequestCV" class="ttr-material-button"><span class="ttr-label"><fmt:message key="status_cv"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/ViewBooking" class="ttr-material-button"><span class="ttr-label"><fmt:message key="booking_manage"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/AdminViewSchedule" class="ttr-material-button"><span class="ttr-label"><fmt:message key="view_schedule"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/AdminSubjectController" class="ttr-material-button"><span class="ttr-label"><fmt:message key="subject_management"/></span></a></li>
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
                                <li><a href="${pageContext.request.contextPath}/admin/ReportManager" class="ttr-material-button"><span class="ttr-label"><fmt:message key="report"/></span></a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="ttr-material-button">
                                <span class="ttr-icon"><i class="ti-credit-card"></i></span>
                                <span class="ttr-label"><fmt:message key="payment"/></span>
                                <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                            </a>
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/admin/approveWithdrawal" class="ttr-material-button"><span class="ttr-label"><fmt:message key="request_withdrawal"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/PaymentHistory" class="ttr-material-button"><span class="ttr-label"><fmt:message key="view_history_payment"/></span></a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/systemRevenue" class="ttr-material-button"><span class="ttr-label"><fmt:message key="system_revenue"/></span></a></li>
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
                    <h4 class="breadcrumb-title"><fmt:message key="update_subject"/></h4>
                    <ul class="db-breadcrumb-list">
                        <li><a href="${pageContext.request.contextPath}/admin/index"><i class="fa fa-home"></i><fmt:message key="home"/></a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject"><fmt:message key="subject_management"/></a></li>
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
                                <form action="${pageContext.request.contextPath}/admin/AdminSubjectController" method="post">
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
                                        <a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject" 
                                           class="btn btn-secondary">
                                            <i class="fa fa-arrow-left"></i> <fmt:message key="back"/>
                                        </a>
                                        <button type="submit" name="submit" class="btn btn-primary">
                                            <i class="fa fa-save"></i> <fmt:message key="update_subject"/>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Thông tin môn học hiện tại -->
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
        
        <script>
            // Xác nhận trước khi cập nhật
            document.querySelector('form').addEventListener('submit', function(e) {
                if (!confirm('Bạn có chắc chắn muốn cập nhật môn học này?')) {
                    e.preventDefault();
                }
            });
            
            // Kiểm tra form validation
            document.getElementById('subjectName').addEventListener('blur', function() {
                if (this.value.trim() === '') {
                    this.style.borderColor = '#dc3545';
                } else {
                    this.style.borderColor = '#28a745';
                }
            });
        </script>
    </body>
</html>
