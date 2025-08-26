<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý lịch dạy - SmartTutor</title>
    
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendors/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="${pageContext.request.contextPath}/assets/vendors/fontawesome/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    
    <style>
        .calendar-container {
            margin: 20px 0;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .calendar-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .calendar-grid {
            display: grid;
            grid-template-columns: 80px repeat(7, 1fr);
            gap: 1px;
            background-color: #e0e0e0;
        }
        
        .time-header, .day-header {
            background: #f8f9fa;
            padding: 15px 10px;
            text-align: center;
            font-weight: bold;
            border-bottom: 2px solid #dee2e6;
        }
        
        .time-slot {
            background: #f8f9fa;
            padding: 15px 5px;
            text-align: center;
            font-size: 12px;
            font-weight: 500;
            color: #666;
        }
        
        .schedule-cell {
            background: white;
            padding: 10px 5px;
            min-height: 60px;
            position: relative;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .schedule-cell:hover {
            background-color: #f0f8ff;
        }
        
        .schedule-available {
            background: #e8f5e8;
            border-left: 4px solid #28a745;
        }
        
        .schedule-booked {
            background: #ffe6e6;
            border-left: 4px solid #dc3545;
        }
        
        .schedule-content {
            font-size: 11px;
            line-height: 1.2;
        }
        
        .subject-name {
            font-weight: bold;
            color: #333;
            margin-bottom: 2px;
        }
        
        .schedule-time {
            color: #666;
            font-size: 10px;
        }
        
        .create-btn {
            background: #007bff;
            color: white;
            border: none;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 9px;
            margin-top: 2px;
            cursor: pointer;
        }
        
        .create-btn:hover {
            background: #0056b3;
        }
        
        .occupied-label {
            background: #dc3545;
            color: white;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 9px;
            margin-top: 2px;
        }
        
        .legend {
            display: flex;
            justify-content: center;
            gap: 30px;
            padding: 15px;
            background: #f8f9fa;
            border-top: 1px solid #dee2e6;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        
        .legend-color {
            width: 20px;
            height: 15px;
            border-radius: 3px;
        }
        
        .available-color {
            background: white;
            border: 2px solid #ccc;
        }
        
        .created-color {
            background: #e8f5e8;
            border-left: 4px solid #28a745;
        }
        
        .booked-color {
            background: #ffe6e6;
            border-left: 4px solid #dc3545;
        }
        
        .quick-create {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .calendar-grid {
                font-size: 10px;
            }
            
            .schedule-cell {
                min-height: 40px;
                padding: 5px 2px;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Header Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/tutor/indextutor.jsp">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="SmartTutor" height="40">
            </a>
            <div class="navbar-nav ml-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/tutor/indextutor.jsp">
                    <i class="fas fa-home"></i> Trang chủ
                </a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/tutor/schedule-management">
                    <i class="fas fa-calendar"></i> Quản lý lịch
                </a>
            </div>
        </nav>

        <!-- Quick Create Form -->
        <div class="quick-create">
            <h4><i class="fas fa-plus-circle text-success"></i> Tạo lịch dạy nhanh</h4>
            <form method="POST" action="${pageContext.request.contextPath}/tutor/schedule-management">
                <div class="row">
                    <div class="col-md-3">
                        <label>Môn học:</label>
                        <select name="subject" class="form-control" required>
                            <option value="">Chọn môn học</option>
                            <c:forEach var="subject" items="${subjectList}">
                                <option value="${subject.subjectID}">${subject.subjectName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label>Thời gian bắt đầu:</label>
                        <input type="datetime-local" name="startTime" class="form-control" required>
                    </div>
                    <div class="col-md-2">
                        <label>Số slot:</label>
                        <input type="number" name="slotCount" class="form-control" min="1" max="10" value="1" required>
                    </div>
                    <div class="col-md-2">
                        <label>&nbsp;</label>
                        <button type="submit" class="btn btn-success form-control">
                            <i class="fas fa-plus"></i> Tạo lịch
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle"></i> ${message}
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-triangle"></i> ${error}
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div>
        </c:if>

        <!-- Calendar -->
        <div class="calendar-container">
            <div class="calendar-header">
                <h4><i class="fas fa-calendar-week"></i> Thời khóa biểu tuần</h4>
                <p class="mb-0">Quản lý lịch dạy của bạn (7h sáng - 22h tối)</p>
            </div>
            
            <div class="calendar-grid">
                <!-- Header row -->
                <div class="time-header">Giờ</div>
                <div class="day-header">Thứ 2</div>
                <div class="day-header">Thứ 3</div>
                <div class="day-header">Thứ 4</div>
                <div class="day-header">Thứ 5</div>
                <div class="day-header">Thứ 6</div>
                <div class="day-header">Thứ 7</div>
                <div class="day-header">Chủ nhật</div>
                
                <!-- Time slots from 7AM to 10PM -->
                <c:forEach var="hour" begin="7" end="22">
                    <div class="time-slot">
                        <fmt:formatNumber value="${hour}" pattern="00"/>:00<br>
                        <small><fmt:formatNumber value="${hour}" pattern="00"/>:59</small>
                    </div>
                    
                    <!-- Days for this hour (ISO Monday=1..Sunday=7) -->
                    <c:forEach var="dayIndex" begin="1" end="7">
                        <c:set var="cellKey" value="${dayIndex}-${hour}"/>
                        <c:set var="hasSchedule" value="false"/>
                        
                        <!-- Check if there's a schedule for this time slot -->
                        <c:forEach var="schedule" items="${scheduleList}">
                            <c:set var="scheduleHour"><fmt:formatDate value="${schedule.startTime}" pattern="H"/></c:set>
                            <c:set var="scheduleDay"><fmt:formatDate value="${schedule.startTime}" pattern="u"/></c:set>
                            
                            <c:if test="${scheduleHour == hour && scheduleDay == dayIndex}">
                                <c:set var="hasSchedule" value="true"/>
                                <c:set var="currentSchedule" value="${schedule}"/>
                            </c:if>
                        </c:forEach>
                        
                        <div class="schedule-cell ${hasSchedule ? (currentSchedule.isBooked ? 'schedule-booked' : 'schedule-available') : ''}" 
                             onclick="createSchedule(${dayIndex}, ${hour})">
                            <c:if test="${hasSchedule}">
                                <div class="schedule-content">
                                    <div class="subject-name">${currentSchedule.subject.subjectName}</div>
                                    <div class="schedule-time">
                                        <fmt:formatDate value="${currentSchedule.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${currentSchedule.endTime}" pattern="HH:mm"/>
                                    </div>
                                    
                                    <c:choose>
                                        <c:when test="${currentSchedule.isBooked}">
                                            <div class="occupied-label">Đã có học sinh</div>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="create-btn" onclick="event.stopPropagation(); deleteSchedule(${currentSchedule.scheduleID})">
                                                <i class="fas fa-trash"></i> Xóa
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>
                            
                            <c:if test="${!hasSchedule}">
                                <div class="text-center text-muted" style="padding: 10px;">
                                    <i class="fas fa-plus-circle"></i><br>
                                    <small>Tạo lịch</small>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                    
                </c:forEach>
            </div>
            
            <!-- Legend -->
            <div class="legend">
                <div class="legend-item">
                    <div class="legend-color available-color"></div>
                    <span>Trống - Click để tạo lịch</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color created-color"></div>
                    <span>Đã tạo lịch - Chờ học sinh đặt</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color booked-color"></div>
                    <span>Đã có học sinh đặt</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function createSchedule(dayIndex, hour) {
            // Set default values for quick create form (tuần hiện tại, không nhảy sang tuần sau)
            const today = new Date();
            const mondayOffset = ((today.getDay() + 6) % 7); // Monday=0, Sunday=6
            const monday = new Date(today);
            monday.setDate(today.getDate() - mondayOffset);

            // dayIndex: ISO 1..7 (Sun..Sat). Convert to 0..6 with Mon=0
            const isoDay = dayIndex === 1 ? 7 : dayIndex; // Sun=1 -> 7
            const dayOffset = isoDay - 1; // Mon=1 -> 0
            const targetDate = new Date(monday);
            targetDate.setDate(monday.getDate() + dayOffset);
            targetDate.setHours(hour, 0, 0, 0);

            const dateStr = targetDate.getFullYear() + '-' + 
                           String(targetDate.getMonth() + 1).padStart(2, '0') + '-' + 
                           String(targetDate.getDate()).padStart(2, '0') + 'T' + 
                           String(hour).padStart(2, '0') + ':00';

            document.querySelector('input[name="startTime"]').value = dateStr;
            document.querySelector('.quick-create').scrollIntoView({ behavior: 'smooth' });
        }
        
        function deleteSchedule(scheduleId) {
            if (confirm('Bạn có chắc chắn muốn xóa lịch này?')) {
                window.location.href = '${pageContext.request.contextPath}/tutor/schedule-management?action=delete&scheduleId=' + scheduleId;
            }
        }
        
        // Không giới hạn min-date theo yêu cầu
    </script>
</body>
</html>
