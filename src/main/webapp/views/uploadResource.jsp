<%-- File: src/main/webapp/views/uploadResource.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Educational Resource</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <style>
        .container {
            max-width: 800px;
            margin-top: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="mb-4">Upload Educational Resource</h2>
        
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType}" role="alert">
                ${message}
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/upload-resource" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="title">Title:</label>
                <input type="text" class="form-control" id="title" name="title" required>
            </div>
            
            <div class="form-group">
                <label for="grade">Grade:</label>
                <select class="form-control" id="grade" name="grade" required>
                    <option value="">Select Grade</option>
                    <option value="1">Grade 1</option>
                    <option value="2">Grade 2</option>
                    <option value="3">Grade 3</option>
                    <option value="4">Grade 4</option>
                    <option value="5">Grade 5</option>
                    <option value="6">Grade 6</option>
                    <option value="7">Grade 7</option>
                    <option value="8">Grade 8</option>
                    <option value="9">Grade 9</option>
                    <option value="10">Grade 10</option>
                    <option value="11">Grade 11</option>
                    <option value="12">Grade 12</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="subject">Subject:</label>
                <select class="form-control" id="subject" name="subject" required>
                    <option value="">Select Subject</option>
                    <option value="Mathematics">Mathematics</option>
                    <option value="Science">Science</option>
                    <option value="English">English</option>
                    <option value="Tamil">Tamil</option>
                    <option value="Social Studies">Social Studies</option>
                    <option value="Computer Science">Computer Science</option>
                    <option value="Physics">Physics</option>
                    <option value="Chemistry">Chemistry</option>
                    <option value="Biology">Biology</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="type">Resource Type:</label>
                <select class="form-control" id="type" name="type" required>
                    <option value="">Select Type</option>
                    <option value="PDF">PDF</option>
                    <option value="Video">Video</option>
                    <option value="Quiz">Quiz</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="language">Language:</label>
                <select class="form-control" id="language" name="language" required>
                    <option value="">Select Language</option>
                    <option value="English">English</option>
                    <option value="Tamil">Tamil</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="resourceFile">Upload File:</label>
                <input type="file" class="form-control-file" id="resourceFile" name="resourceFile" required>
                <small class="form-text text-muted">
                    Supported formats: PDF, MP4, DOCX (Max size: 50MB)
                </small>
            </div>
            
            <button type="submit" class="btn btn-primary">Upload Resource</button>
            <a href="${pageContext.request.contextPath}/views/teacherDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </form>
    </div>
</body>
</html>
