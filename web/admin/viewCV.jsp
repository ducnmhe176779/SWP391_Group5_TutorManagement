<%-- 
    Document   : viewCV
    Created on : Mar 7, 2025, 10:41:14 AM
    Author     : dvdung
--%>

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
        ResultSet cv = (ResultSet)request.getAttribute("cv");
        cv.next();
    %>
    <body>
        <div class="container">
            <div class="avatar">
                <img src="<%=cv.getString("Avatar")%>" alt="">
            </div>
            <div class="name">
                <h1><%=cv.getString("FullName")%></h1>
                <div class="specialize"><%=cv.getString("SubjectName")%></div>
                <ul class="contact">
                    <li>
                        <span>P</span> <%=cv.getString("Phone")%>
                    </li>
                    <li>
                        <span>E</span> <%=cv.getString("Email")%>
                    </li>
                </ul>
            </div>
            <div class="info">
                <ul>
                    <li><%=cv.getString("Address")%></li>
                    <li><%=cv.getDate("Dob")%></li>
                </ul>
            </div>
            <div class="intro">
                <h2>INTRODUCE MYSELT</h2>
                <%=cv.getString("Desciption")%>
                <h2>Education</h2>
                <%=cv.getString("Education")%>
            </div>
            <div class="experience">
                <h2>EXPERIENCE</h2>
                <div class="item">
                    <%=cv.getString("Experience")%>
                </div>
            </div>
        </div>

    </body>
</html>
