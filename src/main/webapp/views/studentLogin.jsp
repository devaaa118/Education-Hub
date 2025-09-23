<html>
<head>
<title>
    Student Signup
    </title>
    <head>
<body>
<div class ="form">
<form action="<%= request.getContextPath() %>/studentloginServlet" method="post">
    <input type="text" name="username" placeholder="Username">
    <input type="password" name="passwordHash" placeholder="Password">
    <input type="submit" value="Login">
</form>

</div>
</body>
</html>