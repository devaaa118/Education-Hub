<html>
<head>
    <title> Student Signup </title>
</head>
<body>
    <form action = "<%= request.getContextPath()%>/studentsignupServlet" method ="post">
        <label for="username"> Username </label>
        <input type = "text" name = "username" required minlength ="6" maxlength="30">

        <label for="fullname"> Full Name </label>
        <input type = "text" name = "fullname" required>

        <label for="grade"> Grade </label>
        <select name="grade" id="grade">
            <option value ="1">I</class>
            <option value ="2">II</class>
            <option value ="3">III</class>
            <option value ="4">IV</class>
            <option value ="5">V</class>
            <option value ="6">VI</class>
            <option value ="7">VII</class>
            <option value ="8">VIII</class>
            <option value ="9">IX</class>
            <option value ="10">X</class>
            <option value ="11">XI</class>
            <option value ="12">XII</class>
            </select>

        <label for="email"> E-Mail </label>
        <input type = "email" name = "email" required>
      
        <label for="password_hash">Enter Password </label>
        <input type = "password" name = "password_hash" required minlength="8">

        <label for="confirmpassword"> Confirm Password </label>
        <input type = "password" name = "confirmpassword" required>
        
           <input type="hidden" name="role" value="student">

        <input type = "submit"  value = "Student signup">

        </form>
        <body>
        </html>