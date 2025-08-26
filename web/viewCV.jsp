<%-- 
    Document   : viewCV
    Created on : Mar 7, 2025, 10:41:14 AM
    Author     : dvdung
--%>

<%@page import="entity.User"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>G4 SmartTutor</title>
        <link rel="stylesheet" href="assets/css/styleCV.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
    </head>
    <%
        User user = (User) session.getAttribute("user");
    %>
    <body>
        <div class="container">
            <div class="avatar">
                <img src="<%=user.getAvatar()%>" alt="">
            </div>
            <div class="name">
                <h1><%=user.getFullName()%></h1>
                <div class="input-group">
                    <label>Subject</label>

                </div>
                <ul class="contact">
                    <li>
                        <span>P</span> <%=user.getPhone()%>
                    </li>
                    <li>
                        <span>E</span> <%=user.getEmail()%>
                    </li>
                </ul>
            </div>
            <div class="info">
                <ul>
                    <li><%=user.getAddress()%></li>
                    <li><%=user.getEmail()%></li>
                </ul>
            </div>
            <div class="intro">
                <h2>INTRODUCE MYSELT</h2>
                <input type="text" name="Description" class="form-control" required>
                <h2>Education</h2>
                <input type="text" name="education" class="form-control" required>
                <h2>certificates</h2>
                <input type="text" name="certificates" class="form-control" required>
                <h2>EXPERIENCE</h2>
                <div class="item">
                    <input type="text" name="experience" class="form-control" required>
                </div>
                <h2>certificates</h2>
                <input type="text" name="certificates" class="form-control" required>
                <label>Subject</label>
                <select name="Subject" id="Subject">
                    <c:forEach var="a" items="${listSub}">
                        <option value="${a.getSubjectID()}">${a.getSubjectName()}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-lg-12 m-b30">
                <button type="submit" class="btn button-md" name="submit">Send</button>
            </div>
        </div>

    </body>
</html>
