<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.edu.model.User" %>
<%

    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("teacherLogin.jsp?msg=please login first!");
        return;
    }
%>
<! DOCTYPE html>
<html>
<head>
    <title>Teacher Dashboard</title>
    <link rel="stylesheet" href="../common/bootstrap.jsp">
    <style>
        body{
            background-color: #f4f6f9;
        }
        .dashboard{
            margin : 50px auto;
            width: 70%;
        }
        .card {
            padding : 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container dashboard">
        <h2>welcome,<%= user.getName() %> </h2>
        <p>Role: <%= user.getRole() %></p>
        <hr>

        <div class ="card">
            <h4> resource Management</h4>
            <ul>
                <li><a href="uploadResource.jsp">upload New Resource</a></li>
                <li><a href="viewResources.jsp">view calender</a></li>
            </ul>
        </div>

        <div class="card">
            <h4>Account</h4>
            <ul>
                <li><a href="updateProfile.jsp">update profiles</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </div>
</body>
</html>