<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard - Education Hub</title>
    <link rel="stylesheet" href="../common/bootstrap.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background: linear-gradient(120deg, #f8fafc 0%, #e0e7ff 100%);
            min-height: 100vh;
        }
        .dashboard-container {
            max-width: 1100px;
            margin: 40px auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 6px 32px rgba(30,64,175,0.10);
            padding: 48px 36px 36px 36px;
        }
        .dashboard-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 32px;
        }
        .dashboard-title {
            font-size: 2.1rem;
            font-weight: 900;
            color: #2563eb;
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .dashboard-nav {
            display: flex;
            gap: 18px;
        }
        .dashboard-nav a {
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
            padding: 8px 18px;
            border-radius: 6px;
            transition: background 0.15s;
        }
        .dashboard-nav a:hover {
            background: #e0e7ff;
        }
        .dashboard-content {
            margin-top: 18px;
        }
        .welcome-box {
            background: #e0e7ff;
            border-radius: 10px;
            padding: 28px 24px;
            margin-bottom: 24px;
            font-size: 1.15rem;
            color: #334155;
            box-shadow: 0 2px 8px rgba(37,99,235,0.07);
        }
        @media (max-width: 700px) {
            .dashboard-container {
                padding: 18px 4vw;
            }
            .dashboard-header {
                flex-direction: column;
                gap: 18px;
            }
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <div class="dashboard-header">
        <div class="dashboard-title">
            <i class="fa-solid fa-user-graduate"></i> Student Dashboard
        </div>
        <nav class="dashboard-nav">
            <a href="<%= request.getContextPath() %>/views/studentDashboard.jsp" title="Home"><i class="fa fa-home"></i> Home</a>
            <a href="<%= request.getContextPath() %>/resources" title="Resources"><i class="fa fa-book"></i> Resources</a>
            <a href="<%= request.getContextPath() %>/views/assignments.jsp" title="Assignments"><i class="fa fa-tasks"></i> Assignments</a>
            <a href="<%= request.getContextPath() %>/views/profile.jsp" title="Profile"><i class="fa fa-user"></i> Profile</a>
            <a href="<%= request.getContextPath() %>/logout" title="Logout"><i class="fa fa-sign-out-alt"></i> Logout</a>
        </nav>
    </div>
    <div class="dashboard-content">
        <div class="welcome-box">
            Welcome, <b><%= ((com.edu.model.User)session.getAttribute("user")) != null ? ((com.edu.model.User)session.getAttribute("user")).getName() : "Student" %></b>!<br>
            Here you can access your resources, assignments, and manage your profile.
        </div>

        <!-- Subject List and Resource Filter -->
        <div style="margin-bottom: 24px;">
            <h4>Your Subjects</h4>
            <ul>
                <c:forEach var="subject" items="${subjects}">
                    <li>
                        <a href="studentDashboard?subject=${subject}">${subject}</a>
                    </li>
                </c:forEach>
            </ul>
        </div>
        <c:if test="${not empty selectedSubject}">
            <h5>Resources for <span style="color:#2563eb;">${selectedSubject}</span></h5>
            <ul>
                <c:forEach var="resource" items="${resources}">
                    <li>
                        <a href="download-resource?id=${resource.id}">${resource.title}</a>
                    </li>
                </c:forEach>
            </ul>
        </c:if>
    </div>
</div>
</body>
</html>
