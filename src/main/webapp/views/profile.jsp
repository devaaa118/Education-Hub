<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.edu.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - Education Hub</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <jsp:include page="../common/i18n-scripts.jspf" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e0e7ff 100%);
            min-height: 100vh;
        }
        .profile-card {
            border: none;
            border-radius: 1.5rem;
            box-shadow: 0 1.75rem 3.5rem rgba(30, 64, 175, 0.12);
        }
        .profile-card .card-title {
            font-size: 2rem;
            font-weight: 800;
            color: #1d4ed8;
        }
        .profile-label {
            color: #1e40af;
            font-weight: 700;
        }
    </style>
</head>
<body class="bg-light">
<div style="display:none"><jsp:include page="../common/googleTranslateWidget.jspf" /></div>
<%
    User user = (User) session.getAttribute("user");
%>
<div class="container py-5">
    <jsp:include page="studentDashboardHeader.jsp" />

    <div class="row justify-content-center">
        <div class="col-12 col-lg-8">
            <div class="card profile-card p-4 p-lg-5">
                <div class="d-flex align-items-center gap-3 mb-4">
                    <span class="display-4 text-primary"><i class="fa-solid fa-user-circle"></i></span>
                    <div>
                        <h1 class="card-title mb-0" data-i18n="profile.title">My profile</h1>
                        <p class="text-muted mb-0" data-i18n="profile.subtitle">Your personal details at a glance.</p>
                    </div>
                </div>
                <dl class="row g-3">
                    <dt class="col-sm-4 profile-label" data-i18n="profile.fullName">Full name</dt>
                    <dd class="col-sm-8 fw-semibold"><%= user != null ? user.getName() : "-" %></dd>

                    <dt class="col-sm-4 profile-label" data-i18n="profile.username">Username</dt>
                    <dd class="col-sm-8 fw-semibold"><%= user != null ? user.getUsername() : "-" %></dd>

                    <dt class="col-sm-4 profile-label" data-i18n="profile.email">Email</dt>
                    <dd class="col-sm-8 fw-semibold"><%= user != null ? user.getEmail() : "-" %></dd>

                    <dt class="col-sm-4 profile-label" data-i18n="profile.role">Role</dt>
                    <dd class="col-sm-8 fw-semibold text-capitalize"><%= user != null ? user.getRole() : "-" %></dd>

                    <dt class="col-sm-4 profile-label" data-i18n="profile.memberSince">Member since</dt>
                    <dd class="col-sm-8 fw-semibold">
                        <%= user != null && user.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd MMM yyyy").format(user.getCreatedAt()) : "-" %>
                    </dd>
                </dl>
                <div class="d-flex justify-content-end gap-3 mt-4">
                    <a href="<%= request.getContextPath() %>/studentDashboard" class="btn btn-outline-primary" data-i18n="profile.back"><i class="fa-solid fa-arrow-left me-2"></i>Back to dashboard</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
