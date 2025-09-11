<html>
<body>
<h1> hello </h1>
<form action="<%= request.getContextPath() %>/teacherLogin" method="post">
    <input type="text" name="username" placeholder="Username">
    <input type="password" name="passwordHash" placeholder="Password">
    <input type="submit" value="Login">
</form>

<% 
    String msg = (String) request.getAttribute("msg");
    if (msg != null) { 
%>

    <p style="color:<%= msg.contains("Invalid") ? "red" : "green" %>; font-weight:bold;">
        <%= msg %>
    </p>
<% 
    } 
%>
<h3>end</h3>
</body>
</html>