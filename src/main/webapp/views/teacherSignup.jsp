<html> 
<body>
<form action="${pageContext.request.contextPath}/teachersignup" method="post">
    <input type="text" name="username" placeholder="Username">
    <input type="text" name="name" placeholder="Full Name">
    <input type="email" name="email" placeholder="Email">
    <input type="password" name="passwordHash" placeholder="Password">
    <input type="hidden" name="role" value="teacher">
    <input type="submit" value="Sign Up">
</form>

<% 
    String msg = request.getParameter("msg");
    if (msg != null) { 
%>
    <p style="color:green;font-weight:bold;"><%= msg %></p>
<% 
    } 
%>



</body>
</html>

