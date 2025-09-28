<%-- File: src/main/webapp/views/teacherLibraryClasses.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Resource Library · Classes</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background: #f8fafc; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-header h2 { margin: 0; font-weight: 700; color: #1e293b; }
        .list-group-item { border-radius: 12px !important; margin-bottom: 12px; border: 1px solid #e2e8f0; }
        .list-group-item:hover { border-color: #2563eb; box-shadow: 0 10px 20px rgba(37, 99, 235, 0.12); }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<div class="container py-4">
    <div class="page-header">
        <div>
            <h2>Select a Class</h2>
            <p class="text-muted mb-0">Choose a class to view its subjects and resources.</p>
        </div>
        <c:url var="dashboardUrl" value="/teacherDashboard" />
        <a href="${dashboardUrl}" class="btn btn-outline-primary"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-${messageType}">${message}</div>
    </c:if>

    <div class="list-group">
        <c:forEach var="classInfo" items="${classOptions}">
            <c:url var="classLink" value="/teacher/library">
                <c:param name="grade" value="${classInfo.id}" />
            </c:url>
            <a href="${classLink}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                <span class="fw-semibold">${classInfo.name}</span>
                <span class="badge bg-primary rounded-pill">${fn:length(subjectsByClass[classInfo.id])} subjects</span>
            </a>
        </c:forEach>
    </div>
</div>
</body>
</html>
