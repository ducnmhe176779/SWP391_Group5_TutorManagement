<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html lang="${sessionScope.locale != null ? sessionScope.locale : 'en'}">
<head>
    <title>G4 SmartTutor : <fmt:message key="rate_tutor"/></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .star-rating {
            display: flex;
            justify-content: center;
            direction: rtl;
            margin-bottom: 15px;
        }
        .star-rating input {
            display: none;
        }
        .star-rating label {
            font-size: 30px;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
        }
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #f9bf3b;
        }
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: vertical;
            min-height: 100px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            text-transform: uppercase;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #45a049;
        }
        .error {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : 'en'}"/>
    <fmt:setBundle basename="messages"/>

    <div class="container">
        <h2><fmt:message key="rate_tutor"/></h2>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <form id="ratingForm" action="${pageContext.request.contextPath}/TutorRatingController?service=addRating" method="post">
            <input type="hidden" name="bookingId" value="${param.bookingId != null ? param.bookingId : ''}">
            <div class="form-group">
                <label><fmt:message key="rating_score"/> (1-5 <fmt:message key="stars"/>):</label>
                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5" required>
                    <label for="star5">★</label>
                    <input type="radio" id="star4" name="rating" value="4">
                    <label for="star4">★</label>
                    <input type="radio" id="star3" name="rating" value="3">
                    <label for="star3">★</label>
                    <input type="radio" id="star2" name="rating" value="2">
                    <label for="star2">★</label>
                    <input type="radio" id="star1" name="rating" value="1">
                    <label for="star1">★</label>
                </div>
            </div>
            <div class="form-group">
                <label for="comment"><fmt:message key="comment"/>:</label>
                <textarea name="comment" id="comment" placeholder="<fmt:message key='write_your_comment'/>" required></textarea>
            </div>
            <button type="submit" name="submit" value="submit"><fmt:message key="submit_rating"/></button>
        </form>
    </div>
    <script>
        document.getElementById('ratingForm').addEventListener('submit', function(event) {
            var rating = document.querySelector('input[name="rating"]:checked');
            var comment = document.getElementById('comment').value.trim();

            if (!rating) {
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