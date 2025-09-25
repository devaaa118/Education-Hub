<html>
<head>
    <title>Student Login</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <style>
        .login-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <h2 class="text-center mb-4">Student Login</h2>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/studentloginServlet" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Enter username" required>
                </div>
                <div class="form-group">
                    <label for="passwordHash">Password</label>
                    <input type="password" class="form-control" id="passwordHash" name="passwordHash" placeholder="Enter password" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Login</button>
            </form>
            
            <div class="text-center mt-3">
                <p>Don't have an account? <a href="<%= request.getContextPath() %>/views/studentSignup.jsp">Sign up</a></p>
            </div>
        </div>
    </div>
</body>
</html>
