<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Resources</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <jsp:include page="../common/i18n-scripts.jspf" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e0e7ff 100%);
            min-height: 100vh;
        }
        .subject-card {
            display: block;
            border-radius: 1rem;
            border: none;
            background: linear-gradient(135deg, rgba(37,99,235,0.08), rgba(14,116,144,0.08));
            box-shadow: 0 1.5rem 3rem rgba(30, 64, 175, 0.08);
            text-decoration: none;
            transition: transform 0.18s ease, box-shadow 0.18s ease;
        }
        .subject-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 1.75rem 3.5rem rgba(30, 64, 175, 0.14);
        }
        .subject-card .card-body {
            min-height: 6.5rem;
        }
        .resource-card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 1.5rem 3rem rgba(30, 64, 175, 0.06);
            height: 100%;
        }
        .resource-card .card-title {
            font-weight: 700;
            color: #1d4ed8;
        }
        .resource-card .card-text {
            color: #475569;
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
                    <h1 class="h3 fw-bold text-primary mb-1" data-i18n="resourcesPage.availableHeading">Explore learning resources</h1>
                    <p class="text-muted mb-0" data-i18n="resourcesPage.availableSubheading">Browse curated materials for your grade and subjects.</p>
                </div>
                <a class="btn btn-outline-primary btn-lg" href="${pageContext.request.contextPath}/studentDashboard" data-i18n="resourcesPage.backToDashboard"><i class="fa-solid fa-arrow-left me-2"></i>Back to dashboard</a>
            </div>
        </div>
    </section>

    <section class="mb-4">
        <h2 class="h5 text-secondary mb-3" data-i18n="resourcesPage.subjectsTitle">Jump to a subject</h2>
        <div class="row g-3">
            <c:forEach var="subject" items="${subjects}">
                <div class="col-12 col-sm-6 col-lg-3">
                    <a href="${pageContext.request.contextPath}/studentSubjectResources?subject=${subject}&from=resources" class="subject-card h-100 text-decoration-none text-primary">
                        <div class="card-body d-flex flex-column justify-content-center align-items-center gap-2">
                            <span class="fs-1 text-primary"><i class="fa-solid fa-book-open"></i></span>
                            <span class="fw-semibold text-center">${subject}</span>
                        </div>
                    </a>
                </div>
            </c:forEach>
            <c:if test="${empty subjects}">
                <div class="col-12">
                    <div class="alert alert-info mb-0" data-i18n="resourcesPage.noSubjects">No subjects found for your grade yet.</div>
                </div>
            </c:if>
        </div>
    </section>

    <section class="card border-0 shadow-sm rounded-4 mb-4">
        <div class="card-body p-4">
            <form method="get" action="${pageContext.request.contextPath}/resources" class="row g-3" id="resourceFilterForm">
                <div class="col-md-3">
                    <label for="grade" class="form-label fw-semibold" data-i18n="filters.grade">Grade</label>
                    <select class="form-select" id="grade" name="grade">
                        <option value="" data-i18n="filters.allGrades">All grades</option>
                        <c:forEach var="grade" items="${grades}">
                            <option value="${grade}" <c:if test="${param.grade == grade}">selected</c:if>>${grade}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="subject" class="form-label fw-semibold" data-i18n="filters.subject">Subject</label>
                    <select class="form-select" id="subject" name="subject">
                        <option value="" data-i18n="filters.allSubjects">All subjects</option>
                        <c:forEach var="subject" items="${subjects}">
                            <option value="${subject}" <c:if test="${param.subject == subject}">selected</c:if>>${subject}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label for="type" class="form-label fw-semibold" data-i18n="filters.type">Type</label>
                    <select class="form-select" id="type" name="type">
                        <option value="" data-i18n="filters.allTypes">All types</option>
                        <option value="PDF" <c:if test="${param.type eq 'PDF'}">selected</c:if>>PDF</option>
                        <option value="Video" <c:if test="${param.type eq 'Video'}">selected</c:if>>Video</option>
                        <option value="Quiz" <c:if test="${param.type eq 'Quiz'}">selected</c:if>>Quiz</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label for="language" class="form-label fw-semibold" data-i18n="filters.language">Language</label>
                    <select class="form-select" id="language" name="language">
                        <option value="" data-i18n="filters.allLanguages">All languages</option>
                        <option value="English" <c:if test="${param.language eq 'English'}">selected</c:if>>English</option>
                        <option value="Tamil" <c:if test="${param.language eq 'Tamil'}">selected</c:if>>Tamil</option>
                    </select>
                </div>
                <c:if test="${not empty streams}">
                    <div class="col-md-2">
                        <label for="stream" class="form-label fw-semibold" data-i18n="filters.stream">Stream</label>
                        <select class="form-select" id="stream" name="stream">
                            <option value="" data-i18n="filters.allStreams">All streams</option>
                            <c:forEach var="streamOption" items="${streams}">
                                <option value="${streamOption}" <c:if test="${streamOption == selectedStream}">selected</c:if>>${streamOption}</option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>
                <div class="col-md-4">
                    <label for="search" class="form-label fw-semibold" data-i18n="filters.search">Search</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="search" name="search" value="${param.search}" placeholder="Keyword or subject" data-i18n-placeholder="filters.searchPlaceholder">
                        <button class="btn btn-primary" type="submit"><i class="fa-solid fa-search"></i></button>
                    </div>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <a class="btn btn-outline-secondary w-100" href="${pageContext.request.contextPath}/resources" data-i18n="filters.reset"><i class="fa-solid fa-rotate-left me-2"></i>Reset</a>
                </div>
            </form>
        </div>
    </section>

    <section>
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="h5 fw-semibold mb-0 text-secondary" data-i18n="resourcesPage.resultsHeading">Resources</h2>
            <span class="badge bg-primary-subtle text-primary-emphasis" data-i18n="resourcesPage.resultsCount" data-i18n-param-count="${empty resources ? 0 : fn:length(resources)}">${empty resources ? 0 : fn:length(resources)} items</span>
        </div>
        <c:if test="${empty resources}">
            <div class="alert alert-info shadow-sm" data-i18n="resourcesPage.noResults">No resources match your filters yet. Try adjusting your search.</div>
        </c:if>
        <c:if test="${not empty resources}">
            <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                <c:forEach var="resource" items="${resources}">
                    <div class="col">
                        <div class="card resource-card h-100">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${resource.title}</h5>
                                <p class="card-text mb-3">
                                    <span class="badge bg-primary-subtle text-primary-emphasis me-2">Grade ${resource.grade}</span>
                                    <span class="badge bg-secondary-subtle text-secondary-emphasis me-2">${resource.subject}</span>
                                    <span class="badge bg-info-subtle text-info-emphasis">${resource.type}</span>
                                </p>
                                <p class="text-muted small mb-4"><i class="fa-solid fa-language me-2"></i>${resource.language}</p>
                                <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="btn btn-primary mt-auto" data-i18n="resourcesPage.viewCta"><i class="fa-solid fa-arrow-up-right-from-square me-2"></i>Open resource</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </section>
</div>
</body>
</html>
