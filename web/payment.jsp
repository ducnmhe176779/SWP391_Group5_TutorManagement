<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
        <title>G5 SmartTutor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            text-align: center;
            margin-top: 50px;
        }
        .payment-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            width: 500px;
            margin: auto;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .payment-box h2 {
            margin-bottom: 20px;
        }
        .details {
            text-align: left;
            margin-bottom: 20px;
        }
        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .schedule-table th, .schedule-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .schedule-table th {
            background-color: #f2f2f2;
        }
        .btn {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="payment-box">
        <h2>Thanh Toán Buổi Học</h2>
        <div class="details">
            <p><strong>Gia sư:</strong> ${sessionScope.tutorName}</p>
            <p><strong>Môn học:</strong> ${sessionScope.subjectName}</p>
            <p><strong>Tổng giá:</strong> <fmt:formatNumber value="${sessionScope.totalAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</p>
        </div>
        <h4>Lịch học đã chọn:</h4>
        <table class="schedule-table">
            <thead>
                <tr>
                    <th>Ngày học</th>
                    <th>Giờ học</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="schedule" items="${sessionScope.selectedSchedules}">
                    <tr>
                        <td><fmt:formatDate value="${schedule.startTime}" pattern="dd/MM/yyyy" /></td>
                        <td><fmt:formatDate value="${schedule.startTime}" pattern="HH:mm" /> - <fmt:formatDate value="${schedule.endTime}" pattern="HH:mm" /></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty sessionScope.selectedSchedules}">
                    <tr>
                        <td colspan="2">Không có lịch học nào được chọn.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
        <form action="PaymentBooking" method="post">
            <button type="submit" class="btn">Thanh Toán</button>
        </form>
    </div>
</body>
</html>
