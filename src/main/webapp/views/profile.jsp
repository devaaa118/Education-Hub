<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.edu.model.User" %>
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
        .profile-header { display: flex; align-items: center; gap: 18px; margin-bottom: 32px; }
        .profile-header i { font-size: 2.2rem; color: #2563eb; }
        .profile-title { font-size: 2rem; font-weight: 800; color: #2563eb; }
        .profile-info { font-size: 1.1rem; color: #334155; }
        .profile-label { font-weight: 600; color: #64748b; }
        .btn-back { margin-top: 32px; }
    </style>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
%>
<div class="profile-container">
    <div class="profile-header">
        <i class="fa-solid fa-user-circle"></i>
        <div class="profile-title">My Profile</div>
    </div>
    <div class="profile-info">
        <p><span class="profile-label">Full Name:</span> <%= user != null ? user.getName() : "-" %></p>
        <p><span class="profile-label">Username:</span> <%= user != null ? user.getUsername() : "-" %></p>
        <p><span class="profile-label">Email:</span> <%= user != null ? user.getEmail() : "-" %></p>
        <p><span class="profile-label">Role:</span> <%= user != null ? user.getRole() : "-" %></p>
        <p><span class="profile-label">Member Since:</span> 
            <%= user != null && user.getCreatedAt() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(user.getCreatedAt()) : "-" %>
        </p>
    </div>
    <a href="<%= request.getContextPath() %>/views/studentDashboard.jsp" class="btn btn-link btn-back">Back to Dashboard</a>
</div>
</body>
</html>
