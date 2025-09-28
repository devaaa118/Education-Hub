<%-- File: src/main/webapp/views/teacherLibraryStreams.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Resource Library · Streams</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background: #f1f5f9; }
        .hero-card {
            background: linear-gradient(135deg, rgba(37,99,235,0.12), rgba(14,165,233,0.12));
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 2rem 4rem rgba(30,64,175,0.12);
        }
        .stream-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 1.5rem 3rem rgba(15,23,42,0.08);
            transition: transform .2s ease, box-shadow .2s ease;
        }
        .stream-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 2.5rem 3.5rem rgba(14,116,144,0.16);
        }
    </style>
</head>
<body>
<div style="display:none"><jsp:include page="../common/googleTranslateWidget.jspf" /></div>
<div class="container py-5">
    <div class="hero-card mb-5">
        <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-4">
            <div>
                <span class="badge text-bg-info rounded-pill mb-2">${selectedGradeName}</span>
                <h1 class="h3 fw-bold text-primary mb-2">Choose the right stream</h1>
                <p class="text-muted mb-0">Resources are organised by academic stream to keep lessons laser-focused.</p>
            </div>
            <div class="text-lg-end">
                <span class="display-5 fw-bold text-primary">${fn:length(streams)}</span>
                <p class="text-muted mb-0">Streams available</p>
                <div class="d-flex gap-2 justify-content-lg-end mt-3 flex-wrap">
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

    <c:choose>
        <c:when test="${not empty streams}">
            <div class="row g-4">
                <c:forEach var="entry" items="${streams}">
                    <c:url var="streamLink" value="/teacher/library">
                        <c:param name="grade" value="${selectedGrade}" />
                        <c:param name="stream" value="${entry.key}" />
                    </c:url>
                    <div class="col-12 col-md-6 col-xl-4">
                        <a href="${streamLink}" class="text-decoration-none">
                            <div class="card stream-card h-100">
                                <div class="card-body d-flex flex-column gap-3">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <span class="badge text-bg-light text-primary small mb-2">Stream</span>
                                            <h2 class="h5 fw-semibold text-dark mb-0">${entry.value}</h2>
                                        </div>
                                        <span class="text-muted"><i class="bi bi-chevron-right"></i></span>
                                    </div>
                                    <p class="text-muted mb-0">Dive into the subjects mapped to this stream and curate the perfect resource list.</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info shadow-sm">No streams are configured for this class yet.</div>
        </c:otherwise>
    </c:choose>
</div>
<jsp:include page="../common/i18n-scripts.jspf" />
</body>
</html>
