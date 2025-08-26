<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff CV Review - Tutor Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .cv-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .cv-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .cv-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .cv-body {
            padding: 20px;
        }
        .status-badge {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 12px;
        }
        .status-pending { background-color: #ffc107; color: #000; }
        .status-review { background-color: #17a2b8; color: #fff; }
        .priority-high { background-color: #dc3545; color: #fff; }
        .priority-medium { background-color: #fd7e14; color: #fff; }
        .priority-low { background-color: #28a745; color: #fff; }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        .btn-approve { background-color: #28a745; border-color: #28a745; }
        .btn-reject { background-color: #dc3545; border-color: #dc3545; }
        .btn-hold { background-color: #6c757d; border-color: #6c757d; }
        .review-notes {
            margin-top: 15px;
        }
        .stats-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .no-cv-message {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        .no-cv-message i {
            font-size: 48px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Header -->
        <div class="row bg-dark text-white py-3">
            <div class="col">
                <h4><i class="fas fa-user-tie me-2"></i>Staff CV Review Dashboard</h4>
                <p class="mb-0">Review and manage assigned CV applications</p>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a>
            </div>
        </div>

        <!-- Stats Overview -->
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="stats-card">
                    <h5><i class="fas fa-file-alt me-2"></i>Total Assigned CVs</h5>
                    <h2>${assignedCVs.size()}</h2>
                    <small>CVs assigned to you</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <h5><i class="fas fa-clock me-2"></i>Pending Review</h5>
                    <h2>${assignedCVs.stream().filter(cv -> cv.getStatus().equals('Pending')).count()}</h2>
                    <small>Awaiting your review</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <h5><i class="fas fa-check-circle me-2"></i>Completed</h5>
                    <h2>${assignedCVs.stream().filter(cv -> cv.getStatus().equals('Approved') || cv.getStatus().equals('Rejected')).count()}</h2>
                    <small>Reviews completed</small>
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

        <!-- CV List -->
        <c:choose>
            <c:when test="${empty assignedCVs}">
                <div class="no-cv-message">
                    <i class="fas fa-inbox"></i>
                    <h4>No CVs Assigned</h4>
                    <p>You don't have any CVs assigned to review at the moment.</p>
                    <p class="text-muted">New CVs will be automatically assigned to you when they become available.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="cv" items="${assignedCVs}">
                        <div class="col-lg-6">
                            <div class="cv-card">
                                <div class="cv-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="mb-1">
                                                <i class="fas fa-user-graduate me-2"></i>${cv.tutorName}
                                            </h6>
                                            <small>
                                                <i class="fas fa-envelope me-1"></i>${cv.tutorEmail}
                                                <i class="fas fa-phone ms-3 me-1"></i>${cv.tutorPhone}
                                            </small>
                                        </div>
                                        <div class="text-end">
                                            <span class="status-badge status-${cv.status.toLowerCase()}">
                                                ${cv.status}
                                            </span>
                                            <br>
                                            <span class="status-badge priority-${cv.priority == 1 ? 'high' : cv.priority == 2 ? 'medium' : 'low'}">
                                                Priority ${cv.priority}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="cv-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6><i class="fas fa-graduation-cap me-2"></i>Education</h6>
                                            <p class="text-muted">${cv.education}</p>
                                            
                                            <h6><i class="fas fa-briefcase me-2"></i>Experience</h6>
                                            <p class="text-muted">${cv.experience}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6><i class="fas fa-tools me-2"></i>Skills</h6>
                                            <p class="text-muted">${cv.skill}</p>
                                            
                                            <h6><i class="fas fa-dollar-sign me-2"></i>Price</h6>
                                            <p class="text-muted">${cv.price} VND/hour</p>
                                        </div>
                                    </div>
                                    
                                    <div class="row mt-3">
                                        <div class="col-md-6">
                                            <small class="text-muted">
                                                <i class="fas fa-calendar me-1"></i>Assigned: 
                                                <fmt:formatDate value="${cv.assignedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </div>
                                        <div class="col-md-6">
                                            <small class="text-muted">
                                                <i class="fas fa-hashtag me-1"></i>CV ID: ${cv.cvID}
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
                                    </div>
                                    
                                    <!-- Review Notes -->
                                    <div class="review-notes">
                                        <label for="notes-${cv.assignmentID}" class="form-label">
                                            <i class="fas fa-comment me-1"></i>Review Notes:
                                        </label>
                                        <textarea class="form-control" id="notes-${cv.assignmentID}" rows="2" 
                                                  placeholder="Add your review notes here..."></textarea>
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
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Review CV</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="reviewForm" method="post">
                        <input type="hidden" id="modalAssignmentId" name="assignmentId">
                        <input type="hidden" id="modalStatus" name="status">
                        
                        <div class="mb-3">
                            <label class="form-label">Status:</label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="statusRadio" value="Approved" id="statusApproved">
                                <label class="form-check-label" for="statusApproved">
                                    <i class="fas fa-check text-success me-1"></i>Approve
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="statusRadio" value="Rejected" id="statusRejected">
                                <label class="form-check-label" for="statusRejected">
                                    <i class="fas fa-times text-danger me-1"></i>Reject
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="statusRadio" value="In Review" id="statusReview">
                                <label class="form-check-label" for="statusReview">
                                    <i class="fas fa-pause text-warning me-1"></i>Hold for Review
                                </label>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="modalReviewNotes" class="form-label">Review Notes:</label>
                            <textarea class="form-control" id="modalReviewNotes" name="reviewNotes" rows="4" 
                                      placeholder="Provide detailed feedback..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="submitReview()">Submit Review</button>
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
        
        // Auto-refresh every 30 seconds
        setInterval(() => {
            location.reload();
        }, 30000);
    </script>
</body>
</html>
