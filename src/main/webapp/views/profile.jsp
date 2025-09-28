<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.edu.model.User" %>
<%@ include file="studentDashboardHeader.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - Education Hub</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background: linear-gradient(120deg, #f8fafc 0%, #e0e7ff 100%); min-height: 100vh; }
        .profile-container { max-width: 600px; margin: 48px auto; background: #fff; border-radius: 16px; box-shadow: 0 6px 32px rgba(30,64,175,0.10); padding: 40px 32px; }
        .profile-info { font-size: 1.15rem; color: #334155; line-height: 2.1; }
        .profile-label { font-weight: 700; color: #2563eb; }
        .btn-back { margin-top: 32px; font-weight: 600; color: #2563eb; font-size: 1.08rem; }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<%
    User user = (User) session.getAttribute("user");
%>
<div class="profile-container" style="margin-top:0;">
    <div class="welcome-box" style="background:#e0e7ff;border-radius:10px;padding:28px 24px;margin-bottom:24px;font-size:1.15rem;color:#334155;box-shadow:0 2px 8px rgba(37,99,235,0.07);display:flex;align-items:center;gap:18px;">
        <i class="fa-solid fa-user-circle" style="font-size:2.2rem;color:#2563eb;"></i>
        <div>
            <div style="font-size:2rem;font-weight:800;color:#2563eb;">My Profile</div>
            <div class="profile-info" style="font-size:1.15rem;color:#334155;line-height:2.1;">
                <p><span class="profile-label" style="font-weight:700;color:#2563eb;">Full Name:</span> <span style="color:#222;font-weight:500;"> <%= user != null ? user.getName() : "-" %></span></p>
                <p><span class="profile-label" style="font-weight:700;color:#2563eb;">Username:</span> <span style="color:#222;font-weight:500;"> <%= user != null ? user.getUsername() : "-" %></span></p>
                <p><span class="profile-label" style="font-weight:700;color:#2563eb;">Email:</span> <span style="color:#222;font-weight:500;"> <%= user != null ? user.getEmail() : "-" %></span></p>
                <p><span class="profile-label" style="font-weight:700;color:#2563eb;">Role:</span> <span style="color:#222;font-weight:500;"> <%= user != null ? user.getRole() : "-" %></span></p>
                <p><span class="profile-label" style="font-weight:700;color:#2563eb;">Member Since:</span> <span style="color:#222;font-weight:500;"> <%= user != null && user.getCreatedAt() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(user.getCreatedAt()) : "-" %></span></p>
            </div>
        </div>
    </div>
    <a href="<%= request.getContextPath() %>/studentDashboard" class="btn btn-link btn-back" style="margin-top:32px;font-weight:600;color:#2563eb;font-size:1.08rem;">Back to Dashboard</a>
</div>
</body>
</html>
