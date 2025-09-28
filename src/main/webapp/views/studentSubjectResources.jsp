<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="studentDashboardHeader.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${subject} Resources</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <style>
        body { background: #f8fafc; }
        .container { max-width: 950px; margin-top: 40px; }
        .subject-header { margin-bottom: 24px; }
        .subject-title { font-size: 2rem; font-weight: 800; color: #1d4ed8; }
        .resource-card { margin-bottom: 20px; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.08); }
        .resource-card .card-title { font-weight: 700; color: #2563eb; }
        .resource-meta { color: #64748b; font-size: 0.95rem; }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<div class="container">
    <%@ include file="studentDashboardHeader.jsp" %>
    <div class="subject-header d-flex justify-content-between align-items-center">
        <div>
            <div class="subject-title">${subject}</div>
            <div class="text-muted">Resources curated for your class.</div>
        </div>
        <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-outline-primary">Back to Dashboard</a>
    </div>

    <c:choose>
        <c:when test="${empty resources}">
            <div class="alert alert-info">No resources available for this subject yet. Please check back later.</div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="resource" items="${resources}">
                    <div class="col-md-6">
                        <div class="card resource-card">
                            <div class="card-body">
                                <h5 class="card-title">${resource.title}</h5>
                                <p class="card-text resource-meta">
                                    Grade: ${resource.grade} | Type: ${resource.type} | Language: ${resource.language}
                                </p>
                                <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="btn btn-primary btn-sm">View Resource</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>