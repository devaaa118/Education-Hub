<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
    <meta charset="UTF-8">
    <title data-i18n="resourcesPage.title" data-i18n-param-subject="${fn:escapeXml(subject)}">Resources for ${subject}</title>
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
            border-radius: 1rem;
            box-shadow: 0 1.5rem 3rem rgba(30, 64, 175, 0.08);
            height: 100%;
        }
        .resource-card .card-title {
            font-weight: 700;
            color: #1d4ed8;
        }
        .resource-card .card-text {
            color: #475569;
        }
        .progress-badge {
            border-radius: 999px;
            padding: 0.35rem 0.8rem;
            font-weight: 600;
        }
    </style>
</head>
<body class="bg-light">
<div style="display:none"><jsp:include page="../common/googleTranslateWidget.jspf" /></div>
<div class="container py-5">
    <jsp:include page="studentDashboardHeader.jsp" />

    <section class="card border-0 shadow-sm rounded-4 mb-4">
        <div class="card-body p-4">
            <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3">
                <div>
                    <h1 class="h3 fw-bold text-primary mb-1" data-i18n="resourcesPage.header" data-i18n-param-class-name="${fn:escapeXml(className)}" data-i18n-param-subject="${fn:escapeXml(subject)}">
                        Resources for <span class="text-primary">${className}</span> • <span class="text-success">${subject}</span>
                    </h1>
                    <c:if test="${not empty streamName}">
                        <p class="text-muted mb-0" data-i18n="resourcesPage.stream" data-i18n-param-stream="${fn:escapeXml(streamName)}">Stream: ${streamName}</p>
                    </c:if>
                </div>
                <div class="d-flex gap-3">
                    <a href="${pageContext.request.contextPath}/resources" class="btn btn-outline-primary" data-i18n="resourcesPage.backToResources"><i class="fa-solid fa-list me-2"></i>Back to resources</a>
                    <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-primary" data-i18n="resourcesPage.backToDashboard"><i class="fa-solid fa-gauge-high me-2"></i>Dashboard</a>
                </div>
            </div>
        </div>
    </section>

    <c:choose>
        <c:when test="${empty resources}">
            <div class="alert alert-info shadow-sm" data-i18n="resourcesPage.empty">No resources available for this subject and class.</div>
        </c:when>
        <c:otherwise>
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <c:forEach var="resource" items="${resources}">
                    <div class="col">
                        <div class="card resource-card">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${resource.title}</h5>
                                <p class="card-text mb-3" data-i18n="resourcesPage.meta" data-i18n-param-grade="${fn:escapeXml(resource.grade)}" data-i18n-param-subject="${fn:escapeXml(resource.subject)}" data-i18n-param-type="${fn:escapeXml(resource.type)}" data-i18n-param-language="${fn:escapeXml(resource.language)}">
                                    Grade: ${resource.grade} | Subject: ${resource.subject} | Type: ${resource.type} | Language: ${resource.language}
                                </p>
                                <c:set var="progress" value="${progressMap[resource.id]}" />
                                <c:set var="progressStatus" value="${progress != null ? progress.status : 'NOT_STARTED'}" />
                                <c:choose>
                                    <c:when test="${progressStatus == 'COMPLETED'}">
                                        <c:set var="badgeClass" value="success" />
                                        <c:set var="statusKey" value="studentDashboard.completed" />
                                    </c:when>
                                    <c:when test="${progressStatus == 'IN_PROGRESS'}">
                                        <c:set var="badgeClass" value="warning" />
                                        <c:set var="statusKey" value="studentDashboard.inProgress" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="badgeClass" value="secondary" />
                                        <c:set var="statusKey" value="studentDashboard.notStarted" />
                                    </c:otherwise>
                                </c:choose>
                                <div class="mb-3">
                                    <span class="badge bg-${badgeClass} progress-badge">
                                        <span data-i18n="resourcesPage.status">Status</span>: <span data-i18n="${statusKey}"><c:out value="${progressStatus}" /></span>
                                    </span>
                                    <div class="text-muted small mt-2">
                                        <c:if test="${progress != null && progress.lastViewedAt != null}">
                                            <div data-i18n="resourcesPage.lastViewed" data-i18n-param-date="<fmt:formatDate value='${progress.lastViewedAt}' pattern='dd MMM yyyy HH:mm' />">Last viewed: <fmt:formatDate value="${progress.lastViewedAt}" pattern="dd MMM yyyy HH:mm" /></div>
                                        </c:if>
                                        <c:if test="${progress != null && progress.completedAt != null}">
                                            <div data-i18n="resourcesPage.completedAt" data-i18n-param-date="<fmt:formatDate value='${progress.completedAt}' pattern='dd MMM yyyy HH:mm' />">Completed: <fmt:formatDate value="${progress.completedAt}" pattern="dd MMM yyyy HH:mm" /></div>
                                        </c:if>
                                    </div>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/updateResourceProgress" class="mt-auto">
                                    <input type="hidden" name="resourceId" value="${resource.id}" />
                                    <input type="hidden" name="subject" value="${subject}" />
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold" for="status-${resource.id}" data-i18n="resourcesPage.updateStatus">Update status</label>
                                        <select class="form-select" name="status" id="status-${resource.id}">
                                            <c:forEach var="statusOption" items="${statusOptions}">
                                                <c:choose>
                                                    <c:when test="${statusOption == 'COMPLETED'}">
                                                        <c:set var="optionKey" value="studentDashboard.completed" />
                                                    </c:when>
                                                    <c:when test="${statusOption == 'IN_PROGRESS'}">
                                                        <c:set var="optionKey" value="studentDashboard.inProgress" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="optionKey" value="studentDashboard.notStarted" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <option value="${statusOption}" <c:if test="${progress != null && progress.status == statusOption}">selected</c:if> data-i18n="${optionKey}">${statusOption}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold" for="notes-${resource.id}" data-i18n="resourcesPage.notesLabel">Notes (optional)</label>
                                        <textarea class="form-control" name="notes" id="notes-${resource.id}" rows="2" maxlength="500"><c:out value="${progress != null ? progress.notes : ''}" /></textarea>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-outline-primary" data-i18n="resourcesPage.saveProgress"><i class="fa-solid fa-floppy-disk me-2"></i>Save</button>
                                        <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="btn btn-primary" data-i18n="resourcesPage.viewResource"><i class="fa-solid fa-arrow-up-right-from-square me-2"></i>View</a>
                                    </div>
                                </form>
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
