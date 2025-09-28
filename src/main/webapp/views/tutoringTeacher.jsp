<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tutoring Calendar</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background: #f1f5f9; }
        .container { max-width: 1100px; margin-top: 32px; }
        .card { border-radius: 14px; box-shadow: 0 10px 25px rgba(30,64,175,0.12); }
        .card h5 { font-weight: 700; }
        .table thead { background: #1d4ed8; color: #fff; }
        .badge-session { font-size: 0.88rem; }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/teacherDashboard">Education Hub</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/teacherDashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/teacher/library">Resource Library</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/teacher/quizzes">Quizzes</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Tutoring Calendar</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container">
    <div class="row">
        <div class="col-lg-5 mb-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="fa-solid fa-calendar-plus mr-2"></i>Schedule a Session</h5>
                    <c:if test="${not empty message}">
                        <div class="alert alert-${messageType != null ? messageType : 'info'}">${message}</div>
                    </c:if>
                    <form method="post" action="${pageContext.request.contextPath}/teacher/tutoring">
                        <div class="form-group">
                            <label for="title">Session Title</label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>
                        <div class="form-group">
                            <label for="tutorName">Tutor Name</label>
                            <input type="text" class="form-control" id="tutorName" name="tutorName" value="${user.name}" required>
                        </div>
                        <div class="form-group">
                            <label for="sessionDateTime">Date &amp; Time</label>
                            <input type="datetime-local" class="form-control" id="sessionDateTime" name="sessionDateTime" required>
                        </div>
                        <div class="form-group">
                            <label for="classId">Class</label>
                            <select class="form-control" id="classId" name="classId" required>
                                <option value="">Select class</option>
                                <c:forEach var="classInfo" items="${classOptions}">
                                    <option value="${classInfo.id}">${classInfo.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="subjectId">Subject</label>
                            <select class="form-control" id="subjectId" name="subjectId" required>
                                <option value="">Select subject</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="meetingLink">Meeting Link</label>
                            <input type="url" class="form-control" id="meetingLink" name="meetingLink" placeholder="https://...">
                        </div>
                        <div class="form-group">
                            <label for="description">Session Notes</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">Create Session</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-7">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="card-title mb-0"><i class="fa-solid fa-calendar-days mr-2"></i>Upcoming Sessions</h5>
                    </div>
                    <c:if test="${empty sessions}">
                        <div class="alert alert-info mb-0">No tutoring sessions scheduled yet. Create one using the form.</div>
                    </c:if>
                    <c:if test="${not empty sessions}">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>When</th>
                                    <th>Class &amp; Subject</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="session" items="${sessions}">
                                    <tr>
                                        <td>
                                            <div class="font-weight-bold">${session.title}</div>
                                            <div class="text-muted small">Tutor: ${session.tutorName}</div>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${session.sessionTimestamp}" pattern="dd MMM yyyy" />
                                            <div class="text-muted small"><fmt:formatDate value="${session.sessionTimestamp}" pattern="hh:mm a" /></div>
                                        </td>
                                        <td>
                                            <span class="badge badge-primary badge-session">${session.className != null ? session.className : 'All Classes'}</span>
                                            <c:if test="${not empty session.subjectName}">
                                                <span class="badge badge-info badge-session ml-1">${session.subjectName}</span>
                                            </c:if>
                                        </td>
                                        <td class="text-right">
                                            <c:if test="${not empty session.meetingLink}">
                                                <a class="btn btn-outline-primary btn-sm" href="${session.meetingLink}" target="_blank"><i class="fa-solid fa-video"></i></a>
                                            </c:if>
                                            <form method="post" action="${pageContext.request.contextPath}/teacher/tutoring/delete" style="display:inline;">
                                                <input type="hidden" name="id" value="${session.id}">
                                                <button type="submit" class="btn btn-outline-danger btn-sm" onclick="return confirm('Delete this session?');"><i class="fa-solid fa-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    (function() {
        const subjectsByClass = {};
        <c:forEach var="entry" items="${subjectsByClass}">
            subjectsByClass['${entry.key}'] = [
            <c:forEach var="subject" items="${entry.value}" varStatus="loop">
                {id: ${subject.id}, name: "${subject.name}"}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
        </c:forEach>

        const classSelect = document.getElementById('classId');
        const subjectSelect = document.getElementById('subjectId');

        function populateSubjects(classId) {
            subjectSelect.innerHTML = '<option value="">Select subject</option>';
            if (!classId || !subjectsByClass[classId]) {
                return;
            }
            subjectsByClass[classId].forEach(subject => {
                const option = document.createElement('option');
                option.value = subject.id;
                option.textContent = subject.name;
                subjectSelect.appendChild(option);
            });
        }

        classSelect.addEventListener('change', function() {
            populateSubjects(this.value);
        });
    })();
</script>
</body>
</html>
