<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="studentDashboardHeader.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upcoming Tutoring Sessions</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <style>
        body { background: linear-gradient(135deg, #eef2ff, #dbeafe); }
        .container { max-width: 1000px; margin-top: 30px; }
        .session-card { border-radius: 16px; box-shadow: 0 12px 30px rgba(59,130,246,0.15); background: #fff; margin-bottom: 24px; }
        .session-card h5 { font-weight: 700; color: #1d4ed8; }
        .session-meta { color: #475569; font-size: 0.95rem; }
        .badge-pill { font-size: 0.85rem; }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight:800;color:#1e3a8a;">Tutoring Calendar</h2>
        <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-outline-primary">Back to Dashboard</a>
    </div>
    <c:if test="${empty sessions}">
        <div class="alert alert-info">
            No tutoring sessions are scheduled for your class yet. Check back soon!
        </div>
    </c:if>
    <c:forEach var="session" items="${sessions}">
        <div class="card session-card">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h5 class="card-title">${session.title}</h5>
                        <div class="session-meta">
                            <strong>Date:</strong> <fmt:formatDate value="${session.sessionTimestamp}" pattern="EEEE, dd MMM yyyy" />
                            &nbsp;&nbsp;|&nbsp;&nbsp;
                            <strong>Time:</strong> <fmt:formatDate value="${session.sessionTimestamp}" pattern="hh:mm a" />
                        </div>
                        <div class="session-meta mt-2">
                            <span class="badge badge-primary badge-pill">${session.className != null ? session.className : 'All Classes'}</span>
                            <c:if test="${not empty session.subjectName}">
                                <span class="badge badge-info badge-pill ml-2">${session.subjectName}</span>
                            </c:if>
                        </div>
                        <c:if test="${not empty session.description}">
                            <p class="mt-3 mb-0">${session.description}</p>
                        </c:if>
                        <p class="mt-3 mb-0 text-muted">Tutor: <strong>${session.tutorName}</strong></p>
                    </div>
                    <div class="text-right">
                        <c:if test="${not empty session.meetingLink}">
                            <a href="${session.meetingLink}" target="_blank" class="btn btn-primary mb-2">Join Session</a>
                        </c:if>
                        <div class="text-muted small">Scheduled by your teachers</div>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
</body>
</html>
