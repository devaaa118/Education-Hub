
<html>
     <head>
        <%@ include file="/common/bootstrap.jsp" %>

<title>login form</title>
    </head>
    <body>
    <div class = "input-group">

        <form action="${pageContext.request.contextPath}/loginServlet" method="post">
            Username : <input type = "text" name="Username"> <br>
            Password : <input type = "text" name = "Password">
            <input  type="submit" value="Login" > 
        </form> </div>
    </body>
</html> 