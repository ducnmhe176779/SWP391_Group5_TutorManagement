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

        <title>G5 SmartTutor</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
        
        <!-- Custom CSS for Create Schedule -->
        <style>
            .schedule-form {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
                padding: 30px;
                margin: 20px 0;
                border: 1px solid #e9ecef;
            }
            
            .schedule-table {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
                padding: 20px;
                margin: 20px 0;
                border: 1px solid #e9ecef;
            }
            
            .form-control, .form-select {
                border: 1px solid #ced4da;
                border-radius: 5px;
                padding: 10px 15px;
                font-size: 14px;
                transition: all 0.3s ease;
            }
            
            .form-control:focus, .form-select:focus {
                border-color: #007bff;
                box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
                outline: none;
            }
            
            .form-label {
                font-weight: 600;
                color: #495057;
                margin-bottom: 8px;
            }
            
            .btn-primary {
                background: linear-gradient(45deg, #007bff, #0056b3);
                border: none;
                padding: 12px 30px;
                font-weight: 600;
                transition: all 0.3s ease;
                border-radius: 25px;
            }
            
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,123,255,0.4);
                background: linear-gradient(45deg, #0056b3, #004085);
            }
            
            .table th {
                background: linear-gradient(45deg, #007bff, #0056b3);
                color: white;
                border: none;
                padding: 15px;
            }
            
            .status-badge {
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }
            
            .status-available { background: #28a745; color: white; }
            .status-booked { background: #ffc107; color: #212529; }
            .status-completed { background: #17a2b8; color: white; }
            
            /* Bootstrap validation styling - only show when was-validated class is present */
            .needs-validation .invalid-feedback {
                display: none;
            }
            
            .needs-validation.was-validated .invalid-feedback {
                display: block;
            }
            
            .needs-validation.was-validated .form-control:invalid,
            .needs-validation.was-validated .form-select:invalid {
                border-color: #dc3545;
            }
            
            .needs-validation.was-validated .form-control:valid,
            .needs-validation.was-validated .form-select:valid {
                border-color: #28a745;
            }
            
            /* Validation state styling - only show after interaction */
            .form-control.is-valid,
            .form-select.is-valid {
                border-color: #28a745;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%2328a745' d='m2.3 6.73.94-.94 3.47-3.47L7.1 1.86 6.13.9 2.3 4.73l-.94-.94L.9 4.73z'/%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right calc(0.375em + 0.1875rem) center;
                background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
            }
            
            .form-control.is-invalid,
            .form-select.is-invalid {
                border-color: #dc3545;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath d='m5.8 4.6 1.4 1.4m0-1.4-1.4 1.4'/%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right calc(0.375em + 0.1875rem) center;
                background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
            }
            
            /* Hide validation icons initially */
            .form-control:not(.is-valid):not(.is-invalid),
            .form-select:not(.is-valid):not(.is-invalid) {
                background-image: none;
            }
            
            .form-text {
                color: #6c757d;
                font-size: 12px;
                margin-top: 5px;
            }
            
            .text-danger {
                color: #dc3545 !important;
            }
        </style>
    </head>
    <body id="bg">
        <%
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRoleID() != 3) { // RoleID 3 là tutor
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        %>
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper">
            <header class="header rs-nav">
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
                                                    <a href="${pageContext.request.contextPath}/tutor/tutorprofile" class="ttr-material-button ttr-submenu-toggle">
                                                        <span class="ttr-user-avatar">
                                                            <img alt="" 
                                                                 src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                                                 width="32" height="32"
                                                                 onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                                        </span>
                                                    </a>
                                                </li>
                                                <li><a href="${pageContext.request.contextPath}/tutor/tutorprofile"><fmt:message key="my_profile"/></a></li>
                                                <li><a href="${pageContext.request.contextPath}/tutor/ViewTutorSchedule"><fmt:message key="view_schedule"/></a></li>
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
                                <a href="${pageContext.request.contextPath}/tutor/indextutor.jsp"><img src="${pageContext.request.contextPath}/assets/images/logo.png" alt=""></a>
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
                                    <a href="${pageContext.request.contextPath}/tutor/indextutor.jsp"><img src="${pageContext.request.contextPath}/assets/images/logo.png" alt=""></a>
                                </div>
                                <ul class="nav navbar-nav">
                                    <li><a href="${pageContext.request.contextPath}/tutor/indextutor.jsp"><fmt:message key="home"/></a></li>
                                    <li class="active"><a href="${pageContext.request.contextPath}/tutor/CreateSchedule"><fmt:message key="my_schedule"/></a></li>
                                    <li><a href="${pageContext.request.contextPath}/tutor/ViewTutorSchedule"><fmt:message key="view_schedule"/></a></li>
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
                            <h1 class="text-white"><fmt:message key="create_teaching_schedule"/></h1>
                        </div>
                    </div>
                </div>
                
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="${pageContext.request.contextPath}/tutor/indextutor.jsp"><fmt:message key="home"/></a></li>
                            <li><fmt:message key="create_schedule"/></li>
                        </ul>
                    </div>
                </div>
                
                <div class="container mt-5">
                    <c:if test="${not empty message}">
                        <div class="alert ${message.contains('thành công') || message.contains('successfully') ? 'alert-success' : 'alert-danger'} alert-dismissible fade show">
                            ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <div class="schedule-form">
                        <h3 class="text-center mb-4"><fmt:message key="create_teaching_schedule"/></h3>
                        <form action="${pageContext.request.contextPath}/tutor/CreateSchedule" method="POST" class="needs-validation" novalidate onsubmit="return validateForm()">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="subject" class="form-label"><fmt:message key="subject"/>: <span class="text-danger">*</span></label>
                                        <select class="form-select" name="subject" id="subject" required>
                                            <option value=""><fmt:message key="select_subject"/></option>
                                            <c:choose>
                                                <c:when test="${not empty subjectList}">
                                                    <c:forEach var="subject" items="${subjectList}">
                                                        <option value="${subject.subjectID}">${subject.subjectName}</option>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="" disabled><fmt:message key="no_subjects_available"/></option>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                        <div class="invalid-feedback">
                                            <fmt:message key="please_select_subject"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="slotCount" class="form-label"><fmt:message key="slot_count"/>: <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="slotCount" id="slotCount" min="1" max="10" value="1" required>
                                        <small class="form-text text-muted">Tối đa 10 slot mỗi ngày</small>
                                        <div class="invalid-feedback">
                                            <fmt:message key="slot_count_range_error"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="startTime" class="form-label"><fmt:message key="start_time"/>: <span class="text-danger">*</span></label>
                                        <input type="datetime-local" class="form-control" name="startTime" id="startTime" required>
                                        <small class="form-text text-muted">Chọn ngày và giờ bắt đầu dạy học</small>
                                        <div class="invalid-feedback">
                                            <fmt:message key="please_select_start_time"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="duration" class="form-label"><fmt:message key="duration_per_slot"/>:</label>
                                        <div class="form-control-plaintext">
                                            <strong>60 phút</strong>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fa fa-calendar-plus"></i> <fmt:message key="create_schedule"/>
                                </button>
                            </div>
                        </form>
                    </div>
                    
                    <div class="schedule-table">
                        <h3 class="text-center mb-4"><fmt:message key="your_teaching_schedule"/></h3>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Môn học</th>
                                        <th>Thời gian bắt đầu</th>
                                        <th>Thời gian kết thúc</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty scheduleList}">
                                            <c:forEach var="schedule" items="${scheduleList}">
                                                <tr>
                                                    <td>
                                                        <strong>${schedule.subject.subjectName}</strong>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${schedule.startTime}" pattern="HH:mm 'ngày' dd/MM/yyyy" />
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${schedule.endTime}" pattern="HH:mm 'ngày' dd/MM/yyyy" />
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-${schedule.isBooked ? 'booked' : 'available'}">
                                                            ${schedule.isBooked ? 'Đã đặt' : 'Có sẵn'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:if test="${!schedule.isBooked}">
                                                            <button class="btn btn-sm btn-danger" onclick="deleteSchedule('${schedule.scheduleID}')">
                                                                <i class="fa fa-trash"></i> Xóa
                                                            </button>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center text-muted">
                                                    <i class="fa fa-calendar-times fa-3x mb-3"></i>
                                                    <br>Chưa có lịch dạy học nào
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
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
                                    <a href="${pageContext.request.contextPath}/tutor/indextutor.jsp"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt=""/></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
            
            <button class="back-to-top fa fa-chevron-up"></button>
        </div>
        
        <!-- JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        
        <script>
            // Set minimum date to today and reasonable default time
            document.addEventListener('DOMContentLoaded', function() {
                const today = new Date();
                const tomorrow = new Date(today);
                tomorrow.setDate(tomorrow.getDate() + 1);
                
                const startTimeInput = document.getElementById('startTime');
                if (startTimeInput) {
                    const tomorrowString = tomorrow.toISOString().slice(0, 16);
                    startTimeInput.min = tomorrowString;
                    
                    // Set default time to 9:00 AM tomorrow (more reasonable for teaching)
                    const defaultTime = new Date(tomorrow);
                    defaultTime.setHours(9, 0, 0, 0);
                    startTimeInput.value = defaultTime.toISOString().slice(0, 16);
                }
                
                // Bootstrap form validation - only show errors after first submit attempt
                const forms = document.querySelectorAll('.needs-validation');
                Array.from(forms).forEach(form => {
                    form.addEventListener('submit', event => {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
                
                // Real-time validation feedback - only after user interaction
                const formInputs = document.querySelectorAll('.needs-validation input, .needs-validation select');
                formInputs.forEach(input => {
                    let hasInteracted = false;
                    
                    input.addEventListener('blur', function() {
                        hasInteracted = true;
                        if (this.checkValidity()) {
                            this.classList.remove('is-invalid');
                            this.classList.add('is-valid');
                        } else {
                            this.classList.remove('is-valid');
                            this.classList.add('is-invalid');
                        }
                    });
                    
                    input.addEventListener('input', function() {
                        if (hasInteracted) {
                            if (this.checkValidity()) {
                                this.classList.remove('is-invalid');
                                this.classList.add('is-valid');
                            } else {
                                this.classList.remove('is-valid');
                                this.classList.add('is-invalid');
                            }
                        }
                    });
                });
                
                // Auto-select first subject if available
                const subjectSelect = document.getElementById('subject');
                if (subjectSelect && subjectSelect.options.length > 1) {
                    // Skip the first option (placeholder) and select the first real subject
                    if (subjectSelect.options[1]) {
                        subjectSelect.selectedIndex = 1;
                        subjectSelect.classList.add('is-valid');
                    }
                }
            });
            
            // Delete schedule function
            function deleteSchedule(scheduleId) {
                if (confirm('Bạn có chắc chắn muốn xóa lịch này?')) {
                    window.location.href = '${pageContext.request.contextPath}/tutor/CreateSchedule?action=delete&scheduleId=' + scheduleId;
                }
            }
            
            // Validate form before submission with better user feedback
            function validateForm() {
                const subject = document.getElementById('subject').value;
                const startTime = document.getElementById('startTime').value;
                const slotCount = document.getElementById('slotCount').value;
                
                let isValid = true;
                let errorMessage = '';
                
                if (!subject) {
                    errorMessage += '• Vui lòng chọn môn học\n';
                    isValid = false;
                }
                
                if (!startTime) {
                    errorMessage += '• Vui lòng chọn thời gian bắt đầu\n';
                    isValid = false;
                } else {
                    const selectedTime = new Date(startTime);
                    const now = new Date();
                    if (selectedTime <= now) {
                        errorMessage += '• Thời gian bắt đầu phải trong tương lai\n';
                        isValid = false;
                    }
                }
                
                if (!slotCount || slotCount < 1 || slotCount > 10) {
                    errorMessage += '• Số lượng slot phải từ 1 đến 10\n';
                    isValid = false;
                }
                
                if (!isValid) {
                    alert('Vui lòng kiểm tra lại thông tin:\n' + errorMessage);
                }
                
                return isValid;
            }
        </script>
    </body>
</html>
