<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Test Tutor Detail</title>
</head>
<body>
    <h1>Test Tutor Detail Servlet</h1>
    
    <p>Click the link below to test the TutorDetailController:</p>
    
    <a href="Tutordetail?tutorID=1">Test Tutor Detail with ID 1</a>
    
    <br><br>
    
    <p>Or test with different tutor IDs:</p>
    
    <a href="Tutordetail?tutorID=2">Test Tutor Detail with ID 2</a>
    <br>
    <a href="Tutordetail?tutorID=3">Test Tutor Detail with ID 3</a>
    
    <br><br>
    
    <p>Test error handling:</p>
    
    <a href="Tutordetail">Test without tutorID (should show error)</a>
    <br>
    <a href="Tutordetail?tutorID=abc">Test with invalid tutorID (should show error)</a>
    
    <br><br>
    
    <a href="home">Back to Home</a>
</body>
</html>
