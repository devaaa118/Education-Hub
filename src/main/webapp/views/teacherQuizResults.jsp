<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${quiz.title} · Quiz Results</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background: #f8fafc; }
        .hero-card {
            background: linear-gradient(135deg, rgba(37,99,235,0.12), rgba(79,70,229,0.12));
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 1.5rem 3rem rgba(37,99,235,0.12);
        }
        .stat-card {
            border-radius: 18px;
            border: none;
            box-shadow: 0 20px 40px rgba(15,23,42,0.08);
        }
        .stat-value {
            font-size: 1.875rem;
            font-weight: 700;
            color: #1e3a8a;
        }
        .table thead { background: #1d4ed8; color: #fff; }
    </style>
</head>
<body>
<div style="display:none"><jsp:include page="../common/googleTranslateWidget.jspf" /></div>
<div class="container py-5">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-3 mb-4">
        <div>
            <h1 class="h3 fw-bold text-primary mb-1">${quiz.title}</h1>
            <p class="text-muted mb-0">${quiz.className} · ${quiz.subjectName}</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/teacher/quizzes" class="btn btn-outline-secondary"><i class="fa-solid fa-arrow-left me-1"></i>Back to quizzes</a>
        </div>
    </div>

    <div class="hero-card mb-4">
        <div class="row g-4">
            <div class="col-md-4">
                <div class="text-muted text-uppercase small">Total Attempts</div>
                <div class="stat-value">${fn:length(attempts)}</div>
                <div class="text-muted">Students who submitted this quiz.</div>
            </div>
            <div class="col-md-4">
                <div class="text-muted text-uppercase small">Average score</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${averageScore}" type="number" maxFractionDigits="1" minFractionDigits="0" />
                    <c:if test="${maxScore > 0}"><span class="text-muted fs-6">/ ${maxScore}</span></c:if>
                </div>
                <div class="text-muted">Across all submitted attempts.</div>
            </div>
            <div class="col-md-4">
                <div class="text-muted text-uppercase small">Average accuracy</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${averageAccuracy}" type="number" maxFractionDigits="1" minFractionDigits="0" />%
                </div>
                <div class="text-muted">Correct answers across the quiz.</div>
            </div>
        </div>
    </div>

    <c:if test="${topAttempt != null}">
        <div class="card stat-card mb-4">
            <div class="card-body d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
                <div class="d-flex align-items-center gap-3">
                    <span class="rounded-circle bg-primary-subtle text-primary-emphasis p-3">
                        <i class="fa-solid fa-trophy"></i>
                    </span>
                    <div>
                        <div class="text-uppercase small text-muted">Top performer</div>
                        <h2 class="h5 mb-1">${topAttempt.studentName}</h2>
                        <p class="mb-0 text-muted">
                            Score: ${topAttempt.score}
                            <c:if test="${maxScore > 0}">/ ${maxScore}</c:if>
                            · Correct: ${topAttempt.correctAnswers}/${topAttempt.totalQuestions}
                        </p>
                    </div>
                </div>
                <div class="text-muted small">
                    <fmt:formatDate value="${topAttempt.attemptedAt}" pattern="dd MMM yyyy · hh:mm a" />
                </div>
            </div>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty attempts}">
            <div class="alert alert-info shadow-sm">No student submissions yet. Share the quiz link with your class and check back later.</div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                            <tr>
                                <th scope="col">Student</th>
                                <th scope="col">Score</th>
                                <th scope="col">Correct answers</th>
                                <th scope="col">Accuracy</th>
                                <th scope="col">Submitted</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="attempt" items="${attempts}">
                                <c:set var="accuracy" value="${attempt.totalQuestions > 0 ? (attempt.correctAnswers * 100.0) / attempt.totalQuestions : 0}" />
                                <tr>
                                    <td>
                                        <div class="fw-semibold">${attempt.studentName}</div>
                                        <div class="text-muted small">ID: ${attempt.studentId}</div>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary-subtle text-primary-emphasis">
                                            ${attempt.score}
                                            <c:if test="${maxScore > 0}">/ ${maxScore}</c:if>
                                        </span>
                                    </td>
                                    <td>${attempt.correctAnswers}/${attempt.totalQuestions}</td>
                                    <td>
                                        <span class="badge bg-success-subtle text-success-emphasis">
                                            <fmt:formatNumber value="${accuracy}" type="number" maxFractionDigits="1" minFractionDigits="0" />%
                                        </span>
                                    </td>
                                    <td class="text-muted">
                                        <fmt:formatDate value="${attempt.attemptedAt}" pattern="dd MMM yyyy, hh:mm a" />
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<jsp:include page="../common/i18n-scripts.jspf" />
</body>
</html>
