<%-- File: src/main/webapp/views/editResource.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Resource</title>
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
    <jsp:include page="../common/googleTranslateWidget.jspf" />
        <h2 class="mb-4">Edit Resource</h2>

        <c:if test="${not empty message}">
            <div class="alert alert-${messageType}" role="alert">
                ${message}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/edit-resource" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${resource.id}">

            <div class="form-group">
                <label for="title">Title:</label>
                <input type="text" class="form-control" id="title" name="title" value="${resource.title}" required>
            </div>

            <div class="form-group">
                <label for="grade">Grade:</label>
                <select class="form-control" id="grade" name="grade" required>
                    <option value="">Select Grade</option>
                    <c:forEach begin="1" end="12" var="grade">
                        <c:set var="gradeValue" value="${grade + ''}" />
                        <option value="${gradeValue}" ${resource.grade eq gradeValue ? 'selected' : ''}>Grade ${grade}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="subject">Subject:</label>
                <select class="form-control" id="subject" name="subject" required>
                    <c:set var="subjects" value="${['Mathematics','Science','English','Tamil','Social Studies','Computer Science','Physics','Chemistry','Biology']}" />
                    <option value="">Select Subject</option>
                    <c:forEach var="subject" items="${subjects}">
                        <option value="${subject}" ${resource.subject eq subject ? 'selected' : ''}>${subject}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="type">Resource Type:</label>
                <select class="form-control" id="type" name="type" required>
                    <option value="">Select Type</option>
                    <option value="PDF" ${resource.type eq 'PDF' ? 'selected' : ''}>PDF</option>
                    <option value="Video" ${resource.type eq 'Video' ? 'selected' : ''}>Video</option>
                    <option value="Quiz" ${resource.type eq 'Quiz' ? 'selected' : ''}>Quiz</option>
                </select>
            </div>

            <div class="form-group">
                <label for="language">Language:</label>
                <select class="form-control" id="language" name="language" required>
                    <option value="">Select Language</option>
                    <option value="English" ${resource.language eq 'English' ? 'selected' : ''}>English</option>
                    <option value="Tamil" ${resource.language eq 'Tamil' ? 'selected' : ''}>Tamil</option>
                </select>
            </div>

            <div class="form-group">
                <label>Current File:</label>
                <p>
                    <a href="${pageContext.request.contextPath}/${resource.fileLink}" target="_blank">${resource.fileLink}</a>
                </p>
            </div>

            <div class="form-group">
                <label for="resourceFile">Upload New File (optional):</label>
                <input type="file" class="form-control-file" id="resourceFile" name="resourceFile">
                <small class="form-text text-muted">
                    Leave empty to keep the existing file. Supported formats: PDF, MP4, DOCX (Max size: 50MB)
                </small>
            </div>

            <button type="submit" class="btn btn-primary">Save Changes</button>
            <a href="${pageContext.request.contextPath}/my-resources" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>
