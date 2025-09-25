<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - Education Hub</title>
    <link rel="stylesheet" href="../common/bootstrap.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(-45deg, #a1c4fd, #c2e9fb, #f8fafc, #e0e7ff);
            background-size: 400% 400%;
            animation: gradientBG 12s ease infinite;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        @keyframes gradientBG {
            0% {background-position: 0% 50%;}
            50% {background-position: 100% 50%;}
            100% {background-position: 0% 50%;}
        }
        .brand {
            text-align: center;
            margin-bottom: 25px;
        }
        .brand img {
            width: 60px;
            margin-bottom: 8px;
        }
        .brand-title {
            font-size: 1.5rem;
            font-weight: 800;
            color: #2563eb;
            letter-spacing: 1px;
        }
        .brand-subtitle {
            font-size: 1rem;
            color: #64748b;
        }
        .login-container {
            width: 440px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.1);
            padding: 25px;
            overflow: hidden;
        }

        /* Top tab buttons */
        .tab-buttons-inside {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 20px;
        }
        .tab-buttons-inside button {
            padding: 12px 32px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            background: #e5e7eb;
            font-weight: 700;
            font-size: 1.05rem;
            transition: 0.3s;
        }
        .tab-buttons-inside button.active {
            background: #2563eb;
            color: #fff;
            transform: scale(1.05);
        }

        /* Sliding content */
        .tab-content {
            position: relative;
            overflow: hidden;
            min-height: 280px;
        }
        .tab-pane {
            position: absolute;
            top: 0;
            left: 100%;
            width: 100%;
            opacity: 0;
            transition: all 0.5s ease;
        }
        .tab-pane.active {
            left: 0;
            opacity: 1;
        }
        .tab-pane.slide-out-left {
            left: -100%;
            opacity: 0;
        }
        .tab-pane.slide-in-right {
            left: 0;
            opacity: 1;
        }
        .tab-pane.slide-out-right {
            left: 100%;
            opacity: 0;
        }
        .tab-pane.slide-in-left {
            left: 0;
            opacity: 1;
        }

        /* Form styles */
        .login-title {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .login-title.student { color: #2563eb; }
        .login-title.teacher { color: #059669; }

        .form-control {
            width: 100%;
            padding: 10px;
            margin-bottom: 12px;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
        }

        .btn-student, .btn-teacher {
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            margin-top: 8px;
            font-size: 1rem;
        }
        .btn-student { background:#2563eb; color:#fff; }
        .btn-student:hover { background:#1e40af; }
        .btn-teacher { background:#059669; color:#fff; }
        .btn-teacher:hover { background:#047857; }

        .signup-link {
            display: block;
            margin-top: 10px;
            font-size: 0.95rem;
            color: #334155;
        }
        .signup-link:hover { color: #2563eb; text-decoration: underline; }

        .alert-danger {
            margin-bottom: 12px;
            font-size: 0.95rem;
            border-radius: 6px;
            border: 1px solid #ef4444;
            background: #fee2e2;
            color: #b91c1c;
            padding: 8px 12px;
            position: relative;
        }
        .alert-danger .close {
            position: absolute;
            right: 10px;
            top: 5px;
            border: none;
            background: none;
            cursor: pointer;
            font-size: 1rem;
            color: #b91c1c;
        }

        footer {
            margin-top: 30px;
            color:#64748b;
            font-size:0.9rem;
        }
    </style>
</head>
<body>
<%
String errorMessage = request.getParameter("error");
if (errorMessage == null) {
    errorMessage = (String) request.getAttribute("errorMessage");
}
String successMessage = request.getParameter("success");
%>

<!-- Branding outside the box -->
<div class="brand">
    <img src="../public/vite.svg" alt="Education Hub">
    <div class="brand-title">Education Hub</div>
    <div class="brand-subtitle">Empowering <b>Education</b> for All</div>
</div>

<!-- Login box -->
<div class="login-container">
    <!-- Tabs -->
    <div class="tab-buttons-inside">
        <button id="student-btn" class="active" onclick="showTab('student')">
            <i class="fa-solid fa-user-graduate"></i> Student
        </button>
        <button id="teacher-btn" onclick="showTab('teacher')">
            <i class="fa-solid fa-chalkboard-user"></i> Teacher
        </button>
    </div>

    <!-- Tab content -->
    <div class="tab-content">
        <!-- Student Login -->
        <div id="student-login" class="tab-pane active">
            <div class="login-title student"><i class="fa-solid fa-user-graduate"></i> Student Login</div>
            <% if (successMessage != null) { %>
                <div style="margin-bottom:12px; font-size:0.97rem; border-radius:6px; border:1px solid #22c55e; background:#dcfce7; color:#166534; padding:8px 12px; position:relative;">
                    <%= successMessage %>
                    <button class="close" onclick="this.parentElement.style.display='none'" style="position:absolute;right:10px;top:5px;border:none;background:none;cursor:pointer;font-size:1rem;color:#166534;">&times;</button>
                </div>
            <% } %>
            <% if (errorMessage != null) { %>
                <div class="alert-danger"> 
                    <%= errorMessage %> 
                    <button class="close" onclick="this.parentElement.style.display='none'">&times;</button>
                </div>
            <% } %>
            <form action="<%= request.getContextPath() %>/studentloginServlet" method="post">
                <input type="text" class="form-control" name="username" placeholder="Enter your student ID or email" required>
                <input type="password" class="form-control" id="student-password" name="passwordHash" placeholder="Enter your password" required>
                <button type="submit" class="btn-student">Login as Student</button>
                <a href="<%= request.getContextPath() %>/views/studentSignup.jsp" class="signup-link">Don't have an account? <b>Sign up as Student</b></a>
            </form>
        </div>

        <!-- Teacher Login -->
        <div id="teacher-login" class="tab-pane">
            <div class="login-title teacher"><i class="fa-solid fa-chalkboard-user"></i> Teacher Login</div>
            <% if (errorMessage != null) { %>
                <div class="alert-danger"> 
                    <%= errorMessage %> 
                    <button class="close" onclick="this.parentElement.style.display='none'">&times;</button>
                </div>
            <% } %>
            <form action="<%= request.getContextPath() %>/teacherloginServlet" method="post">
                <input type="text" class="form-control" name="username" placeholder="Enter your teacher ID or email" required>
                <input type="password" class="form-control" id="teacher-password" name="passwordHash" placeholder="Enter your password" required>
                <button type="submit" class="btn-teacher">Login as Teacher</button>
                <a href="<%= request.getContextPath() %>/views/teacherSignup.jsp" class="signup-link">Don't have an account? <b>Sign up as Teacher</b></a>
            </form>
        </div>
    </div>
</div>

<footer>
    &copy; 2025 Education Hub. All rights reserved.
</footer>

<script>
    let activeTab = "student";

    function showTab(tab) {
        if (tab === activeTab) return; // no double click animation

        // Buttons
        document.getElementById("student-btn").classList.remove("active");
        document.getElementById("teacher-btn").classList.remove("active");
        document.getElementById(tab + "-btn").classList.add("active");

        // Panes
        const currentPane = document.getElementById(activeTab + "-login");
        const newPane = document.getElementById(tab + "-login");

        // Decide slide direction
        if (tab === "teacher") {
            currentPane.classList.add("slide-out-left");
            newPane.classList.add("slide-in-right");
        } else {
            currentPane.classList.add("slide-out-right");
            newPane.classList.add("slide-in-left");
        }

        newPane.classList.add("active");

        // Cleanup after animation
        setTimeout(() => {
            currentPane.className = "tab-pane"; // reset classes
            newPane.className = "tab-pane active";
        }, 500);

        activeTab = tab;
    }
</script>
</body>
</html>
