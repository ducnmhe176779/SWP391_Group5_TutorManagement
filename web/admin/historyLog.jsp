<%@page import="entity.User"%>
<%@page import="entity.HistoryLog"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />
        <meta name="description" content="G5 SmartTutor : Admin History Log" />
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Admin History Log - G5 SmartTutor</title>

        <!-- Favicon -->
        <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
        
        <!-- Custom CSS for History Log -->
        <style>
            .history-log-container {
                padding: 20px;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin: 20px 0;
            }
            
            .log-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            
            .log-table th {
                background: #f8f9fa;
                padding: 12px;
                text-align: left;
                border-bottom: 2px solid #dee2e6;
                font-weight: 600;
                color: #495057;
            }
            
            .log-table td {
                padding: 12px;
                border-bottom: 1px solid #dee2e6;
                vertical-align: top;
            }
            
            .log-table tr:hover {
                background-color: #f8f9fa;
            }
            
            .log-action {
                font-weight: 600;
                color: #007bff;
            }
            
            .log-role {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
            }
            
            .role-admin { background: #dc3545; color: white; }
            .role-user { background: #28a745; color: white; }
            .role-tutor { background: #17a2b8; color: white; }
            .role-staff { background: #ffc107; color: #212529; }
            .role-anonymous { background: #6c757d; color: white; }
            
            .log-timestamp {
                color: #6c757d;
                font-size: 14px;
            }
            
            .search-filter {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            
            .filter-group {
                display: inline-block;
                margin-right: 20px;
                margin-bottom: 10px;
            }
            
            .filter-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
            }
            
            .filter-group select,
            .filter-group input {
                padding: 8px 12px;
                border: 1px solid #ced4da;
                border-radius: 4px;
                width: 200px;
            }
            
            .filter-btn {
                background: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                margin-top: 20px;
            }
            
            .filter-btn:hover {
                background: #0056b3;
            }
            
            .no-logs {
                text-align: center;
                padding: 40px;
                color: #6c757d;
                font-style: italic;
            }
            
            .export-btn {
                background: #28a745;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                float: right;
                margin-top: -50px;
            }
            
            .export-btn:hover {
                background: #1e7e34;
            }
        </style>
    </head>
    <body id="bg">
        <%
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRoleID() != 1) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        %>
        
        <!-- Thiết lập Locale và Resource Bundle -->
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper">
            <!-- Header -->
            <header class="header rs-nav">
                <div class="top-bar">
                    <div class="container">
                        <div class="row d-flex justify-content-between">
                            <div class="topbar-left">
                                <ul>
                                    <li><a href="javascript:;"><i class="fa fa-question-circle"></i><fmt:message key="ask_a_question"/></a></li>
                                    <li><a href="javascript:;"><i class="fa fa-envelope-o"></i><fmt:message key="support_email"/></a></li>
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
                                                    <a href="profile" class="ttr-material-button ttr-submenu-toggle">
                                                        <span class="ttr-user-avatar">
                                                            <img alt="" 
                                                                 src="${pageContext.request.contextPath}/<%= user.getAvatar() != null ? user.getAvatar() : "uploads/default_avatar.jpg"%>" 
                                                                 width="32" height="32"
                                                                 onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                                        </span>
                                                    </a>
                                                </li>
                                                <li><a href="profile"><fmt:message key="my_profile"/></a></li>
                                                <li><a href="logout"><fmt:message key="logout"/></a></li>
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
                                <a href="${pageContext.request.contextPath}/admin/index"><img src="${pageContext.request.contextPath}/assets/images/logo.png" alt=""></a>
                            </div>
                            <div class="menu-links navbar-collapse collapse justify-content-start" id="menuDropdown">
                                <ul class="nav navbar-nav">    
                                    <li><a href="${pageContext.request.contextPath}/admin/index"><fmt:message key="dashboard"/></a></li>
                                    <li><a href="${pageContext.request.contextPath}/admin/AdminSubjectController?service=listSubject&size=5&tutorSize=5"><fmt:message key="subject_management"/></a></li>
                                    <li class="active"><a href="${pageContext.request.contextPath}/admin/historyLog"><fmt:message key="history_log"/></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Content -->
            <div class="page-content bg-white">
                <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/banner/banner1.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white"><fmt:message key="history_log"/></h1>
                        </div>
                    </div>
                </div>
                
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="${pageContext.request.contextPath}/admin/index"><fmt:message key="dashboard"/></a></li>
                            <li><fmt:message key="history_log"/></li>
                        </ul>
                    </div>
                </div>

                <div class="content-block">
                    <div class="section-area section-sp1">
                        <div class="container">
                            <!-- Search and Filter Section -->
                            <div class="search-filter">
                                <h4><fmt:message key="filter_logs"/></h4>
                                <form method="GET" action="${pageContext.request.contextPath}/admin/historyLog">
                                    <div class="filter-group">
                                        <label for="action"><fmt:message key="action"/></label>
                                        <select name="action" id="action">
                                            <option value="">All Actions</option>
                                            <option value="LOGIN">Login</option>
                                            <option value="LOGOUT">Logout</option>
                                            <option value="CREATE">Create</option>
                                            <option value="UPDATE">Update</option>
                                            <option value="DELETE">Delete</option>
                                            <option value="VIEW">View</option>
                                        </select>
                                    </div>
                                    
                                    <div class="filter-group">
                                        <label for="role"><fmt:message key="role"/></label>
                                        <select name="role" id="role">
                                            <option value="">All Roles</option>
                                            <option value="1">Admin</option>
                                            <option value="2">User</option>
                                            <option value="3">Tutor</option>
                                            <option value="4">Staff</option>
                                        </select>
                                    </div>
                                    
                                    <div class="filter-group">
                                        <label for="dateFrom"><fmt:message key="date_from"/></label>
                                        <input type="date" name="dateFrom" id="dateFrom">
                                    </div>
                                    
                                    <div class="filter-group">
                                        <label for="dateTo"><fmt:message key="date_to"/></label>
                                        <input type="date" name="dateTo" id="dateTo">
                                    </div>
                                    
                                    <button type="submit" class="filter-btn"><fmt:message key="apply_filter"/></button>
                                </form>
                            </div>

                            <!-- Export Button -->
                            <button class="export-btn" onclick="exportToCSV()">
                                <i class="fa fa-download"></i> Export to CSV
                            </button>

                            <!-- History Log Table -->
                            <div class="history-log-container">
                                <h3><fmt:message key="activity_logs"/></h3>
                                
                                <c:if test="${not empty requestScope.error}">
                                    <div class="alert alert-danger">
                                        ${requestScope.error}
                                    </div>
                                </c:if>

                                <c:choose>
                                    <c:when test="${not empty logs}">
                                        <table class="log-table">
                                            <thead>
                                                <tr>
                                                    <th><fmt:message key="timestamp"/></th>
                                                    <th><fmt:message key="user"/></th>
                                                    <th><fmt:message key="role"/></th>
                                                    <th><fmt:message key="action"/></th>
                                                    <th><fmt:message key="description"/></th>
                                                    <th><fmt:message key="ip_address"/></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="log" items="${logs}">
                                                    <tr>
                                                        <td class="log-timestamp">
                                                            <fmt:formatDate value="${log.timestamp}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                        </td>
                                                        <td>
                                                            <strong>${log.fullName}</strong><br>
                                                            <small>${log.email}</small>
                                                        </td>
                                                        <td>
                                                            <span class="log-role role-${log.roleName.toLowerCase()}">
                                                                ${log.roleName}
                                                            </span>
                                                        </td>
                                                        <td class="log-action">${log.action}</td>
                                                        <td>${log.description}</td>
                                                        <td>${log.ipAddress}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-logs">
                                            <h4><fmt:message key="no_logs_found"/></h4>
                                            <p><fmt:message key="no_activity_logs_message"/></p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <footer>
                <div class="footer-top">
                    <div class="pt-exebar">
                        <div class="container">
                            <div class="d-flex align-items-stretch">
                                <div class="pt-logo mr-auto">
                                    <a href="${pageContext.request.contextPath}/admin/index"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt=""/></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
        </div>

        <!-- JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        
        <script>
            // Export to CSV functionality
            function exportToCSV() {
                const table = document.querySelector('.log-table');
                if (!table) return;
                
                let csv = [];
                const rows = table.querySelectorAll('tr');
                
                for (const row of rows) {
                    const cols = row.querySelectorAll('td, th');
                    const rowArray = [];
                    for (const col of cols) {
                        rowArray.push('"' + col.innerText.replace(/"/g, '""') + '"');
                    }
                    csv.push(rowArray.join(','));
                }
                
                const csvContent = csv.join('\n');
                const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
                const link = document.createElement('a');
                const url = URL.createObjectURL(blob);
                link.setAttribute('href', url);
                link.setAttribute('download', 'admin_history_log.csv');
                link.style.visibility = 'hidden';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
            
            // Auto-refresh logs every 30 seconds
            setInterval(function() {
                // You can implement AJAX refresh here if needed
            }, 30000);
        </script>
    </body>
</html>
