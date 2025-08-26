<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch dạy - ${tutorInfo.fullName}</title>
    
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
        
        .schedule-available:hover {
            background: #d4edda;
        }
        
        .schedule-booked {
            background: #ffe6e6;
            border-left: 4px solid #dc3545;
            cursor: not-allowed;
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
        
        .book-btn {
            background: #007bff;
            color: white;
            border: none;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 9px;
            margin-top: 2px;
            cursor: pointer;
        }
        
        .book-btn:hover {
            background: #0056b3;
        }
        
        .booked-label {
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
            background: #e8f5e8;
            border-left: 4px solid #28a745;
        }
        
        .booked-color {
            background: #ffe6e6;
            border-left: 4px solid #dc3545;
        }
        
        /* Modal fallback styles */
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1050;
        }
        
        .modal.show {
            display: block !important;
        }
        
        .modal-dialog {
            position: relative;
            margin: 50px auto;
            max-width: 500px;
        }
        
        .modal-content {
            background: white;
            border-radius: 5px;
            padding: 20px;
        }
        
        .tutor-info {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .back-btn {
            margin-bottom: 20px;
            padding: 10px 0;
            z-index: 1000;
            position: relative;
        }
        
        .back-btn .btn {
            background: #6c757d;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            color: white;
            text-decoration: none;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        
        .back-btn .btn:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
        }
        
        @media (max-width: 768px) {
            .calendar-grid {
                font-size: 10px;
            }
            
            .schedule-cell {
                min-height: 40px;
                padding: 5px 2px;
            }
            
            .time-header, .day-header {
                padding: 10px 5px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Back Button -->
        <div class="back-btn">
            <a href="${pageContext.request.contextPath}/Tutor" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách gia sư
            </a>
        </div>
        
        <!-- Tutor Info -->
        <div class="tutor-info">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h3><i class="fas fa-user-graduate"></i> ${tutorInfo.fullName}</h3>
                    <p class="text-muted mb-1"><i class="fas fa-envelope"></i> ${tutorInfo.email}</p>
                    <c:if test="${not empty tutorInfo.phone}">
                        <p class="text-muted mb-0"><i class="fas fa-phone"></i> ${tutorInfo.phone}</p>
                    </c:if>
                </div>
                <div class="col-md-4 text-md-right">
                    <span class="badge badge-primary badge-lg">
                        <i class="fas fa-calendar-check"></i> 
                        ${calendarData.schedules.size()} lịch khả dụng
                    </span>
                </div>
            </div>
        </div>
        
        <!-- Calendar -->
        <div class="calendar-container">
            <div class="calendar-header">
                <h4><i class="fas fa-calendar-alt"></i> Thời khóa biểu tuần</h4>
                <p class="mb-0">Chọn khung giờ để đặt lịch học</p>
            </div>
            
            <div class="calendar-grid">
                <!-- Header row -->
                <div class="time-header">Giờ</div>
                <c:forEach var="dayName" items="${calendarData.dayNames}" varStatus="status">
                    <div class="day-header">
                        ${dayName}<br>
                        <small><fmt:formatDate value="${calendarData.dayDates[status.index]}" pattern="dd/MM"/></small>
                    </div>
                </c:forEach>
                
                <!-- Time slots -->
                <c:forEach var="hour" items="${calendarData.timeSlots}">
                    <div class="time-slot">
                        <fmt:formatNumber value="${hour}" pattern="00"/>:00<br>
                        <small><fmt:formatNumber value="${hour}" pattern="00"/>:59</small>
                    </div>
                    
                    <!-- Days for this hour -->
                    <c:forEach var="dayIndex" begin="1" end="7">
                        <c:set var="cellKey" value="${dayIndex}-${hour}"/>
                        <c:set var="schedule" value="${calendarData.gridData[cellKey]}"/>
                        
                        <div class="schedule-cell ${schedule != null ? (schedule.isBooked ? 'schedule-booked' : 'schedule-available') : ''}">
                            <c:if test="${schedule != null}">
                                <div class="schedule-content">
                                    <div class="subject-name">${schedule.subject.subjectName}</div>
                                    <div class="schedule-time">
                                        <fmt:formatDate value="${schedule.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${schedule.endTime}" pattern="HH:mm"/>
                                    </div>
                                    
                                    <c:choose>
                                        <c:when test="${schedule.isBooked}">
                                            <div class="booked-label">Đã đặt</div>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="book-btn" onclick="bookSchedule(${schedule.scheduleID}, '${schedule.subject.subjectName}', '<fmt:formatDate value="${schedule.startTime}" pattern="dd/MM/yyyy HH:mm"/>', ${schedule.subject.subjectID})">
                                                Đặt lịch
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
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
                    <span>Có thể đặt</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color booked-color"></div>
                    <span>Đã có người đặt</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Booking Modal -->
    <div class="modal fade" id="bookingModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận đặt lịch</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p><strong>Gia sư:</strong> ${tutorInfo.fullName}</p>
                    <p><strong>Môn học:</strong> <span id="modalSubject"></span></p>
                    <p><strong>Thời gian:</strong> <span id="modalTime"></span></p>
                    <p class="text-warning">
                        <i class="fas fa-exclamation-triangle"></i> 
                        Bạn có chắc chắn muốn đặt lịch học này?
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" id="confirmBooking">Xác nhận đặt lịch</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    
    <script>
        let selectedScheduleId = null;
        let selectedSubjectId = null;
        
        function bookSchedule(scheduleId, subjectName, time, subjectId) {
            console.log('bookSchedule called with:', scheduleId, subjectName, time, subjectId);
            selectedScheduleId = scheduleId;
            selectedSubjectId = subjectId;
            document.getElementById('modalSubject').textContent = subjectName;
            document.getElementById('modalTime').textContent = time;
            
            // Check if jQuery is loaded
            if (typeof $ === 'undefined') {
                console.error('jQuery is not loaded!');
                // Fallback: show modal manually
                const modal = document.getElementById('bookingModal');
                if (modal) {
                    modal.style.display = 'block';
                    modal.classList.add('show');
                }
            } else {
                $('#bookingModal').modal('show');
            }
        }
        
        document.getElementById('confirmBooking').addEventListener('click', function() {
            console.log('confirmBooking clicked, selectedScheduleId:', selectedScheduleId);
            if (selectedScheduleId) {
                console.log('Creating form for booking...');
                // Create form and submit to BookSchedule servlet
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/BookSchedule';
                console.log('Form action:', form.action);
                
                // Add hidden fields
                const scheduleInput = document.createElement('input');
                scheduleInput.type = 'hidden';
                scheduleInput.name = 'selectedSchedule';
                scheduleInput.value = selectedScheduleId;
                form.appendChild(scheduleInput);
                
                const tutorInput = document.createElement('input');
                tutorInput.type = 'hidden';
                tutorInput.name = 'tutorId';
                tutorInput.value = '${tutorId}';
                form.appendChild(tutorInput);
                
                const subjectInput = document.createElement('input');
                subjectInput.type = 'hidden';
                subjectInput.name = 'subjectId';
                subjectInput.value = selectedSubjectId || '1'; // Use selected subject or default to English
                form.appendChild(subjectInput);
                
                // Submit form
                document.body.appendChild(form);
                console.log('Submitting form...', form);
                form.submit();
            } else {
                console.log('No selectedScheduleId, cannot submit');
            }
        });
        
        // Close modal when clicking outside
        window.addEventListener('click', function(e) {
            const modal = document.getElementById('bookingModal');
            if (e.target === modal) {
                modal.style.display = 'none';
                modal.classList.remove('show');
            }
        });
        
        // Close modal when clicking close button
        document.addEventListener('DOMContentLoaded', function() {
            const closeButtons = document.querySelectorAll('[data-dismiss="modal"]');
            closeButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const modal = document.getElementById('bookingModal');
                    modal.style.display = 'none';
                    modal.classList.remove('show');
                });
            });
        });
        
        // Auto refresh every 30 seconds to update booking status
        setTimeout(function() {
            location.reload();
        }, 30000);
    </script>
</body>
</html>
