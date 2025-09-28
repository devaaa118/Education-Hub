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
        body { background: #f1f5f9; }
        .hero-card {
            background: linear-gradient(135deg, rgba(37,99,235,0.12), rgba(79,70,229,0.12));
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 2rem 4rem rgba(30,64,175,0.12);
        }
        .class-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 1.5rem 3rem rgba(15,23,42,0.08);
            transition: transform .2s ease, box-shadow .2s ease;
        }
        .class-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 2.5rem 3.5rem rgba(30,64,175,0.14);
        }
    </style>
</head>
<body>
<div style="display:none"><jsp:include page="../common/googleTranslateWidget.jspf" /></div>
<div class="container py-5">
    <div class="hero-card mb-5">
        <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-4">
            <div>
                <span class="badge text-bg-primary rounded-pill mb-2">Resource library</span>
                <h1 class="h3 fw-bold text-primary mb-2">Select a class to begin</h1>
                <p class="text-muted mb-0">Browse the curriculum map, add fresh content, and keep your students engaged.</p>
            </div>
            <div class="text-center text-lg-end">
                <span class="display-5 fw-bold text-primary">${fn:length(classOptions)}</span>
                <p class="text-muted mb-0">Classes available</p>
                <c:url var="dashboardUrl" value="/teacherDashboard" />
                <a href="${dashboardUrl}" class="btn btn-outline-primary mt-3"><i class="bi bi-arrow-left me-1"></i>Back to dashboard</a>
            </div>
        </div>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-${messageType} shadow-sm mb-4">${message}</div>
    </c:if>

    <div class="row g-4">
        <c:forEach var="classInfo" items="${classOptions}">
            <c:url var="classLink" value="/teacher/library">
                <c:param name="grade" value="${classInfo.id}" />
            </c:url>
            <div class="col-12 col-md-6 col-xl-4">
                <a href="${classLink}" class="text-decoration-none">
                    <div class="card class-card h-100">
                        <div class="card-body d-flex flex-column gap-3">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <span class="badge text-bg-light text-primary small mb-2">Class</span>
                                    <h2 class="h5 fw-semibold text-dark mb-0">${classInfo.name}</h2>
                                </div>
                                <span class="badge text-bg-primary">${fn:length(subjectsByClass[classInfo.id])} subjects</span>
                            </div>
                            <p class="text-muted mb-0">Tap to explore subjects, streams, and all uploaded materials for this class.</p>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
</div>
<jsp:include page="../common/i18n-scripts.jspf" />
</body>
</html>
