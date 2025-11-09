<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
    <meta charset="UTF-8">
    <title>Education Hub Dashboard</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <jsp:include page="../common/i18n-scripts.jspf" />
    <style>
        body {
            background: #f1f5f9;
        }
        .translate-bar {
            background: rgba(255, 255, 255, 0.92);
        }
        .summary-card {
            border-radius: 1rem;
            padding: 1.75rem;
            color: #fff;
            box-shadow: 0 1.5rem 3rem rgba(37, 99, 235, 0.15);
        }
        .summary-card h6 {
            letter-spacing: 0.08em;
            text-transform: uppercase;
            font-size: 0.85rem;
            opacity: 0.85;
        }
        .summary-card .display-5 {
            font-weight: 700;
        }
        .summary-card.bg-primary {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
        }
        .summary-card.bg-success {
            background: linear-gradient(135deg, #16a34a, #0f766e);
        }
        .summary-card.bg-warning {
            background: linear-gradient(135deg, #f59e0b, #d97706);
        }
        .card-shadow {
            border: none;
            border-radius: 1.25rem;
            box-shadow: 0 1.25rem 2.5rem rgba(30, 64, 175, 0.08);
        }
        .section-title {
            font-weight: 700;
            color: #1e40af;
        }
        .resource-badge {
            font-size: 0.85rem;
        }
        .navbar .language-switcher-host {
            min-width: 150px;
        }
    </style>
</head>
<body class="bg-light">
<div style="display:none">
    <jsp:include page="../common/googleTranslateWidget.jspf" />
</div>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/teacherDashboard">Education Hub</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="${pageContext.request.contextPath}/teacherDashboard"><i class="fa-solid fa-gauge me-2"></i>Dashboard</a>
                </li>
                <c:if test="${user.role eq 'teacher'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/teacher/library"><i class="fa-solid fa-book-open me-2"></i>Library</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/my-resources"><i class="fa-solid fa-folder-tree me-2"></i>My Resources</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/teacher/quizzes"><i class="fa-solid fa-clipboard-check me-2"></i>Quizzes</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/teacher/tutoring"><i class="fa-solid fa-calendar-days me-2"></i>Tutoring</a>
                    </li>
                </c:if>
                <c:if test="${user.role eq 'student'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/resources"><i class="fa-solid fa-book me-2"></i>Browse Resources</a>
                    </li>
                </c:if>
    
            </ul>
            <div class="d-flex">
                <div class="me-3 d-flex align-items-center text-white fw-semibold">
                    <label for="language-select" class="me-2 mb-0"><i class="fa-solid fa-language me-1"></i>Language</label>
                    <div class="language-switcher-host" data-google-translate-host></div>
                </div>
                <a class="btn btn-outline-light" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket me-2"></i>Logout</a>
            </div>
        </div>
    </div>
</nav>

<main class="container py-5">
    <c:choose>
        <c:when test="${user.role eq 'teacher'}">
            <c:set var="subjectTotal" value="${empty subjectStats ? 0 : fn:length(subjectStats)}" />
            <c:set var="recentCount" value="${empty recentResources ? 0 : fn:length(recentResources)}" />

            <div class="card card-shadow bg-white mb-4">
                <div class="card-body d-flex flex-column flex-lg-row align-items-start align-items-lg-center justify-content-between gap-4">
                    <div>
                        <h1 class="display-6 fw-bold text-primary mb-2">Welcome back, <c:out value="${user.name}" />!</h1>
                        <p class="text-muted mb-0">Keep building engaging content for your classes. Here's how your library looks today.</p>
                    </div>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="${pageContext.request.contextPath}/teacher/library" class="btn btn-primary btn-lg shadow-sm"><i class="fa-solid fa-upload me-2"></i>Upload Resource</a>
                        <a href="${pageContext.request.contextPath}/my-resources" class="btn btn-outline-primary btn-lg shadow-sm"><i class="fa-solid fa-folder-open me-2"></i>Manage Resources</a>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-md-6">
                    <div class="summary-card bg-primary h-100">
                        <h6>Resources Uploaded</h6>
                        <p class="display-5 mb-1"><c:out value="${resourceCount}" /></p>
                        <p class="mb-0">Keep sharing quality learning material with your students.</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="summary-card bg-success h-100">
                        <h6>Subjects Covered</h6>
                        <p class="display-5 mb-1"><c:out value="${subjectTotal}" /></p>
                        <p class="mb-0">Diversify your library to reach every learner.</p>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-lg-6">
                    <div class="card card-shadow h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2 class="section-title mb-0">Subjects Breakdown</h2>
                                <span class="badge bg-primary rounded-pill">${subjectTotal}</span>
                            </div>
                            <c:if test="${empty subjectStats}">
                                <p class="text-muted mb-0">No subject statistics yet. Start uploading to see insights.</p>
                            </c:if>
                            <c:if test="${not empty subjectStats}">
                                <ul class="list-group list-group-flush">
                                    <c:forEach var="stat" items="${subjectStats}">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <span>${stat.label}</span>
                                            <span class="badge bg-primary-subtle text-primary-emphasis rounded-pill">${stat.count}</span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="card card-shadow h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2 class="section-title mb-0">Engagement Tips</h2>
                                <i class="fa-solid fa-lightbulb text-warning"></i>
                            </div>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">Host a short recap quiz to reinforce new topics.</li>
                                <li class="list-group-item">Encourage students to share questions for upcoming lessons.</li>
                                <li class="list-group-item">Upload bilingual resources to support multilingual learners.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <section class="mb-5">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="section-title mb-0">Recently Uploaded Resources</h2>
                    <span class="badge bg-info text-dark"><i class="fa-solid fa-clock-rotate-left me-2"></i>${recentCount} items</span>
                </div>
                <c:if test="${empty recentResources}">
                    <div class="alert alert-info shadow-sm">
                        You haven't uploaded any resources yet. <a href="${pageContext.request.contextPath}/teacher/library" class="alert-link">Open the resource library</a> to get started.
                    </div>
                </c:if>
                <c:if test="${not empty recentResources}">
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                        <c:forEach var="resource" items="${recentResources}">
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div class="card-body d-flex flex-column">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <div>
                                                <h5 class="card-title fw-semibold mb-1">${resource.title}</h5>
                                                <p class="text-muted small mb-0">Grade ${resource.grade} • ${resource.subject}</p>
                                            </div>
                                            <span class="badge bg-primary-subtle text-primary-emphasis resource-badge">${resource.type}</span>
                                        </div>
                                        <div class="d-flex flex-wrap gap-2 mb-3">
                                            <span class="badge bg-light text-secondary border">${resource.language}</span>
                                            <c:if test="${not empty resource.createdAt}">
                                                <span class="badge bg-light text-secondary border"><i class="fa-solid fa-calendar-day me-1"></i><fmt:formatDate value="${resource.createdAt}" pattern="dd MMM yyyy" /></span>
                                            </c:if>
                                        </div>
                                        <div class="mt-auto d-flex flex-wrap gap-3">
                                            <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="link-primary text-decoration-none"><i class="fa-solid fa-eye me-1"></i>View</a>
                                            <a href="${pageContext.request.contextPath}/delete-resource?id=${resource.id}" class="link-danger text-decoration-none" onclick="return confirm('Are you sure you want to delete this resource?');"><i class="fa-solid fa-trash-can me-1"></i>Delete</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </section>
        </c:when>
        <c:otherwise>
            <div class="card card-shadow mb-4">
                <div class="card-body">
                    <h1 class="section-title mb-3">Find Resources</h1>
                    <p class="text-muted mb-4">Use the filters below to explore materials that match your learning goals.</p>
                    <form action="${pageContext.request.contextPath}/resources" method="get" class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label for="grade" class="form-label">Grade</label>
                            <select class="form-select" id="grade" name="grade">
                                <option value="">All Grades</option>
                                <c:forEach var="grade" items="${grades}">
                                    <option value="${grade}" ${param.grade eq grade ? 'selected' : ''}>${grade}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="subject" class="form-label">Subject</label>
                            <select class="form-select" id="subject" name="subject">
                                <option value="">All Subjects</option>
                                <c:forEach var="subject" items="${subjects}">
                                    <option value="${subject}" ${param.subject eq subject ? 'selected' : ''}>${subject}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="type" class="form-label">Type</label>
                            <select class="form-select" id="type" name="type">
                                <option value="">All Types</option>
                                <option value="PDF" ${param.type eq 'PDF' ? 'selected' : ''}>PDF</option>
                                <option value="Video" ${param.type eq 'Video' ? 'selected' : ''}>Video</option>
                                <option value="Quiz" ${param.type eq 'Quiz' ? 'selected' : ''}>Quiz</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="language" class="form-label">Language</label>
                            <select class="form-select" id="language" name="language">
                                <option value="">All Languages</option>
                                <option value="English" ${param.language eq 'English' ? 'selected' : ''}>English</option>
                                <option value="Tamil" ${param.language eq 'Tamil' ? 'selected' : ''}>Tamil</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="search" class="form-label">Search</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="search" name="search" value="${param.search}" placeholder="Search resources...">
                                <button class="btn btn-primary" type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <section>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="section-title mb-0">Available Resources</h2>
                    <span class="text-muted small">${empty resources ? 0 : fn:length(resources)} items</span>
                </div>
                <c:if test="${empty resources}">
                    <div class="alert alert-info shadow-sm">No resources found matching your criteria. Try adjusting your filters.</div>
                </c:if>
                <c:if test="${not empty resources}">
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                        <c:forEach var="resource" items="${resources}">
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title fw-semibold mb-1">${resource.title}</h5>
                                        <p class="text-muted small mb-3">Grade ${resource.grade} • ${resource.subject}</p>
                                        <div class="mb-3 d-flex flex-wrap gap-2">
                                            <span class="badge bg-primary-subtle text-primary-emphasis">${resource.type}</span>
                                            <span class="badge bg-secondary-subtle text-secondary-emphasis">${resource.language}</span>
                                        </div>
                                        <div class="mt-auto d-flex gap-3">
                                            <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="link-primary text-decoration-none"><i class="fa-solid fa-eye me-1"></i>View</a>
                                            <a href="${pageContext.request.contextPath}/download-resource?id=${resource.id}" class="link-primary text-decoration-none"><i class="fa-solid fa-download me-1"></i>Download</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </section>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
