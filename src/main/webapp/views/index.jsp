<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Education Hub - Home</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background: linear-gradient(120deg, #f8fafc 0%, #e0e7ff 100%); min-height: 100vh; }
        .dashboard-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px; }
        .dashboard-title { font-size: 2.1rem; font-weight: 900; color: #2563eb; display: flex; align-items: center; gap: 14px; }
        .dashboard-nav { display: flex; gap: 18px; }
        .dashboard-nav a { color: #2563eb; font-weight: 600; text-decoration: none; padding: 8px 18px; border-radius: 6px; transition: background 0.15s; }
        .dashboard-nav a:hover { background: #e0e7ff; }
        .home-content { max-width: 900px; margin: 60px auto 0 auto; background: #fff; border-radius: 18px; box-shadow: 0 6px 32px rgba(30,64,175,0.10); padding: 48px 36px; }
    </style>
</head>
<body>
    <jsp:include page="../common/googleTranslateWidget.jspf" />
    <div class="home-content">
        <div class="dashboard-header">
            <div class="dashboard-title">
                <i class="fa-solid fa-graduation-cap"></i> Education Hub
            </div>
            <nav class="dashboard-nav">
                <a href="index.jsp" title="Home"><i class="fa fa-home"></i> Home</a>
                <a href="views/commonLogin.jsp" title="Login"><i class="fa fa-sign-in-alt"></i> Login</a>
                <a href="views/studentSignup.jsp" title="Student Signup"><i class="fa fa-user-plus"></i> Student Signup</a>
                <a href="views/teacherSignup.jsp" title="Teacher Signup"><i class="fa fa-chalkboard-teacher"></i> Teacher Signup</a>
            </nav>
        </div>
        <div style="margin-top: 32px; text-align: center;">
            <h2 style="font-size:2.2rem; color:#2563eb; font-weight:900;">Welcome to Education Hub</h2>
            <p style="font-size:1.15rem; color:#334155; margin-top:18px;">Empowering <b>Education</b> for All.<br>Access resources, assignments, and manage your learning journey with ease.</p>
        </div>
    </div>
</body>
</html>
