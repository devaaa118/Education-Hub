<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="studentDashboardHeader.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quizzes</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #eff6ff, #dbeafe); }
        .container { max-width: 1100px; margin-top: 30px; }
        .quiz-card { border-radius: 18px; box-shadow: 0 14px 40px rgba(37,99,235,0.18); background: #fff; margin-bottom: 24px; border: none; }
        .quiz-card h5 { font-weight: 800; color: #1d4ed8; }
        .badge { font-size: 0.85rem; }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight:800;color:#1e40af;">Available Quizzes</h2>
        <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-outline-primary">Back to Dashboard</a>
    </div>
    <c:if test="${empty quizzes}">
        <div class="alert alert-info">No quizzes are available for your class right now. Your teachers will add them soon!</div>
    </c:if>
    <div class="row">
        <c:forEach var="quiz" items="${quizzes}">
            <div class="col-md-6">
                <div class="card quiz-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h5 class="card-title">${quiz.title}</h5>
                                <p class="text-muted mb-2">${quiz.description}</p>
                                <div class="mb-2">
                                    <span class="badge badge-primary mr-2">${quiz.className}</span>
                                    <span class="badge badge-info">${quiz.subjectName}</span>
                                </div>
                                <div class="text-muted small">
                                    Questions: <strong>${quiz.questionCount}</strong>
                                    <c:if test="${quiz.timeLimitMinutes != null}">
                                        &nbsp;|&nbsp; Time limit: <strong>${quiz.timeLimitMinutes} min</strong>
                                    </c:if>
                                </div>
                                <div class="text-muted small">Language: ${quiz.language}</div>
                            </div>
                            <div class="text-right">
                                <c:set var="latest" value="${attempts[quiz.id]}" />
                                <c:if test="${not empty latest}">
                                    <div class="badge badge-success mb-2">Last Score: ${latest.score}/${latest.totalQuestions}</div>
                                    <div class="small text-muted">
                                        <fmt:formatDate value="${latest.attemptedAt}" pattern="dd MMM yyyy" />
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/take-quiz?quizId=${quiz.id}" class="btn btn-primary">Take Quiz</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
