<%-- File: src/main/webapp/views/teacherDashboard.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <style>
        .container {
            max-width: 1200px;
            margin-top: 30px;
        }
        .card {
            margin-bottom: 20px;
        }
        .resource-card {
            height: 100%;
        }
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
                    <li class="nav-item active"><a class="nav-link" href="${pageContext.request.contextPath}/teacherDashboard">Dashboard</a>

                    </li>
                    
                    <c:if test="${user.role eq 'teacher'}">
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/teacher/library">Resource Library</a>

                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/my-resources">My Resources</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/teacher/quizzes">Quizzes</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/teacher/tutoring">Tutoring Calendar</a>
                        </li>
                    </c:if>
                    
                    <c:if test="${user.role eq 'student'}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/resources">Browse Resources</a>
                        </li>
                    </c:if>
                    
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/profile">My Profile</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4">Welcome, ${user.name}!</h2>
        
        <c:if test="${user.role eq 'teacher'}">
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card text-white bg-primary h-100">
                        <div class="card-body d-flex flex-column justify-content-between">
                            <div>
                                <h5 class="card-title">My Resources</h5>
                                <p class="card-text mb-3">You have uploaded ${resourceCount} resources</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/my-resources" class="btn btn-light">Manage Resources</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-success h-100">
                        <div class="card-body d-flex flex-column justify-content-between">
                            <div>
                                <h5 class="card-title">Upload New Resource</h5>
                                <p class="card-text mb-3">Share educational materials with students</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/teacher/library" class="btn btn-light">Open Library</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card bg-light h-100">
                        <div class="card-body">
                            <h5 class="card-title">Coverage Overview</h5>
                            <p class="mb-2"><strong>Subjects:</strong> ${fn:length(subjectStats)}</p>
                            <p class="mb-0"><strong>Grades:</strong> ${fn:length(gradeStats)}</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="card text-white bg-warning h-100">
                        <div class="card-body d-flex flex-column justify-content-between">
                            <div>
                                <h5 class="card-title">Create a Quiz</h5>
                                <p class="card-text mb-3">Design assessments tailored to your class and publish instantly.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/teacher/quizzes" class="btn btn-light">Open Quiz Builder</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card text-white bg-info h-100">
                        <div class="card-body d-flex flex-column justify-content-between">
                            <div>
                                <h5 class="card-title">Schedule Tutoring</h5>
                                <p class="card-text mb-3">Set up live support sessions and share your availability.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/teacher/tutoring" class="btn btn-light">Manage Tutoring Calendar</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Subjects Breakdown</h5>
                            <c:if test="${empty subjectStats}">
                                <p class="text-muted mb-0">No uploads yet.</p>
                            </c:if>
                            <ul class="list-group list-group-flush">
                                <c:forEach var="stat" items="${subjectStats}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <span>${stat.label}</span>
                                        <span class="badge badge-primary badge-pill">${stat.count}</span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Grade Coverage</h5>
                            <c:if test="${empty gradeStats}">
                                <p class="text-muted mb-0">No uploads yet.</p>
                            </c:if>
                            <ul class="list-group list-group-flush">
                                <c:forEach var="stat" items="${gradeStats}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <span>${stat.label}</span>
                                        <span class="badge badge-secondary badge-pill">${stat.count}</span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <h3 class="mb-3">Recently Uploaded Resources</h3>

            <c:if test="${empty recentResources}">
                <div class="alert alert-info">
                    You haven't uploaded any resources yet. <a href="${pageContext.request.contextPath}/teacher/library">Open the resource library</a>
                </div>
            </c:if>

            <div class="row">
                <c:forEach var="resource" items="${recentResources}">
                    <div class="col-md-4">
                        <div class="card resource-card">
                            <div class="card-body">
                                <h5 class="card-title">${resource.title}</h5>
                                <h6 class="card-subtitle mb-2 text-muted">Grade ${resource.grade} | ${resource.subject}</h6>
                                <p class="card-text">
                                    <span class="badge badge-primary">${resource.type}</span>
                                    <span class="badge badge-secondary">${resource.language}</span>
                                </p>
                                <c:if test="${not empty resource.createdAt}">
                                    <p class="small text-muted mb-2">Uploaded on <fmt:formatDate value="${resource.createdAt}" pattern="dd MMM yyyy" /></p>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="card-link">View</a>
                                <a href="${pageContext.request.contextPath}/edit-resource?id=${resource.id}" class="card-link">Edit</a>
                                <a href="${pageContext.request.contextPath}/delete-resource?id=${resource.id}" class="card-link text-danger" onclick="return confirm('Are you sure you want to delete this resource?')">Delete</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <c:if test="${user.role eq 'student'}">
            <div class="filter-section">
                <h4>Find Resources</h4>
                <form action="${pageContext.request.contextPath}/resources" method="get" class="row">
                    <div class="col-md-2">
                        <div class="form-group">
                            <label for="grade">Grade</label>
                            <select class="form-control" id="grade" name="grade">
                                <option value="">All Grades</option>
                                <c:forEach var="grade" items="${grades}">
                                    <option value="${grade}" ${param.grade eq grade ? 'selected' : ''}>${grade}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <select class="form-control" id="subject" name="subject">
                                <option value="">All Subjects</option>
                                <c:forEach var="subject" items="${subjects}">
                                    <option value="${subject}" ${param.subject eq subject ? 'selected' : ''}>${subject}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label for="type">Type</label>
                            <select class="form-control" id="type" name="type">
                                <option value="">All Types</option>
                                <option value="PDF" ${param.type eq 'PDF' ? 'selected' : ''}>PDF</option>
                                <option value="Video" ${param.type eq 'Video' ? 'selected' : ''}>Video</option>
                                <option value="Quiz" ${param.type eq 'Quiz' ? 'selected' : ''}>Quiz</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label for="language">Language</label>
                            <select class="form-control" id="language" name="language">
                                <option value="">All Languages</option>
                                <option value="English" ${param.language eq 'English' ? 'selected' : ''}>English</option>
                                <option value="Tamil" ${param.language eq 'Tamil' ? 'selected' : ''}>Tamil</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="search">Search</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="search" name="search" value="${param.search}" placeholder="Search resources...">
                                <div class="input-group-append">
                                    <button class="btn btn-primary" type="submit">Search</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            
            <h3 class="mb-3">Available Resources</h3>
            
            <c:if test="${empty resources}">
                <div class="alert alert-info">
                    No resources found matching your criteria. Try adjusting your filters.
                </div>
            </c:if>
            
            <div class="row">
                <c:forEach var="resource" items="${resources}">
                    <div class="col-md-4">
                        <div class="card resource-card">
                            <div class="card-body">
                                <h5 class="card-title">${resource.title}</h5>
                                <h6 class="card-subtitle mb-2 text-muted">Grade ${resource.grade} | ${resource.subject}</h6>
                                <p class="card-text">
                                    <span class="badge badge-primary">${resource.type}</span>
                                    <span class="badge badge-secondary">${resource.language}</span>
                                </p>
                                <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="card-link">View</a>
                                <a href="${pageContext.request.contextPath}/download-resource?id=${resource.id}" class="card-link">Download</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</body>
</html>
