<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="studentDashboardHeader.jsp" %>
<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
    <meta charset="UTF-8">
    <title data-i18n="resourcesPage.title" data-i18n-param-subject="${fn:escapeXml(subject)}">Resources for ${subject}</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <jsp:include page="../common/i18n-scripts.jspf" />
    <style>
        .container { max-width: 900px; margin-top: 40px; }
        .resource-card { margin-bottom: 24px; }
        .resource-title { font-size: 1.2rem; font-weight: 700; color: #2563eb; }
        .resource-meta { color: #64748b; font-size: 0.98rem; }
    </style>
</head>
<body>
<div class="container" style="margin-top:0;">
    <div class="welcome-box" style="background:#e0e7ff;border-radius:10px;padding:28px 24px;margin-bottom:24px;font-size:1.15rem;color:#334155;box-shadow:0 2px 8px rgba(37,99,235,0.07);" data-i18n="resourcesPage.header" data-i18n-param-class-name="${fn:escapeXml(className)}" data-i18n-param-subject="${fn:escapeXml(subject)}">
        Resources for <span style="color:#2563eb;">${className}</span> - <span style="color:#059669;">${subject}</span>
        <c:if test="${not empty streamName}">
            <span style="margin-left:18px;" data-i18n="resourcesPage.stream"><b>Stream</b></span>: <span style="color:#eab308;">${streamName}</span>
        </c:if>
    </div>
    <c:choose>
        <c:when test="${empty resources}">
            <div class="alert alert-info" data-i18n="resourcesPage.empty">No resources available for this subject and class.</div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="resource" items="${resources}">
                    <div class="col-md-6">
                        <div class="card resource-card">
                            <div class="card-body">
                                <div class="resource-title">${resource.title}</div>
                                <div class="resource-meta" data-i18n="resourcesPage.meta" data-i18n-param-grade="${fn:escapeXml(resource.grade)}" data-i18n-param-subject="${fn:escapeXml(resource.subject)}" data-i18n-param-type="${fn:escapeXml(resource.type)}" data-i18n-param-language="${fn:escapeXml(resource.language)}">
                                    Grade: ${resource.grade} | Subject: ${resource.subject} | Type: ${resource.type} | Language: ${resource.language}
                                </div>
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
                                <div class="mt-3">
                                    <span class="badge bg-${badgeClass}">
                                        <span data-i18n="resourcesPage.status">Status</span>: <span data-i18n="${statusKey}"><c:out value="${progressStatus}" /></span>
                                    </span>
                                    <c:if test="${progress != null && progress.lastViewedAt != null}">
                                        <div class="text-muted small mt-1" data-i18n="resourcesPage.lastViewed" data-i18n-param-date="<fmt:formatDate value='${progress.lastViewedAt}' pattern='dd MMM yyyy HH:mm' />">Last viewed: <fmt:formatDate value="${progress.lastViewedAt}" pattern="dd MMM yyyy HH:mm" /></div>
                                    </c:if>
                                    <c:if test="${progress != null && progress.completedAt != null}">
                                        <div class="text-muted small" data-i18n="resourcesPage.completedAt" data-i18n-param-date="<fmt:formatDate value='${progress.completedAt}' pattern='dd MMM yyyy HH:mm' />">Completed: <fmt:formatDate value="${progress.completedAt}" pattern="dd MMM yyyy HH:mm" /></div>
                                    </c:if>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/updateResourceProgress" class="mt-3">
                                    <input type="hidden" name="resourceId" value="${resource.id}" />
                                    <input type="hidden" name="subject" value="${subject}" />
                                    <div class="mb-2">
                                        <label class="form-label" for="status-${resource.id}" data-i18n="resourcesPage.updateStatus">Update Status</label>
                                        <select class="form-select form-select-sm" name="status" id="status-${resource.id}">
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
                                    <div class="mb-2">
                                        <label class="form-label" for="notes-${resource.id}" data-i18n="resourcesPage.notesLabel">Notes (optional)</label>
                                        <textarea class="form-control" name="notes" id="notes-${resource.id}" rows="2" maxlength="500"><c:out value="${progress != null ? progress.notes : ''}" /></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-outline-primary btn-sm" data-i18n="resourcesPage.saveProgress">Save Progress</button>
                                </form>
                                <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="btn btn-primary btn-sm mt-3" data-i18n="resourcesPage.viewResource">View Resource</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
    <c:choose>
        <c:when test="${param.from == 'resources'}">
            <a href="${pageContext.request.contextPath}/resources" class="btn btn-link mt-4" data-i18n="resourcesPage.backToResources">Back to Resources</a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-link mt-4" data-i18n="resourcesPage.backToDashboard">Back to Dashboard</a>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
