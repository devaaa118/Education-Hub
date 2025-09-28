<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
    <meta charset="UTF-8">
    <title data-i18n="studentDashboard.pageTitleFull">Student Dashboard - Education Hub</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <jsp:include page="../common/i18n-scripts.jspf" />
    <style>
        body {
            background: linear-gradient(120deg, #f8fafc 0%, #e0e7ff 100%);
            min-height: 100vh;
        }
        .dashboard-container {
            max-width: 1100px;
            margin: 36px auto 60px auto;
            padding: 0 24px;
        }
        .translate-container {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 16px;
        }
        .translate-container #google_translate_element {
            margin: 0;
        }
        .section-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 28px 32px;
            margin-bottom: 28px;
            box-shadow: 0 18px 40px rgba(37, 99, 235, 0.10);
        }
        .section-header {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
        }
        .section-header h4 {
            font-weight: 800;
            color: #1d4ed8;
            margin-bottom: 4px;
        }
        .section-subtitle {
            color: #64748b;
            margin: 0;
        }
        .summary-pill {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff;
            border-radius: 16px;
            padding: 18px 24px;
            text-align: right;
            min-width: 200px;
        }
        .summary-pill span {
            display: block;
        }
        .summary-title {
            font-size: 0.9rem;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            opacity: 0.85;
        }
        .summary-count {
            font-size: 2rem;
            font-weight: 800;
        }
        .overall-progress {
            margin-top: 22px;
        }
        .progress-label {
            display: flex;
            justify-content: space-between;
            font-weight: 600;
            color: #1e3a8a;
            margin-bottom: 8px;
        }
        .progress {
            height: 12px;
            background-color: #e2e8f0;
            border-radius: 999px;
            overflow: hidden;
        }
        .progress-bar {
            background: linear-gradient(135deg, #38bdf8, #2563eb);
        }
        .progress-grid .progress-tile {
            border-radius: 16px;
            padding: 20px 22px;
            height: 100%;
            display: flex;
            gap: 18px;
            align-items: center;
            transition: transform 0.18s ease, box-shadow 0.18s ease;
            border: 1px solid rgba(37, 99, 235, 0.12);
            box-shadow: 0 14px 30px rgba(37, 99, 235, 0.08);
        }
        .progress-grid .progress-tile:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 36px rgba(37, 99, 235, 0.12);
        }
        .progress-icon {
            width: 60px;
            height: 60px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            font-size: 1.6rem;
        }
        .progress-meta {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .status-label {
            font-weight: 700;
            font-size: 1.05rem;
            color: #1e293b;
        }
        .status-count {
            font-weight: 800;
            font-size: 1.8rem;
            color: #1d4ed8;
        }
        .status-subtext {
            color: #94a3b8;
            font-size: 0.9rem;
        }
        .tile-completed .progress-icon {
            background: rgba(16, 185, 129, 0.12);
            color: #0f766e;
        }
        .tile-progress .progress-icon {
            background: rgba(234, 179, 8, 0.14);
            color: #a16207;
        }
        .tile-notstarted .progress-icon {
            background: rgba(148, 163, 184, 0.18);
            color: #475569;
        }
        .welcome-card {
            display: flex;
            flex-wrap: wrap;
            gap: 22px;
            justify-content: space-between;
            align-items: center;
        }
        .welcome-card h2 {
            font-weight: 800;
            color: #1d4ed8;
            margin-bottom: 8px;
        }
        .welcome-card p {
            margin: 0;
            color: #475569;
            font-size: 1.05rem;
        }
        .quick-actions {
            display: flex;
            gap: 14px;
        }
        .quick-actions .btn {
            border-radius: 999px;
            padding: 10px 20px;
            font-weight: 600;
        }
        .subject-card {
            border-radius: 18px;
            border: 1px solid rgba(37, 99, 235, 0.18);
            background: rgba(248, 250, 252, 0.92);
            box-shadow: 0 10px 26px rgba(37, 99, 235, 0.08);
            height: 100%;
            transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
            text-decoration: none !important;
        }
        .subject-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 14px 34px rgba(37, 99, 235, 0.12);
            border-color: rgba(37, 99, 235, 0.32);
        }
        .subject-card .card-body {
            text-align: center;
            padding: 26px 22px;
        }
        .subject-card .subject-icon {
            font-size: 2.4rem;
            color: #2563eb;
            margin-bottom: 10px;
        }
        .subject-card .subject-name {
            font-weight: 800;
            font-size: 1.18rem;
            color: #1e3a8a;
        }
        .subject-stream {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 10px;
            padding: 6px 12px;
            border-radius: 999px;
            background: rgba(234, 179, 8, 0.14);
            color: #a16207;
            font-weight: 600;
            font-size: 0.92rem;
        }
        @media (max-width: 768px) {
            .section-card {
                padding: 24px 22px;
            }
            .summary-pill {
                width: 100%;
                text-align: left;
            }
            .welcome-card {
                flex-direction: column;
                align-items: flex-start;
            }
            .quick-actions {
                width: 100%;
            }
            .quick-actions .btn {
                flex: 1;
                text-align: center;
            }
        }
    </style>
</head>
<body>
<div class="translate-container">
    <jsp:include page="../common/googleTranslateWidget.jspf" />
</div>
<jsp:include page="studentDashboardHeader.jsp" />

