<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quizzes</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <jsp:include page="../common/i18n-scripts.jspf" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            min-height: 100vh;
        }
        .quiz-card {
            border: none;
            border-radius: 1.25rem;
            box-shadow: 0 1.75rem 3.5rem rgba(30, 64, 175, 0.14);
            height: 100%;
        }
        .quiz-card .card-title {
            font-weight: 800;
            color: #1d4ed8;
        }
        .badge-pill {
            border-radius: 999px;
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
                <h1 class="h3 fw-bold text-primary mb-1" data-i18n="quizzes.title">Available quizzes</h1>
                <p class="text-muted mb-0" data-i18n="quizzes.subtitle">Challenge yourself with the latest assessments created by your teachers.</p>
            </div>
            <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-outline-primary" data-i18n="quizzes.back"><i class="fa-solid fa-arrow-left me-2"></i>Back to dashboard</a>
        </div>
    </section>

    <c:if test="${empty quizzes}">
        <div class="alert alert-info shadow-sm" data-i18n="quizzes.empty">No quizzes are available for your class right now. Your teachers will add them soon!</div>
    </c:if>

    <c:if test="${not empty quizzes}">
        <div class="row row-cols-1 row-cols-lg-2 g-4">
            <c:forEach var="quiz" items="${quizzes}">
                <div class="col">
                    <div class="card quiz-card">
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start gap-3">
                                <div>
                                    <h5 class="card-title">${quiz.title}</h5>
                                    <p class="text-muted mb-3">${quiz.description}</p>
                                    <div class="d-flex flex-wrap gap-2 mb-2">
                                        <span class="badge bg-primary-subtle text-primary-emphasis badge-pill">${quiz.className}</span>
                                        <span class="badge bg-info-subtle text-info-emphasis badge-pill">${quiz.subjectName}</span>
                                        <span class="badge bg-light text-secondary border badge-pill"><i class="fa-solid fa-language me-1"></i>${quiz.language}</span>
                                    </div>
                                    <div class="text-muted small">
                                        <span data-i18n="quizzes.questions" data-i18n-param-count="${quiz.questionCount}">Questions: ${quiz.questionCount}</span>
                                        <c:if test="${quiz.timeLimitMinutes != null}">
                                            <span class="ms-2" data-i18n="quizzes.timeLimit" data-i18n-param-minutes="${quiz.timeLimitMinutes}">| Time limit: ${quiz.timeLimitMinutes} min</span>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <c:set var="latest" value="${attempts[quiz.id]}" />
                                    <c:if test="${not empty latest}">
                                        <div class="badge bg-success-subtle text-success-emphasis badge-pill">
                                            <span data-i18n="quizzes.lastScore" data-i18n-param-score="${latest.score}" data-i18n-param-total="${latest.totalQuestions}">Last score: ${latest.score}/${latest.totalQuestions}</span>
                                        </div>
                                        <div class="small text-muted mt-2">
                                            <fmt:formatDate value="${latest.attemptedAt}" pattern="dd MMM yyyy" />
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="mt-4 d-flex justify-content-between align-items-center">
                                <a href="${pageContext.request.contextPath}/take-quiz?quizId=${quiz.id}" class="btn btn-primary" data-i18n="quizzes.take"><i class="fa-solid fa-play me-2"></i>Take quiz</a>
                                <c:if test="${not empty latest}">
                                    <span class="text-muted small" data-i18n="quizzes.lastAttempt">Keep practicing to improve your score!</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>
</body>
</html>
