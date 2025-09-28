<%-- File: src/main/webapp/views/teacherLibrarySubjects.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Resource Library · Subjects</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background: #f1f5f9; }
        .hero-card {
            background: linear-gradient(135deg, rgba(37,99,235,0.12), rgba(236,72,153,0.12));
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 2rem 4rem rgba(30,64,175,0.12);
        }
        .subject-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 1.5rem 3rem rgba(15,23,42,0.08);
            transition: transform .2s ease, box-shadow .2s ease;
        }
        .subject-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 2.5rem 3.5rem rgba(236,72,153,0.16);
        }
    </style>
</head>
<body>
<div style="display:none"><jsp:include page="../common/googleTranslateWidget.jspf" /></div>
<div class="container py-5">
    <div class="hero-card mb-5">
        <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-4">
            <div>
                <span class="badge text-bg-primary rounded-pill mb-2">${selectedGradeName}</span>
                <h1 class="h3 fw-bold text-primary mb-2">Choose a subject to explore resources</h1>
                <p class="text-muted mb-0">Keep everything organised by picking the subject you want to curate.</p>
            </div>
            <div class="text-lg-end">
                <c:if test="${not empty selectedStreamName}">
                    <span class="badge text-bg-info rounded-pill mb-2">${selectedStreamName} stream</span>
                </c:if>
                <span class="display-5 fw-bold text-primary">${fn:length(subjects)}</span>
                <p class="text-muted mb-0">Subjects in focus</p>
                <div class="d-flex gap-2 justify-content-lg-end mt-3 flex-wrap">
                    <c:if test="${not empty streams}">
                        <c:url var="streamUrl" value="/teacher/library">
                            <c:param name="grade" value="${selectedGrade}" />
                        </c:url>
                        <a href="${streamUrl}" class="btn btn-outline-secondary"><i class="bi bi-layers me-1"></i>Change stream</a>
                    </c:if>
                    <c:url var="classesUrl" value="/teacher/library" />
                    <a href="${classesUrl}" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-1"></i>All classes</a>
                    <c:url var="dashboardUrl" value="/teacherDashboard" />
                    <a href="${dashboardUrl}" class="btn btn-outline-primary"><i class="bi bi-speedometer"></i> Dashboard</a>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-${messageType} shadow-sm mb-4">${message}</div>
    </c:if>

    <c:if test="${not empty streams}">
        <div class="mb-4">
            <span class="text-muted d-block mb-2">Streams</span>
            <div class="d-flex flex-wrap gap-2">
                <c:forEach var="entry" items="${streams}">
                    <c:url var="streamLink" value="/teacher/library">
                        <c:param name="grade" value="${selectedGrade}" />
                        <c:param name="stream" value="${entry.key}" />
                    </c:url>
                    <a href="${streamLink}" class="btn btn-sm rounded-pill ${entry.key == selectedStream ? 'btn-primary' : 'btn-outline-primary'}">
                        ${entry.value}
                    </a>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty subjects}">
            <div class="row g-4">
                <c:forEach var="subject" items="${subjects}">
                    <c:url var="subjectLink" value="/teacher/library">
                        <c:param name="grade" value="${selectedGrade}" />
                        <c:if test="${not empty selectedStream}">
                            <c:param name="stream" value="${selectedStream}" />
                        </c:if>
                        <c:param name="subject" value="${subject}" />
                    </c:url>
                    <div class="col-12 col-md-6 col-xl-4">
                        <a href="${subjectLink}" class="text-decoration-none">
                            <div class="card subject-card h-100">
                                <div class="card-body d-flex flex-column gap-3">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <span class="badge text-bg-light text-primary small mb-2">Subject</span>
                                            <h2 class="h5 fw-semibold text-dark mb-0">${subject}</h2>
                                        </div>
                                        <span class="text-muted"><i class="bi bi-chevron-right"></i></span>
                                    </div>
                                    <p class="text-muted mb-0">Open this subject to upload new material, reorganise existing files, or share links.</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info shadow-sm">
                <c:choose>
                    <c:when test="${not empty selectedStreamName}">
                        No subjects are mapped to the ${selectedStreamName} stream yet.
                    </c:when>
                    <c:otherwise>
                        No subjects are mapped to this class yet.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<jsp:include page="../common/i18n-scripts.jspf" />
</body>
</html>
