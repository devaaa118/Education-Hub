<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Signup - Education Hub</title>
    <link rel="stylesheet" href="../common/bootstrap.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(120deg, #f8fafc 0%, #d1fae5 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .signup-container {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 40px rgba(16,185,129,0.13), 0 1.5px 8px rgba(0,0,0,0.04);
            padding: 44px 36px 36px 36px;
            max-width: 420px;
            width: 100%;
        }
        .signup-title {
            font-size: 2rem;
            font-weight: 900;
            color: #059669;
            text-align: center;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            justify-content: center;
        }
        .form-label {
            font-weight: 600;
            color: #334155;
        }
        .form-control {
            border-radius: 7px;
            border: 1.5px solid #cbd5e1;
            margin-bottom: 16px;
            font-size: 1.08rem;
            padding: 10px 12px;
        }
        .btn-signup {
            background: #059669;
            color: #fff;
            font-weight: 700;
            border-radius: 7px;
            font-size: 1.13rem;
            width: 100%;
            padding: 12px 0;
            margin-top: 8px;
            box-shadow: 0 2px 8px rgba(16,185,129,0.10);
            transition: background 0.18s, box-shadow 0.18s;
        }
        .btn-signup:hover {
            background: #047857;
            box-shadow: 0 4px 16px rgba(16,185,129,0.18);
        }
        .back-link {
            display: block;
            margin-top: 18px;
            text-align: center;
            color: #64748b;
            font-size: 1.01rem;
            text-decoration: none;
        }
        .back-link:hover {
            color: #059669;
            text-decoration: underline;
        }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<div class="signup-container">
    <div class="signup-title"><i class="fa-solid fa-chalkboard-user"></i> Teacher Signup</div>
    <form action="<%= request.getContextPath() %>/teachersignupServlet" method="post" style="display: flex; flex-direction: column; gap: 0.5rem;">
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="username" class="form-label">Username</label>
            <input type="text" class="form-control" name="username" required minlength="6" maxlength="30" placeholder="Choose a username">
        </div>
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="fullname" class="form-label">Full Name</label>
            <input type="text" class="form-control" name="fullname" required placeholder="Your full name">
        </div>
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="email" class="form-label">E-Mail</label>
            <input type="email" class="form-control" name="email" required placeholder="Enter your email">
        </div>
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="password_hash" class="form-label">Password</label>
            <input type="password" class="form-control" name="password_hash" required minlength="8" placeholder="Create a password">
        </div>
        <div style="display: flex; flex-direction: column; gap: 0.2rem;">
            <label for="confirmpassword" class="form-label">Confirm Password</label>
            <input type="password" class="form-control" name="confirmpassword" required placeholder="Re-enter your password">
        </div>
        <input type="hidden" name="role" value="teacher">
        <button type="submit" class="btn-signup">Sign Up as Teacher</button>
    </form>
    <a href="<%= request.getContextPath() %>/views/commonLogin.jsp" class="back-link"><i class="fa fa-arrow-left"></i> Back to Login</a>
</div>
</body>
</html>

