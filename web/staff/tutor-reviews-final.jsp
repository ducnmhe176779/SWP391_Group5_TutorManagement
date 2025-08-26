<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tutor Reviews - SmartTutor EDUCATION PROGRAMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .cv-review-card {
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        .cv-review-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        .cv-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px 12px 0 0;
            position: relative;
        }
        .cv-body {
            padding: 25px;
        }
        .status-badge {
            font-size: 12px;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-pending { background-color: #ffc107; color: #000; }
        .status-approved { background-color: #28a745; color: #fff; }
        .status-rejected { background-color: #dc3545; color: #fff; }
        .status-review { background-color: #17a2b8; color: #fff; }
        .priority-high { background-color: #dc3545; color: #fff; }
        .priority-medium { background-color: #fd7e14; color: #fff; }
        .priority-low { background-color: #28a745; color: #fff; }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .btn-approve { background-color: #28a745; border-color: #28a745; }
        .btn-reject { background-color: #dc3545; border-color: #dc3545; }
        .btn-hold { background-color: #6c757d; border-color: #6c757d; }
        .btn-request-info { background-color: #17a2b8; border-color: #17a2b8; }
        .review-notes {
            margin-top: 20px;
        }
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
        .cv-details {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
        }
        .cv-details h6 {
            color: #495057;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .cv-details p {
            color: #6c757d;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .no-cv-message {
            text-align: center;
            padding: 80px 20px;
            color: #6c757d;
        }
        .no-cv-message i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        .urgency-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }
        .urgency-high { background-color: #dc3545; }
        .urgency-medium { background-color: #fd7e14; }
        .urgency-low { background-color: #28a745; }
        
        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.2); opacity: 0.7; }
            100% { transform: scale(1); opacity: 1; }
        }
        
        .cv-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
        }
        .cv-meta small {
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Header -->
        <div class="row bg-primary text-white py-4">
            <div class="col">
                <h3><i class="fas fa-user-tie me-3"></i>Tutor CV Review Management</h3>
                <p class="mb-0">Review and manage tutor CV applications</p>
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
                    <h5><i class="fas fa-file-alt me-2"></i>Total CVs</h5>
                    <h2>${assignedCVs.size()}</h2>
                    <small>Assigned to you</small>
                </div>
                <div class="col-md-3">
                    <h5><i class="fas fa-clock me-2"></i>Pending Review</h5>
                    <h2>${assignedCVs.stream().filter(cv -> 'Pending'.equals(cv.status)).count()}</h2>
                    <small>Awaiting review</small>
                </div>
                <div class="col-md-3">
                    <h5><i class="fas fa-check-circle me-2"></i>Approved</h5>
                    <h2>${assignedCVs.stream().filter(cv -> 'Approved'.equals(cv.status)).count()}</h2>
                    <small>Accepted applications</small>
                </div>
                <div class="col-md-3">
                    <h5><i class="fas fa-times-circle me-2"></i>Rejected</h5>
                    <h2>${assignedCVs.stream().filter(cv -> 'Rejected'.equals(cv.status)).count()}</h2>
                    <small>Declined applications</small>
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
            <h5><i class="fas fa-filter me-2"></i>Filter & Search CVs</h5>
            <div class="filter-row">
                <div class="filter-item">
                    <label class="form-label">CV Status</label>
                    <select class="form-select" id="statusFilter">
                        <option value="">All Statuses</option>
                        <option value="Pending">Pending</option>
                        <option value="In Review">In Review</option>
                        <option value="Approved">Approved</option>
                        <option value="Rejected">Rejected</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="form-label">Priority Level</label>
                    <select class="form-select" id="priorityFilter">
                        <option value="">All Priorities</option>
                        <option value="1">High Priority</option>
                        <option value="2">Medium Priority</option>
                        <option value="3">Low Priority</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="form-label">Search Tutor</label>
                    <input type="text" class="form-control" id="searchInput" placeholder="Search by name, email...">
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

        <!-- CV Review List -->
        <c:choose>
            <c:when test="${empty assignedCVs}">
                <div class="no-cv-message">
                    <i class="fas fa-inbox"></i>
                    <h4>No CVs Assigned for Review</h4>
                    <p>You don't have any tutor CVs assigned to review at the moment.</p>
                    <p class="text-muted">New CV applications will be automatically assigned to you when they become available.</p>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-primary">
                            <i class="fas fa-arrow-left me-2"></i>Return to Dashboard
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="cv" items="${assignedCVs}">
                        <div class="col-lg-6">
                            <div class="cv-review-card" data-status="${cv.status}" data-priority="${cv.priority}">
                                <div class="cv-header">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/uploads/default_avatar.jpg" 
                                                 alt="Tutor Avatar" class="tutor-avatar me-3">
                                            <div>
                                                <h5 class="mb-1">${cv.tutorName}</h5>
                                                <small>
                                                    <i class="fas fa-envelope me-1"></i>${cv.tutorEmail}<br>
                                                    <i class="fas fa-phone me-1"></i>${cv.tutorPhone}
                                                </small>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <span class="status-badge status-${cv.status.toLowerCase().replace(' ', '-')}">
                                                ${cv.status}
                                            </span>
                                            <br>
                                            <span class="status-badge priority-${cv.priority == 1 ? 'high' : cv.priority == 2 ? 'medium' : 'low'}">
                                                Priority ${cv.priority}
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <!-- Urgency Indicator -->
                                    <div class="urgency-indicator urgency-${cv.priority == 1 ? 'high' : cv.priority == 2 ? 'medium' : 'low'}"></div>
                                </div>
                                
                                <div class="cv-body">
                                    <!-- CV Details -->
                                    <div class="cv-details">
                                        <h6><i class="fas fa-graduation-cap me-2"></i>Education</h6>
                                        <p>${cv.education != null ? cv.education : 'N/A'}</p>
                                        
                                        <h6><i class="fas fa-briefcase me-2"></i>Teaching Experience</h6>
                                        <p>${cv.experience != null ? cv.experience : 'N/A'}</p>
                                        
                                        <h6><i class="fas fa-tools me-2"></i>Skills & Expertise</h6>
                                        <p>${cv.skill != null ? cv.skill : 'N/A'}</p>
                                        
                                        <h6><i class="fas fa-dollar-sign me-2"></i>Hourly Rate</h6>
                                        <p><strong>${cv.price > 0 ? cv.price : 'N/A'} VND/hour</strong></p>
                                    </div>
                                    
                                    <!-- CV Meta Information -->
                                    <div class="cv-meta">
                                        <div>
                                            <small>
                                                <i class="fas fa-calendar me-1"></i>Assigned: 
                                                <fmt:formatDate value="${cv.assignedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                            <br>
                                            <small>
                                                <i class="fas fa-hashtag me-1"></i>CV ID: ${cv.cvID}
                                            </small>
                                        </div>
                                        <div class="text-end">
                                            <small>
                                                <i class="fas fa-clock me-1"></i>Priority: ${cv.priority}
                                            </small>
                                        </div>
                                    </div>
                                    
                                    <!-- Action Buttons -->
                                    <div class="action-buttons">
                                        <button class="btn btn-approve btn-sm" onclick="approveCV(${cv.assignmentID})">
                                            <i class="fas fa-check me-1"></i>Approve
                                        </button>
                                        <button class="btn btn-reject btn-sm" onclick="rejectCV(${cv.assignmentID})">
                                            <i class="fas fa-times me-1"></i>Reject
                                        </button>
                                        <button class="btn btn-hold btn-sm" onclick="holdCV(${cv.assignmentID})">
                                            <i class="fas fa-pause me-1"></i>Hold
                                        </button>
                                        <button class="btn btn-request-info btn-sm" onclick="requestInfo(${cv.assignmentID})">
                                            <i class="fas fa-question me-1"></i>Request Info
                                        </button>
                                    </div>
                                    
                                    <!-- Review Notes -->
                                    <div class="review-notes">
                                        <label for="notes-${cv.assignmentID}" class="form-label">
                                            <i class="fas fa-comment me-1"></i>Review Notes:
                                        </label>
                                        <textarea class="form-control" id="notes-${cv.assignmentID}" rows="3" 
                                                  placeholder="Add your review notes, feedback, or questions here..."></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Review Modal -->
    <div class="modal fade" id="reviewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-user-check me-2"></i>Review Tutor CV
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="reviewForm" method="post">
                        <input type="hidden" id="modalAssignmentId" name="assignmentId">
                        <input type="hidden" id="modalStatus" name="status">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Review Decision:</label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="statusRadio" value="Approved" id="statusApproved">
                                        <label class="form-check-label text-success" for="statusApproved">
                                            <i class="fas fa-check me-1"></i>Approve Application
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="statusRadio" value="Rejected" id="statusRejected">
                                        <label class="form-check-label text-danger" for="statusRejected">
                                            <i class="fas fa-times me-1"></i>Reject Application
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="statusRadio" value="In Review" id="statusReview">
                                        <label class="form-check-label text-warning" for="statusReview">
                                            <i class="fas fa-pause me-1"></i>Hold for Further Review
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Priority Level:</label>
                                    <select class="form-select" id="modalPriority" name="priority">
                                        <option value="1">High Priority</option>
                                        <option value="2">Medium Priority</option>
                                        <option value="3">Low Priority</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="modalReviewNotes" class="form-label">Detailed Review Notes:</label>
                            <textarea class="form-control" id="modalReviewNotes" name="reviewNotes" rows="5" 
                                      placeholder="Provide detailed feedback, reasons for decision, or any additional requirements..."></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Additional Actions:</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="sendEmail" name="sendEmail">
                                <label class="form-check-label" for="sendEmail">
                                    Send email notification to tutor
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="scheduleInterview" name="scheduleInterview">
                                <label class="form-check-label" for="scheduleInterview">
                                    Schedule interview for approved tutors
                                </label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                    <button type="button" class="btn btn-primary" onclick="submitReview()">
                        <i class="fas fa-check me-1"></i>Submit Review
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function approveCV(assignmentId) {
            showReviewModal(assignmentId, 'Approved');
        }
        
        function rejectCV(assignmentId) {
            showReviewModal(assignmentId, 'Rejected');
        }
        
        function holdCV(assignmentId) {
            showReviewModal(assignmentId, 'In Review');
        }
        
        function requestInfo(assignmentId) {
            showReviewModal(assignmentId, 'In Review');
        }
        
        function showReviewModal(assignmentId, status) {
            document.getElementById('modalAssignmentId').value = assignmentId;
            document.getElementById('modalStatus').value = status;
            
            // Set radio button
            document.getElementById('status' + status.replace(' ', '')).checked = true;
            
            // Get notes from the textarea
            const notes = document.getElementById('notes-' + assignmentId).value;
            document.getElementById('modalReviewNotes').value = notes;
            
            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('reviewModal'));
            modal.show();
        }
        
        function submitReview() {
            const form = document.getElementById('reviewForm');
            const formData = new FormData(form);
            
            // Submit form
            fetch('${pageContext.request.contextPath}/staff/cv-review', {
                method: 'POST',
                body: formData
            }).then(response => {
                if (response.ok) {
                    location.reload();
                }
            });
        }
        
        function applyFilters() {
            const statusFilter = document.getElementById('statusFilter').value;
            const priorityFilter = document.getElementById('priorityFilter').value;
            const searchInput = document.getElementById('searchInput').value.toLowerCase();
            
            const cards = document.querySelectorAll('.cv-review-card');
            
            cards.forEach(card => {
                const status = card.getAttribute('data-status');
                const priority = card.getAttribute('data-priority');
                const text = card.textContent.toLowerCase();
                
                let showCard = true;
                
                // Status filter
                if (statusFilter && status !== statusFilter) {
                    showCard = false;
                }
                
                // Priority filter
                if (priorityFilter && priority !== priorityFilter) {
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
            document.getElementById('priorityFilter').value = '';
            document.getElementById('searchInput').value = '';
            
            const cards = document.querySelectorAll('.cv-review-card');
            cards.forEach(card => card.style.display = '');
        }
        
        // Auto-refresh every 30 seconds
        setInterval(() => {
            location.reload();
        }, 30000);
        
        // Apply filters on Enter key
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                applyFilters();
            }
        });
    </script>
</body>
</html>
