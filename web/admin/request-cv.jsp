<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - CV Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .stats-card {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: center;
        }
        .cv-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            border-left: 4px solid #ffc107;
        }
        .cv-header {
            background: linear-gradient(135deg, #ffc107 0%, #ff8f00 100%);
            color: white;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .cv-body {
            padding: 20px;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
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
        .cv-info {
            background: #f8f9fa;
            border-radius: 5px;
            padding: 10px;
            margin: 5px 0;
        }
        .cv-info h6 {
            color: #495057;
            margin-bottom: 5px;
        }
        .cv-info p {
            margin-bottom: 0;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Header -->
        <div class="row bg-warning text-dark py-3">
            <div class="col">
                <h4><i class="fas fa-clock me-2"></i>Admin - CV Requests</h4>
                <p class="mb-0">Review and process CV applications with status 'Pending' from CV table</p>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/admin/index" class="btn btn-outline-dark me-2">
                    <i class="fas fa-home me-2"></i>Dashboard
                </a>
            </div>
        </div>

        <!-- Stats Overview -->
        <div class="row mt-4">
            <div class="col-md-6 offset-md-3">
                <div class="stats-card">
                    <h5><i class="fas fa-exclamation-triangle me-2"></i>Pending CV Requests</h5>
                    <h2>${totalPendingCVs}</h2>
                    <small>CVs waiting for review and assignment</small>
                </div>
            </div>
        </div>

        <!-- CV List -->
        <div class="row">
            <div class="col-12">
                <c:choose>
                    <c:when test="${empty pendingCVs}">
                        <div class="no-cv-message">
                            <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                            <h5 class="text-success">No Pending CV Requests</h5>
                            <p class="text-muted">All CV applications have been processed. Great job!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row">
                            <c:forEach var="cv" items="${pendingCVs}">
                                <div class="col-lg-6">
                                    <div class="cv-card">
                                        <div class="cv-header">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="mb-1">
                                                        <i class="fas fa-user-graduate me-2"></i>CV #${cv.cvId}
                                                    </h6>
                                                    <small>User ID: ${cv.userId}</small>
                                                </div>
                                                <div class="text-end">
                                                    <span class="badge bg-warning text-dark">
                                                        <i class="fas fa-clock me-1"></i>Pending
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="cv-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="cv-info">
                                                        <h6><i class="fas fa-graduation-cap me-2"></i>Education</h6>
                                                        <p>${cv.education}</p>
                                                    </div>
                                                    
                                                    <div class="cv-info">
                                                        <h6><i class="fas fa-briefcase me-2"></i>Experience</h6>
                                                        <p>${cv.experience}</p>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="cv-info">
                                                        <h6><i class="fas fa-tools me-2"></i>Skills</h6>
                                                        <p>${cv.skill}</p>
                                                    </div>
                                                    
                                                    <div class="cv-info">
                                                        <h6><i class="fas fa-dollar-sign me-2"></i>Price</h6>
                                                        <p>${cv.price} VND/hour</p>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row mt-3">
                                                <div class="col-md-6">
                                                    <div class="cv-info">
                                                        <h6><i class="fas fa-hashtag me-2"></i>CV ID</h6>
                                                        <p>${cv.cvId}</p>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="cv-info">
                                                        <h6><i class="fas fa-user me-2"></i>User ID</h6>
                                                        <p>${cv.userId}</p>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row mt-2">
                                                <div class="col-md-6">
                                                    <div class="cv-info">
                                                        <h6><i class="fas fa-book me-2"></i>Subject ID</h6>
                                                        <p>${cv.subjectId}</p>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="cv-info">
                                                        <h6><i class="fas fa-certificate me-2"></i>Certificates</h6>
                                                        <p>${cv.certificates}</p>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row mt-2">
                                                <div class="col-12">
                                                    <div class="cv-info">
                                                        <h6><i class="fas fa-comment me-2"></i>Description</h6>
                                                        <p>${cv.description}</p>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Action Buttons -->
                                            <div class="action-buttons">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/RequestCV" class="d-flex gap-2">
                                                    <input type="hidden" name="cvId" value="${cv.cvId}" />
                                                    <button name="action" value="approve" class="btn btn-primary btn-sm" type="submit">
                                                        <i class="fas fa-check me-1"></i>Approve
                                                    </button>
                                                    <button name="action" value="reject" class="btn btn-danger btn-sm" type="submit">
                                                        <i class="fas fa-times me-1"></i>Reject
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-refresh every 60 seconds
        setInterval(() => { location.reload(); }, 60000);
    </script>
</body>
</html>
