<%@page import="java.util.ArrayList"%>
<%@page import="model.DAOCv"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet,entity.User,entity.Subject,java.util.List"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

        <!-- FAVICONS ICON -->
        <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE -->
        <title>G5 SmartTutor</title>

        <!-- MOBILE SPECIFIC -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
    </head>
    <body id="bg">
        <%
            ResultSet rsTutor = (ResultSet) request.getAttribute("rsTutor");
            rsTutor.next();
        %>
        <%
            List<Subject> list = (List<Subject>) request.getAttribute("list");
            ResultSet rs = (ResultSet) request.getAttribute("rs");
            User user = (User) session.getAttribute("user");
        %>
        <%
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
        %>
        <script>
            alert("<%= successMessage%>");
        </script>
        <%
                session.removeAttribute("successMessage"); // Xóa thông báo sau khi hiển thị
            }
        %>  
        <!-- Thiết lập Locale và Resource Bundle -->
        <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
        <fmt:setBundle basename="messages"/>

        <div class="page-wraper">
            <div id="loading-icon-bx"></div>
            <!-- Header -->
            <header class="header rs-nav">
                <div class="top-bar">
                    <div class="container">
                        <div class="row d-flex justify-content-between">
                            <div class="topbar-left">
                                <ul>
                                    <li><a href="faq-1.jsp"><i class="fa fa-question-circle"></i><fmt:message key="ask_a_question"/></a></li>
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
                                    <% if (user == null) { %>
                                    <li><a href="login"><fmt:message key="login"/></a></li>
                                    <li><a href="User?service=registerUser"><fmt:message key="register"/></a></li>
                                        <% } else {%>
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
                                                <li><a href="StudentPaymentHistory"><fmt:message key="history_payment"/></a></li>
                                                <li><a href="cv"><fmt:message key="become_a_tutor"/></a></li>
                                                <li><a href="logout"><fmt:message key="logout"/></a></li>
                                            </ul>
                                        </div>
                                    </li>
                                    <% }%>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="sticky-header navbar-expand-lg">
                    <div class="menu-bar clearfix">
                        <div class="container clearfix">
                            <div class="menu-logo">
                                <a href="home"><img src="assets/images/logo.png" alt=""></a>
                            </div>
                            <button class="navbar-toggler collapsed menuicon justify-content-end" type="button" data-toggle="collapse" data-target="#menuDropdown" aria-controls="menuDropdown" aria-expanded="false" aria-label="Toggle navigation">
                                <span></span>
                                <span></span>
                                <span></span>
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
                                    <a href="home"><img src="assets/images/logo.png" alt=""></a>
                                </div>
                                <ul class="nav navbar-nav">	
                                    <li><a href="home"><fmt:message key="home"/></a></li>
                                    <li class="active"><a href="Tutor"><fmt:message key="our_tutor"/></a></li>
                                    <li><a href="ViewBlog"><fmt:message key="blog"/></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <!-- Content -->
            <div class="page-content bg-white">
                
                <div class="page-banner ovbl-dark" style="background-image:url(assets/images/banner/banner2.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white"><fmt:message key="tutor_details"/></h1>
                        </div>
                    </div>
                </div>
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="home"><fmt:message key="home"/></a></li>
                            <li><fmt:message key="tutor_details"/></li>
                        </ul>
                    </div>
                </div>
                <div class="content-block">
                    <div class="section-area section-sp1">
                        <div class="container">
                            <div class="row d-flex flex-row-reverse">
                                <div class="col-lg-3 col-md-4 col-sm-12 m-b30">
                                    <div class="course-detail-bx">
                                        <div class="course-price">
                                            <del>VND</del>
                                            <h4 class="price"><%=rsTutor.getInt(6)%></h4>
                                        </div>	
                                        <div class="course-buy-now text-center">
                                            <a href="bookschedule?subjectId=<%=rsTutor.getInt("SubjectID")%>&tutorId=<%=rsTutor.getInt("TutorID")%>" class="btn radius-xl text-uppercase"><fmt:message key="booking"/></a>
                                        </div>
                                        <div class="cours-more-info">
                                            <div class="review">
                                                <span><%= request.getAttribute("reviewCount")%> <fmt:message key="reviews"/></span>
                                                <ul class="cours-star">
                                                    <%
                                                        double avgRating = (Double) request.getAttribute("averageRating");
                                                        int soSao = (int) Math.floor(avgRating);
                                                        soSao = Math.max(0, Math.min(5, soSao));
                                                        for (int i = 0; i < soSao; i++) {
                                                    %>
                                                    <li class="active"><i class="fa fa-star"></i></li>
                                                        <%
                                                            }
                                                            for (int i = 0; i < 5 - soSao; i++) {
                                                        %>
                                                    <li><i class="fa fa-star"></i></li>
                                                        <%
                                                            }
                                                        %>
                                                </ul>
                                            </div>
                                            <div class="price categories">
                                                <span><fmt:message key="subject"/></span>
                                                <h5 class="text-primary"><%=rsTutor.getString(3)%></h5>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-9 col-md-8 col-sm-12">
                                    <div class="courses-post">
                                        <img width="300" height="300" src="<%=rsTutor.getString(5)%>" alt="">
                                        <div class="ttr-post-info">
                                            <div class="ttr-post-title ">
                                                <h2 class="post-title"><%=rsTutor.getString(2)%></h2>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="courese-overview" id="overview">
                                        <div class="col-md-12 col-lg-8">
                                            <h5 class="m-b5"><fmt:message key="tutor_description"/></h5>
                                            <p><%=rsTutor.getString(7)%></p>
                                            <h5 class="m-b5"><fmt:message key="certification"/></h5>
                                            <p><%=rsTutor.getString("Certificates")%></p>
                                            <h5 class="m-b5"><fmt:message key="skill"/></h5>
                                            <p><%=rsTutor.getString("Skill")%></p>
                                            <ul class="list-checked primary"></ul>
                                        </div>
                                    </div>
                                </div>
                                <div class="reviews-section" id="reviews">
                                    <h4><fmt:message key="what_my_students_say"/></h4>
                                    <div class="review-bx">
                                        <div class="all-review">
                                            <h2 class="rating-type"><%= String.format("%.1f", request.getAttribute("averageRating"))%></h2>
                                            <ul class="cours-star">
                                                <%
                                                    for (int i = 0; i < 5; i++) {
                                                        if (i < Math.floor(avgRating)) {
                                                %>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                    <%
                                                    } else {
                                                    %>
                                                <li><i class="fa fa-star"></i></li>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                            </ul>
                                            <span><%= request.getAttribute("reviewCount")%> <fmt:message key="reviews"/></span>
                                        </div>
                                        <div class="rating-distribution">
                                            <%
                                                int[] ratingDist = (int[]) request.getAttribute("ratingDistribution");
                                                int reviewCount = (Integer) request.getAttribute("reviewCount");
                                                for (int i = 4; i >= 0; i--) {
                                                    int count = ratingDist[i];
                                                    double percentage = reviewCount > 0 ? (double) count / reviewCount * 100 : 0;
                                            %>
                                            <div class="rating-bar">
                                                <span><%= (i + 1)%> <fmt:message key="stars"/></span>
                                                <div class="bar-container">
                                                    <div class="bar" style="width: <%= percentage%>%;"></div>
                                                </div>
                                                <span>(<%= count%>)</span>
                                            </div>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                    <div class="student-reviews" id="student-reviews">
                                        <%
                                            List<Object[]> reviews= (List<Object[]>)request.getAttribute("reviews");
                                            int displayLimit = Math.min(6, reviews.size());
                                            for (int i = 0; i < displayLimit; i++) {
                                                Object[] review = reviews.get(i);
                                                int studentId = (int) review[0];
                                                int rating = (int) review[1];
                                                String comment = (String) review[2];
                                                String ratingDate = (String) review[3];
                                                String reviewerName = (String) review[4];
                                                String reviewerAvatar = (String) review[5];
                                                boolean isLongReview = (boolean) review[6];
                                                String displayText = (String) review[7];
                                        %>
                                        <div class="review-card">
                                            <div class="reviewer-info">
                                                <div class="reviewer-avatar">
                                                    <% if (reviewerAvatar != null && !reviewerAvatar.isEmpty()) {%>
                                                    <img src="${pageContext.request.contextPath}/<%= reviewerAvatar%>" alt="<%= reviewerName%>" width="32" height="32" onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                                    <% } else {%>
                                                    <div class="avatar-placeholder"><%= reviewerName.charAt(0)%></div>
                                                    <% }%>
                                                </div>
                                                <div class="reviewer-details">
                                                    <h5><%= reviewerName%></h5>
                                                    <span><%= ratingDate%></span>
                                                </div>
                                            </div>
                                            <ul class="cours-star">
                                                <% for (int j = 0; j < 5; j++) {%>
                                                <li class="<%= j < rating ? "active" : ""%>"><i class="fa fa-star"></i></li>
                                                    <% }%>
                                            </ul>
                                            <p><%= displayText%>
                                                <% if (isLongReview) {%>
                                                <a href="javascript:void(0);" class="show-more" data-fulltext="<%= comment%>"><fmt:message key="show_more"/></a>
                                                <% } %>
                                            </p>
                                        </div>
                                        <%
                                            }
                                        %>
                                        <% if (reviews.size() > 6) { %>
                                        <div class="view-more-container text-center">
                                            <button id="view-more-btn" class="btn radius-xl text-uppercase"><fmt:message key="show_more"/></button>
                                        </div>
                                        <div class="grid-row-break"></div>
                                        <div id="hidden-reviews" style="display: none;">
                                            <%
                                                for (int i = 6; i < reviews.size(); i++) {
                                                    Object[] review = reviews.get(i);
                                                    int studentId = (int) review[0];
                                                    int rating = (int) review[1];
                                                    String comment = (String) review[2];
                                                    String ratingDate = (String) review[3];
                                                    String reviewerName = (String) review[4];
                                                    String reviewerAvatar = (String) review[5];
                                                    boolean isLongReview = (boolean) review[6];
                                                    String displayText = (String) review[7];
                                            %>
                                            <div class="review-card">
                                                <div class="reviewer-info">
                                                    <div class="reviewer-avatar">
                                                        <% if (reviewerAvatar != null && !reviewerAvatar.isEmpty()) {%>
                                                        <img src="${pageContext.request.contextPath}/<%= reviewerAvatar%>" alt="<%= reviewerName%>" width="32" height="32" onerror="this.src='${pageContext.request.contextPath}/uploads/default_avatar.jpg'">
                                                        <% } else {%>
                                                        <div class="avatar-placeholder"><%= reviewerName.charAt(0)%></div>
                                                        <% }%>
                                                    </div>
                                                    <div class="reviewer-details">
                                                        <h5><%= reviewerName%></h5>
                                                        <span><%= ratingDate%></span>
                                                    </div>
                                                </div>
                                                <ul class="cours-star">
                                                    <% for (int j = 0; j < 5; j++) {%>
                                                    <li class="<%= j < rating ? "active" : ""%>"><i class="fa fa-star"></i></li>
                                                        <% }%>
                                                </ul>
                                                <p><%= displayText%>
                                                    <% if (isLongReview) {%>
                                                    <a href="javascript:void(0);" class="show-more" data-fulltext="<%= comment%>"><fmt:message key="show_more"/></a>
                                                    <% } %>
                                                </p>
                                            </div>
                                            <%
                                                }
                                            %>
                                        </div>
                                        <div class="collapse-container text-center">
                                            <button id="collapse-btn" class="btn radius-xl text-uppercase" style="display: none;"><fmt:message key="collapse"/></button>
                                        </div>
                                        <% }%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            const viewMoreBtn = document.getElementById('view-more-btn');
                            const collapseBtn = document.getElementById('collapse-btn');
                            const hiddenReviews = document.getElementById('hidden-reviews');
                            if (viewMoreBtn && collapseBtn && hiddenReviews) {
                                viewMoreBtn.addEventListener('click', function () {
                                    hiddenReviews.style.display = 'contents';
                                    viewMoreBtn.style.display = 'none';
                                    collapseBtn.style.display = 'inline-block';
                                    console.log('Đã hiển thị đánh giá ẩn');
                                });
                                collapseBtn.addEventListener('click', function () {
                                    hiddenReviews.style.display = 'none';
                                    viewMoreBtn.style.display = 'inline-block';
                                    collapseBtn.style.display = 'none';
                                    console.log('Đã rút lại đánh giá');
                                });
                            }
                            document.querySelectorAll('.show-more').forEach(link => {
                                link.addEventListener('click', function () {
                                    const fullText = this.getAttribute('data-fulltext');
                                    const reviewText = this.parentElement;
                                    reviewText.innerHTML = fullText;
                                });
                            });
                        });
                    </script>
                </div>
            </div>
            <!-- Footer -->
            <footer>
                <div class="footer-top">
                    <div class="pt-exebar">
                        <div class="container">
                            <div class="d-flex align-items-stretch">
                                <div class="pt-logo mr-auto">
                                    <a href="home"><img src="assets/images/logo-white.png" alt=""/></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
            <button class="back-to-top fa fa-chevron-up"></button>
        </div>
        <!-- External JavaScripts -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
        <script src="assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="assets/vendors/counter/waypoints-min.js"></script>
        <script src="assets/vendors/counter/counterup.min.js"></script>
        <script src="assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="assets/vendors/masonry/masonry.js"></script>
        <script src="assets/vendors/masonry/filter.js"></script>
        <script src="assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src="assets/js/jquery.scroller.js"></script>
        <script src="assets/js/functions.js"></script>
        <script src="assets/js/contact.js"></script>
        <script src="assets/vendors/switcher/switcher.js"></script>
    </body>
</html>