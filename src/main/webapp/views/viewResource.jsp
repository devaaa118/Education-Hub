<%-- File: src/main/webapp/views/viewResource.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${resource.title} - Resource Details</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <jsp:include page="../common/i18n-scripts.jspf" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e0e7ff 100%);
            min-height: 100vh;
        }
        .resource-card {
            border: none;
            border-radius: 1.25rem;
            box-shadow: 0 1.5rem 3rem rgba(30, 64, 175, 0.12);
        }
        .resource-card .card-title {
            font-weight: 700;
            color: #1d4ed8;
        }
        .resource-meta span {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            margin-right: 0.5rem;
        }
    </style>
</head>
<body class="bg-light">
<div style="display:none"><jsp:include page="../common/googleTranslateWidget.jspf" /></div>
<c:set var="user" value="${sessionScope.user}" />

<div class="container py-5">
    <c:if test="${user != null && user.role eq 'student'}">
        <jsp:include page="studentDashboardHeader.jsp" />
    </c:if>
    <c:if test="${user != null && user.role ne 'student'}">
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/teacherDashboard" class="btn btn-outline-primary"><i class="fa-solid fa-arrow-left me-2"></i>Back to dashboard</a>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${fn:startsWith(resource.fileLink, 'http://') || fn:startsWith(resource.fileLink, 'https://')}">
            <c:set var="resourceLink" value="${resource.fileLink}" />
            <c:set var="externalResource" value="${true}" />
        </c:when>
        <c:otherwise>
            <c:set var="resourceLink" value="${pageContext.request.contextPath}/${resource.fileLink}" />
            <c:set var="externalResource" value="${false}" />
        </c:otherwise>
    </c:choose>

    <div class="card resource-card p-4 p-lg-5">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3 mb-4">
            <div>
                <h1 class="card-title mb-1">${resource.title}</h1>
                <p class="text-muted mb-0" data-i18n="viewResource.subtitle">Detailed view of the selected resource.</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <span class="badge bg-primary-subtle text-primary-emphasis"><i class="fa-solid fa-graduation-cap me-1"></i>Grade ${resource.grade}</span>
                <span class="badge bg-secondary-subtle text-secondary-emphasis"><i class="fa-solid fa-book-open me-1"></i>${resource.subject}</span>
                <span class="badge bg-info-subtle text-info-emphasis"><i class="fa-solid fa-layer-group me-1"></i>${resource.type}</span>
                <span class="badge bg-light text-secondary border"><i class="fa-solid fa-language me-1"></i>${resource.language}</span>
            </div>
        </div>

        <div class="mb-4">
            <c:if test="${externalResource}">
                <div class="alert alert-info d-flex align-items-center gap-2" role="alert">
                    <i class="fa-solid fa-up-right-from-square"></i>
                    <span data-i18n="viewResource.external">This resource opens in a new tab.</span>
                </div>
            </c:if>

            <c:if test="${resource.type eq 'PDF' && user.role eq 'student' && !externalResource}">
                <div class="ratio ratio-16x9">
                    <iframe src="${resourceLink}" title="${resource.title}" allowfullscreen></iframe>
                </div>
            </c:if>

            <c:if test="${resource.type eq 'Video' && user.role eq 'student' && !externalResource}">
                <div class="ratio ratio-16x9">
                    <video controls>
                        <source src="${resourceLink}" type="video/mp4">
                        <span data-i18n="viewResource.noVideoSupport">Your browser does not support the video tag.</span>
                    </video>
                </div>
            </c:if>
        </div>

        <div class="d-flex flex-wrap gap-3">
            <a href="${pageContext.request.contextPath}/download-resource?id=${resource.id}" class="btn btn-primary">
                <i class="fa-solid fa-download me-2"></i>
                <c:choose>
                    <c:when test="${externalResource}">
                        <span data-i18n="viewResource.open">Open resource</span>
                    </c:when>
                    <c:otherwise>
                        <span data-i18n="viewResource.download">Download resource</span>
                    </c:otherwise>
                </c:choose>
            </a>

            <c:if test="${user.role eq 'teacher' && user.id eq resource.uploadedBy}">
                <a href="${pageContext.request.contextPath}/delete-resource?id=${resource.id}" class="btn btn-outline-danger" onclick="return confirm('Are you sure you want to delete this resource?');">
                    <i class="fa-solid fa-trash-can me-2"></i>
                    <span data-i18n="viewResource.delete">Delete</span>
                </a>
                <a href="${pageContext.request.contextPath}/my-resources" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-folder-open me-2"></i>
                    <span data-i18n="viewResource.backToLibrary">My resources</span>
                </a>
            </c:if>

            <c:if test="${user.role ne 'teacher'}">
                <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-outline-secondary" data-i18n="viewResource.backStudent"><i class="fa-solid fa-arrow-left me-2"></i>Back to dashboard</a>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
