<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="studentDashboardHeader.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Resources</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        .container { max-width: 900px; margin-top: 0; }
        .resource-card { margin-bottom: 24px; }
        .resource-title { font-size: 1.2rem; font-weight: 700; color: #2563eb; }
        .resource-meta { color: #64748b; font-size: 0.98rem; }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<div class="container" style="margin-top:0;">
    <div class="welcome-box" style="background:#e0e7ff;border-radius:10px;padding:28px 24px;margin-bottom:24px;font-size:1.15rem;color:#334155;box-shadow:0 2px 8px rgba(37,99,235,0.07);">
        <b>Available Resources</b>
    </div>

    <!-- Subjects as clickable boxes -->
    <div class="mb-4">
        <h5>Subjects</h5>
        <div class="row g-3">
            <c:forEach var="subject" items="${subjects}">
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/studentSubjectResources?subject=${subject}&from=resources" class="subject-card h-100">
                        <div class="card-body d-flex flex-column justify-content-center align-items-center" style="min-height: 80px;">
                            <span style="font-size:2rem; color:#2563eb; margin-bottom:8px;"><i class="fa-solid fa-book-open"></i></span>
                            <span style="font-size:1.08rem; font-weight:700; color:#2563eb;">${subject}</span>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
        <style>
            .subject-card {
                display: block;
                border-radius: 16px;
                box-shadow: 0 4px 18px rgba(37,99,235,0.10);
                border: none;
                background: linear-gradient(120deg, #f1f5ff 0%, #e0e7ff 100%);
                text-decoration: none !important;
                transition: box-shadow 0.2s, transform 0.18s, background 0.18s;
                margin-bottom: 0;
            }
            .subject-card:hover {
                box-shadow: 0 8px 32px rgba(37,99,235,0.18);
                transform: translateY(-2px) scale(1.03);
                background: linear-gradient(120deg, #e0e7ff 0%, #f8fafc 100%);
            }
            .subject-card span {
                text-decoration: none !important;
            }
        </style>
    </div>

    <!-- ...existing filter form and resource listing code... -->
    <form method="get" action="${pageContext.request.contextPath}/resources" class="mb-4" id="resourceFilterForm">
        <!-- ...existing code... -->
    </form>
    <script>
    // ...existing code...
    </script>
    <!-- ...existing resource listing code... -->
    <c:choose>
        <c:when test="${empty groupedResources}">
            <div class="alert alert-info">No resources available for your class at this time.</div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="subjectEntry" items="${groupedResources}">
                    <div class="col-12 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h4 class="mb-0">${subjectEntry.key}</h4>
                        </div>
                        <div class="row">
                            <c:forEach var="resource" items="${subjectEntry.value}" begin="0" end="2">
                                <div class="col-md-6">
                                    <div class="card resource-card">
                                        <div class="card-body">
                                            <div class="resource-title">${resource.title}</div>
                                            <div class="resource-meta">
                                                Grade: ${resource.grade} | Type: ${resource.type} | Language: ${resource.language}
                                            </div>
                                            <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="btn btn-primary btn-sm mt-3">View Resource</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
    <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-link mt-4">Back to Dashboard</a>
</div>
</body>
</html>
