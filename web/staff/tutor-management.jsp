<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.util.List"%>
<%@page import="model.DAOTutor"%>
<%@page import="entity.Tutor"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tutor Management - SmartTutor EDUCATION PROGRAMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .tutor-card {
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        .tutor-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        .tutor-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px 12px 0 0;
            position: relative;
        }
        .tutor-body {
            padding: 25px;
        }
        .status-badge {
            font-size: 12px;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-active { background-color: #28a745; color: #fff; }
        .status-inactive { background-color: #6c757d; color: #fff; }
        .status-suspended { background-color: #dc3545; color: #fff; }
        .performance-excellent { background-color: #28a745; color: #fff; }
        .performance-good { background-color: #17a2b8; color: #fff; }
        .performance-average { background-color: #ffc107; color: #000; }
        .performance-poor { background-color: #dc3545; color: #fff; }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .btn-activate { background-color: #28a745; border-color: #28a745; }
        .btn-deactivate { background-color: #6c757d; border-color: #6c757d; }
        .btn-suspend { background-color: #dc3545; border-color: #dc3545; }
        .btn-view-profile { background-color: #17a2b8; border-color: #17a2b8; }
        .btn-edit { background-color: #fd7e14; border-color: #fd7e14; }
        .stats-overview {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        .filter-section {
            background-color: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid #e9ecef;
        }
        .filter-section h5 {
            color: #495057;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .filter-row {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            align-items: end;
        }
        .filter-item {
            flex: 1;
            min-width: 200px;
        }
        .tutor-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .tutor-details {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
        }
        .tutor-details h6 {
            color: #495057;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .tutor-details p {
            color: #6c757d;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .no-tutor-message {
            text-align: center;
            padding: 80px 20px;
            color: #6c757d;
        }
        .no-tutor-message i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        .performance-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }
        .performance-excellent-indicator { background-color: #28a745; }
        .performance-good-indicator { background-color: #17a2b8; }
        .performance-average-indicator { background-color: #ffc107; }
        .performance-poor-indicator { background-color: #dc3545; }
        
        .tutor-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
        }
        .tutor-meta small {
            color: #6c757d;
        }
        .rating-stars {
            color: #ffc107;
            font-size: 14px;
        }
        .schedule-info {
            background-color: #e3f2fd;
            border-radius: 8px;
            padding: 10px;
            margin: 10px 0;
        }
        .schedule-info h6 {
            color: #1976d2;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <%
        // Load tất cả tutor từ database
        DAOTutor daoTutor = new DAOTutor();
        List<Tutor> allTutors = daoTutor.getAllTutors();
        request.setAttribute("allTutors", allTutors);
        
        // Debug: In ra số lượng tutor
        System.out.println("DEBUG: Số lượng tutor: " + allTutors.size());
        for (Tutor t : allTutors) {
            System.out.println("DEBUG: Tutor ID: " + t.getTutorID() + ", Name: " + t.getCv().getUser().getFullName());
        }
    %>
    <div class="container-fluid">
        <!-- Header -->
        <div class="row bg-primary text-white py-4">
            <div class="col">
                <h3><i class="fas fa-users me-3"></i>Tutor Management & Review</h3>
                <p class="mb-0">Manage and monitor approved tutors</p>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-outline-light me-2">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a>
            </div>
        </div>

        <!-- Stats Overview -->
        <div class="stats-overview">
            <div class="row">
                <div class="col-md-3">
                    <h5><i class="fas fa-users me-2"></i>Total Tutors</h5>
                    <h2>25</h2>
                    <small>All tutors</small>
                </div>
                <div class="col-md-3">
                    <h5><i class="fas fa-check-circle me-2"></i>Active Tutors</h5>
                    <h2>18</h2>
                    <small>Currently teaching</small>
                </div>
                <div class="col-md-3">
                    <h5><i class="fas fa-star me-2"></i>Average Rating</h5>
                    <h2>4.6</h2>
                    <small>Out of 5.0</small>
                </div>
                <div class="col-md-3">
                    <h5><i class="fas fa-clock me-2"></i>Total Hours</h5>
                    <h2>1,247</h2>
                    <small>This month</small>
                </div>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("success"); %>
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("error"); %>
        </c:if>

        <!-- Filters -->
        <div class="filter-section">
            <h5><i class="fas fa-filter me-2"></i>Filter & Search Tutors</h5>
            <div class="filter-row">
                <div class="filter-item">
                    <label class="form-label">Tutor Status</label>
                    <select class="form-select" id="statusFilter">
                        <option value="">All Statuses</option>
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                        <option value="Suspended">Suspended</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="form-label">Performance Level</label>
                    <select class="form-select" id="performanceFilter">
                        <option value="">All Performance</option>
                        <option value="Excellent">Excellent (4.5+)</option>
                        <option value="Good">Good (4.0-4.4)</option>
                        <option value="Average">Average (3.5-3.9)</option>
                        <option value="Poor">Poor (<3.5)</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="form-label">Search Tutor</label>
                    <input type="text" class="form-control" id="searchInput" placeholder="Search by name, subject...">
                </div>
                <div class="filter-item">
                    <button class="btn btn-primary" onclick="applyFilters()">
                        <i class="fas fa-search me-2"></i>Apply Filters
                    </button>
                    <button class="btn btn-secondary" onclick="clearFilters()">
                        <i class="fas fa-times me-2"></i>Clear
                    </button>
                </div>
            </div>
        </div>

        <!-- Tutor List -->
        <c:choose>
            <c:when test="${empty allTutors}">
                <div class="no-tutor-message">
                    <i class="fas fa-users"></i>
                    <h4>Không có tutor nào</h4>
                    <p>Hiện tại chưa có tutor nào trong hệ thống.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="tutor" items="${allTutors}">
                        <div class="col-lg-6">
                                                         <div class="tutor-card" 
                                  data-tutor-id="${tutor.tutorID}"
                                  data-user-id="${tutor.cv.user.userID}"
                                  data-status="${tutor.cv.user.isActive == 1 ? 'Active' : 'Inactive'}" 
                                  data-performance="${tutor.rating >= 4.5 ? 'Excellent' : tutor.rating >= 4.0 ? 'Good' : tutor.rating >= 3.5 ? 'Average' : 'Poor'}">

                                <div class="tutor-header">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/uploads/default_avatar.jpg" 
                                                 alt="Tutor Avatar" class="tutor-avatar me-3">
                                            <div>
                                                <h5 class="mb-1">${tutor.cv.user.fullName}</h5>
                                                <small>
                                                    <i class="fas fa-envelope me-1"></i>${tutor.cv.user.email}<br>
                                                    <i class="fas fa-phone me-1"></i>N/A
                                                </small>
                                            </div>
                                        </div>
                                                                                 <div class="text-end">
                                             <span class="status-badge status-${tutor.cv.user.isActive == 1 ? 'active' : 'inactive'}">
                                                 ${tutor.cv.user.isActive == 1 ? 'Active' : 'Inactive'}
                                             </span>
                                             <br>
                                             <span class="status-badge performance-${tutor.rating >= 4.5 ? 'excellent' : tutor.rating >= 4.0 ? 'good' : tutor.rating >= 3.5 ? 'average' : 'poor'}">
                                                 ${tutor.rating >= 4.5 ? 'Excellent' : tutor.rating >= 4.0 ? 'Good' : tutor.rating >= 3.5 ? 'Average' : 'Poor'}
                                             </span>
                                         </div>
                                    </div>
                                    
                                    <!-- Performance Indicator -->
                                    <div class="performance-indicator performance-${tutor.rating >= 4.5 ? 'excellent' : tutor.rating >= 4.0 ? 'good' : tutor.rating >= 3.5 ? 'average' : 'poor'}-indicator"></div>
                                </div>
                                
                                <div class="tutor-body">
                                    <!-- Tutor Details -->
                                    <div class="tutor-details">
                                        <h6><i class="fas fa-graduation-cap me-2"></i>Education</h6>
                                        <p>N/A</p>
                                        
                                        <h6><i class="fas fa-briefcase me-2"></i>Teaching Experience</h6>
                                        <p>N/A</p>
                                        
                                        <h6><i class="fas fa-tools me-2"></i>Skills & Expertise</h6>
                                        <p>N/A</p>
                                        
                                        <h6><i class="fas fa-dollar-sign me-2"></i>Hourly Rate</h6>
                                        <p><strong><fmt:formatNumber value="${tutor.price}" pattern="#,###"/> VND/hour</strong></p>
                                    </div>
                                    
                                    <!-- Rating and Performance -->
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <h6><i class="fas fa-star me-2"></i>Student Rating</h6>
                                            <div class="rating-stars">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <c:choose>
                                                        <c:when test="${star <= tutor.rating}">
                                                            <i class="fas fa-star"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="far fa-star"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                <span class="text-dark ms-2">${tutor.rating}/5.0</span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <h6><i class="fas fa-chart-line me-2"></i>Performance</h6>
                                            <p class="mb-0">${tutor.rating * 20}% satisfaction rate</p>
                                        </div>
                                    </div>
                                    
                                    <!-- Tutor Meta Information -->
                                    <div class="tutor-meta">
                                        <div>
                                            <small>
                                                <i class="fas fa-calendar me-1"></i>Joined: N/A
                                            </small>
                                            <br>
                                            <small>
                                                <i class="fas fa-clock me-1"></i>Total Hours: N/A
                                            </small>
                                        </div>
                                        <div class="text-end">
                                            <small>
                                                <i class="fas fa-users me-1"></i>Students: N/A
                                            </small>
                                        </div>
                                    </div>
                                    
                                    <!-- Action Buttons -->
                                    <div class="action-buttons">
                                                                                 <button class="btn btn-view-profile btn-sm" onclick="viewProfile(${tutor.tutorID})">
                                             <i class="fas fa-eye me-1"></i>View Profile
                                         </button>
                                        <button class="btn btn-deactivate btn-sm" onclick="deactivateTutor(${tutor.tutorID})">
                                            <i class="fas fa-pause me-1"></i>Deactivate
                                        </button>
                                        <button class="btn btn-suspend btn-sm" onclick="suspendTutor(${tutor.tutorID})">
                                            <i class="fas fa-ban me-1"></i>Suspend
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Action Modal -->
    <div class="modal fade" id="actionModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="modalTitle">
                        <i class="fas fa-user-cog me-2"></i>Tutor Action
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="actionForm">
                        <input type="hidden" id="modalTutorId" name="tutorId">
                        <input type="hidden" id="modalAction" name="action">
                        
                        <div class="mb-3">
                            <label for="modalReason" class="form-label">Reason for Action:</label>
                            <textarea class="form-control" id="modalReason" name="reason" rows="3" 
                                      placeholder="Please provide a reason for this action..."></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Additional Options:</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="sendNotification" name="sendNotification">
                                <label class="form-check-label" for="sendNotification">
                                    Send notification to tutor
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="scheduleMeeting" name="scheduleMeeting">
                                <label class="form-check-label" for="scheduleMeeting">
                                    Schedule meeting to discuss
                                </label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                    <button type="button" class="btn btn-primary" onclick="submitAction()">
                        <i class="fas fa-check me-1"></i>Submit Action
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function viewProfile(tutorId) {
            // Redirect trực tiếp với User ID dựa trên Tutor ID
            if (tutorId === 1) {
                window.location.href = '${pageContext.request.contextPath}/profile?userID=26';
            } else if (tutorId === 2) {
                window.location.href = '${pageContext.request.contextPath}/profile?userID=27';
            } else {
                alert('Tutor ID không được hỗ trợ');
            }
        }
        

        
        function deactivateTutor(tutorId) {
            showActionModal(tutorId, 'deactivate', 'Deactivate Tutor');
        }
        
        function suspendTutor(tutorId) {
            showActionModal(tutorId, 'suspend', 'Suspend Tutor');
        }
        
        function showActionModal(tutorId, action, title) {
            document.getElementById('modalTutorId').value = tutorId;
            document.getElementById('modalAction').value = action;
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-user-cog me-2"></i>' + title;
            
            const modal = new bootstrap.Modal(document.getElementById('actionModal'));
            modal.show();
        }
        
        function submitAction() {
            const form = document.getElementById('actionForm');
            const formData = new FormData(form);
            
            // Submit form to servlet
            fetch('${pageContext.request.contextPath}/staff/tutor-management', {
                method: 'POST',
                body: formData
            }).then(response => {
                if (response.ok) {
                    // Reload page to show updated data
                    location.reload();
                } else {
                    alert('Error submitting action');
                }
            }).catch(error => {
                console.error('Error:', error);
                alert('Error submitting action');
            });
            
            // Close modal
            const modal = bootstrap.Modal.getInstance(document.getElementById('actionModal'));
            modal.hide();
        }
        
        function applyFilters() {
            const statusFilter = document.getElementById('statusFilter').value;
            const performanceFilter = document.getElementById('performanceFilter').value;
            const searchInput = document.getElementById('searchInput').value.toLowerCase();
            
            const cards = document.querySelectorAll('.tutor-card');
            
            cards.forEach(card => {
                const status = card.getAttribute('data-status');
                const performance = card.getAttribute('data-performance');
                const text = card.textContent.toLowerCase();
                
                let showCard = true;
                
                // Status filter
                if (statusFilter && status !== statusFilter) {
                    showCard = false;
                }
                
                // Performance filter
                if (performanceFilter && performance !== performanceFilter) {
                    showCard = false;
                }
                
                // Search filter
                if (searchInput && !text.includes(searchInput)) {
                    showCard = false;
                }
                
                card.style.display = showCard ? '' : 'none';
            });
        }
        
        function clearFilters() {
            document.getElementById('statusFilter').value = '';
            document.getElementById('performanceFilter').value = '';
            document.getElementById('searchInput').value = '';
            
            const cards = document.querySelectorAll('.tutor-card');
            cards.forEach(card => card.style.display = '');
        }
        
        // Auto-refresh every 60 seconds
        setInterval(() => {
            // Refresh data if needed
        }, 60000);
        
        // Apply filters on Enter key
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                applyFilters();
            }
        });
    </script>
</body>
</html>
