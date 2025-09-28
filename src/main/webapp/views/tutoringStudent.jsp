<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upcoming Tutoring Sessions</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <jsp:include page="../common/i18n-scripts.jspf" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #eef2ff, #dbeafe);
            min-height: 100vh;
        }
        .session-card {
            border: none;
            border-radius: 1.25rem;
            box-shadow: 0 1.5rem 3rem rgba(59, 130, 246, 0.12);
        }
        .badge-pill {
            border-radius: 999px;
            padding: 0.4rem 0.85rem;
        }
    </style>
</head>
<body class="bg-light">
<div style="display:none"><jsp:include page="../common/googleTranslateWidget.jspf" /></div>
<div class="container py-5">
    <jsp:include page="studentDashboardHeader.jsp" />

    <section class="card border-0 shadow-sm rounded-4 mb-4">
        <div class="card-body d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3 p-4">
            <div>
                <h1 class="h3 fw-bold text-primary mb-1" data-i18n="tutoring.title">Tutoring calendar</h1>
                <p class="text-muted mb-0" data-i18n="tutoring.subtitle">Join live sessions hosted by your teachers for extra guidance.</p>
            </div>
            <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-outline-primary" data-i18n="tutoring.back"><i class="fa-solid fa-arrow-left me-2"></i>Back to dashboard</a>
        </div>
    </section>

    <c:if test="${empty sessions}">
        <div class="alert alert-info shadow-sm" data-i18n="tutoring.empty">No tutoring sessions are scheduled for your class yet. Check back soon!</div>
    </c:if>

    <c:forEach var="session" items="${sessions}">
        <div class="card session-card mb-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-lg-row justify-content-between gap-3">
                    <div>
                        <h5 class="fw-bold text-primary">${session.title}</h5>
                        <div class="text-muted d-flex flex-wrap gap-3">
                            <span>
                                <i class="fa-solid fa-calendar-days me-1 text-primary"></i>
                                <strong data-i18n="tutoring.dateLabel">Date:</strong>
                                <fmt:formatDate value="${session.sessionTimestamp}" pattern="EEEE, dd MMM yyyy" />
                            </span>
                            <span>
                                <i class="fa-solid fa-clock me-1 text-primary"></i>
                                <strong data-i18n="tutoring.timeLabel">Time:</strong>
                                <fmt:formatDate value="${session.sessionTimestamp}" pattern="hh:mm a" />
                            </span>
                        </div>
                        <div class="mt-3 d-flex flex-wrap gap-2">
                            <span class="badge bg-primary-subtle text-primary-emphasis badge-pill">${session.className != null ? session.className : 'All Classes'}</span>
                            <c:if test="${not empty session.subjectName}">
                                <span class="badge bg-info-subtle text-info-emphasis badge-pill">${session.subjectName}</span>
                            </c:if>
                        </div>
                        <c:if test="${not empty session.description}">
                            <p class="mt-3 mb-0">${session.description}</p>
                        </c:if>
                        <p class="mt-3 mb-0 text-muted"><i class="fa-solid fa-chalkboard-user me-1 text-primary"></i><span data-i18n="tutoring.tutor">Tutor:</span> <strong>${session.tutorName}</strong></p>
                    </div>
                    <div class="text-lg-end">
                        <c:if test="${not empty session.meetingLink}">
                            <a href="${session.meetingLink}" target="_blank" rel="noopener" class="btn btn-primary mb-2" data-i18n="tutoring.join"><i class="fa-solid fa-video me-2"></i>Join session</a>
                        </c:if>
                        <div class="text-muted small" data-i18n="tutoring.scheduledBy">Scheduled by your teachers</div>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
</body>
</html>
