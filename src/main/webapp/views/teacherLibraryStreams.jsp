<%-- File: src/main/webapp/views/teacherLibraryStreams.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Resource Library · Streams</title>
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
            <h2>${selectedGradeName}</h2>
            <p class="text-muted mb-0">Select a stream to view its subjects.</p>
        </div>
        <div class="d-flex gap-2 flex-wrap justify-content-end">
            <c:url var="classesUrl" value="/teacher/library" />
            <a href="${classesUrl}" class="btn btn-outline-secondary"><i class="bi bi-arrow-left"></i> All Classes</a>
            <c:url var="dashboardUrl" value="/teacherDashboard" />
            <a href="${dashboardUrl}" class="btn btn-outline-primary">Dashboard</a>
        </div>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-${messageType}">${message}</div>
    </c:if>

    <c:choose>
        <c:when test="${not empty streams}">
            <div class="list-group">
                <c:forEach var="entry" items="${streams}">
                    <c:url var="streamLink" value="/teacher/library">
                        <c:param name="grade" value="${selectedGrade}" />
                        <c:param name="stream" value="${entry.key}" />
                    </c:url>
                    <a href="${streamLink}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">${entry.value}</span>
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">
                No streams are configured for this class yet.
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