<c:set var="totalResources" value="0" />
<c:forEach var="entry" items="${progressCounts}">
    <c:set var="totalResources" value="${totalResources + entry.value}" />
</c:forEach>
<c:set var="completedCount" value="${progressCounts['COMPLETED'] != null ? progressCounts['COMPLETED'] : 0}" />
<c:set var="completionPercent" value="${totalResources > 0 ? (completedCount * 100.0) / totalResources : 0}" />

<c:set var="studentName" value="${sessionScope.user != null ? sessionScope.user.name : 'Student'}" />
<div class="dashboard-container">
    <div class="section-card welcome-card">
        <div>
            <h2 data-i18n="studentDashboard.welcome" data-i18n-param-name="${fn:escapeXml(studentName)}">Welcome back, <b><c:out value="${studentName}" /></b>!</h2>
            <p data-i18n="studentDashboard.subtitle">Keep an eye on your learning progress and jump into the resources curated for your class.</p>
        </div>
        <div class="quick-actions">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/resources"><i class="fa-solid fa-book-open-reader me-2"></i><span data-i18n="studentDashboard.browseResources">Browse Resources</span></a>
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/student/quizzes"><i class="fa-solid fa-clipboard-check me-2"></i><span data-i18n="studentDashboard.takeQuiz">Take a Quiz</span></a>
        </div>
    </div>

    <div class="section-card">
        <div class="section-header">
            <div>
                <h4 data-i18n="studentDashboard.progressTitle">Learning Progress</h4>
                <p class="section-subtitle" data-i18n="studentDashboard.progressSubtitle">A snapshot of how you are moving through the materials assigned to your class.</p>
            </div>
            <div class="summary-pill">
                <span class="summary-title" data-i18n="studentDashboard.totalResources">Total resources</span>
                <span class="summary-count"><c:out value="${totalResources}" /></span>
            </div>
        </div>

        <div class="overall-progress">
            <div class="progress-label">
                <span data-i18n="studentDashboard.overallCompletion">Overall completion</span>
                <span><fmt:formatNumber value="${completionPercent}" maxFractionDigits="0" />%</span>
            </div>
            <div class="progress" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="${completionPercent}">
                <div class="progress-bar" style="width: <fmt:formatNumber value="${completionPercent}" maxFractionDigits="0" />%;"></div>
            </div>
        </div>

        <div class="row row-cols-1 row-cols-md-3 g-3 mt-2 progress-grid">
            <c:forEach var="status" items="${statusOptions}">
                <c:set var="count" value="${progressCounts[status] != null ? progressCounts[status] : 0}" />
                <c:choose>
                    <c:when test="${status == 'COMPLETED'}">
                        <c:set var="tileClass" value="tile-completed" />
                        <c:set var="iconClass" value="fa-solid fa-trophy" />
                        <c:set var="labelKey" value="studentDashboard.completed" />
                        <c:set var="accentKey" value="studentDashboard.completedCaption" />
                    </c:when>
                    <c:when test="${status == 'IN_PROGRESS'}">
                        <c:set var="tileClass" value="tile-progress" />
                        <c:set var="iconClass" value="fa-solid fa-hourglass-half" />
                        <c:set var="labelKey" value="studentDashboard.inProgress" />
                        <c:set var="accentKey" value="studentDashboard.inProgressCaption" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="tileClass" value="tile-notstarted" />
                        <c:set var="iconClass" value="fa-regular fa-circle" />
                        <c:set var="labelKey" value="studentDashboard.notStarted" />
                        <c:set var="accentKey" value="studentDashboard.notStartedCaption" />
                    </c:otherwise>
                </c:choose>
                <div class="col">
                    <div class="progress-tile ${tileClass}">
                        <div class="progress-icon">
                            <i class="${iconClass}"></i>
                        </div>
                        <div class="progress-meta">
                            <span class="status-label" data-i18n="${labelKey}">Completed</span>
                            <span class="status-count"><c:out value="${count}" /></span>
                            <span class="status-subtext" data-i18n="${accentKey}">Great job finishing these!</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="section-card">
        <div class="section-header">
            <div>
                <h4 data-i18n="studentDashboard.subjectsTitle">Your Subjects</h4>
                <p class="section-subtitle" data-i18n="studentDashboard.subjectsSubtitle">Jump into a subject to explore its latest lessons, notes, and practice material.</p>
            </div>
        </div>
        <c:if test="${empty subjects}">
            <div class="alert alert-info mb-0" data-i18n="studentDashboard.subjectsEmpty">Your teachers have not assigned any subjects yet. Check back soon!</div>
        </c:if>
        <c:if test="${not empty subjects}">
            <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-3 mt-1">
                <c:forEach var="course" items="${subjects}">
                    <a href="${pageContext.request.contextPath}/studentSubjectResources?subject=${course}" class="col text-decoration-none">
                        <div class="card subject-card">
                            <div class="card-body">
                                <div class="subject-icon"><i class="fa-solid fa-book-open"></i></div>
                                <div class="subject-name">${course}</div>
                                <c:if test="${not empty streamName}">
                                    <div class="subject-stream"><i class="fa-solid fa-layer-group"></i> <span data-i18n="studentDashboard.streamLabel">Stream</span>: ${streamName}</div>
                                </c:if>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>
