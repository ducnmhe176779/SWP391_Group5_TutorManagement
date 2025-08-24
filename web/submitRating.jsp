<%-- 
    Document   : submitRating
    Created on : Mar 15, 2025, 2:05:02 PM
    Author     : minht
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
<head>
    <title>G4 SmartTutor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            position: relative; /* Để hỗ trợ định vị language-switcher */
        }
        h2 {
            color: #333;
        }
        .form-container {
            max-width: 600px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fff;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        select, textarea, button {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        select {
            background-color: #f9f9f9;
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        button {
            background-color: #4CAF50; /* Màu xanh lá cho nút */
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #45a049; /* Tông xanh đậm hơn khi hover */
        }
        .error {
            color: red;
            margin-bottom: 15px;
        }
        .language-switcher {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 1000;
        }
        .language-switcher select {
            padding: 5px;
            border-radius: 5px;
            background-color: #fff;
            color: #000;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <!-- Thiết lập Locale và Resource Bundle -->
    <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
    <fmt:setBundle basename="messages"/>

    <!-- Thêm phần chuyển ngôn ngữ -->
    <div class="language-switcher">
        <select class="header-lang-bx" onchange="window.location.href='LanguageServlet?lang=' + this.value;">
            <option value="en" ${sessionScope.locale == null || sessionScope.locale == 'en' ? 'selected' : ''}><fmt:message key="english"/></option>
            <option value="vi" ${sessionScope.locale == 'vi' ? 'selected' : ''}><fmt:message key="vietnamese"/></option>
        </select>
    </div>

    <h2><fmt:message key="rate_tutor"/></h2>
    
    <%-- Hiển thị thông báo lỗi nếu có --%>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <div class="form-container">
        <form id="ratingForm" action="${pageContext.request.contextPath}/TutorRatingController?service=addRating" method="post">
            <%-- Booking ID được truyền từ URL hoặc servlet --%>
            <input type="hidden" name="bookingId" value="${param.bookingId != null ? param.bookingId : ''}">

            <label for="rating"><fmt:message key="rating_score"/> (1-5):</label>
            <select name="rating" id="rating" required>
                <option value=""><fmt:message key="select_score"/></option>
                <option value="1">1 - <fmt:message key="poor"/></option>
                <option value="2">2 - <fmt:message key="average"/></option>
                <option value="3">3 - <fmt:message key="good"/></option>
                <option value="4">4 - <fmt:message key="very_good"/></option>
                <option value="5">5 - <fmt:message key="excellent"/></option>
            </select>

            <label for="comment"><fmt:message key="comment"/></label>
            <textarea name="comment" id="comment" placeholder="<fmt:message key='write_your_comment'/>" required></textarea>

            <button type="submit" name="submit" value="submit"><fmt:message key="submit_rating"/></button>
        </form>
    </div>

    <%-- JavaScript để kiểm tra dữ liệu trước khi gửi --%>
    <script>
        document.getElementById('ratingForm').addEventListener('submit', function(event) {
            var rating = document.getElementById('rating').value;
            var comment = document.getElementById('comment').value.trim();

            if (rating === '') {
                alert('<fmt:message key="please_select_rating"/>');
                event.preventDefault();
                return false;
            }
            if (comment === '') {
                alert('<fmt:message key="please_enter_comment"/>');
                event.preventDefault();
                return false;
            }
            if (comment.length < 10) {
                alert('<fmt:message key="comment_min_length"/>');
                event.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>