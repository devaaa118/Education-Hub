<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Take Quiz</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <jsp:include page="../common/i18n-scripts.jspf" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background: linear-gradient(140deg, #e0e7ff, #f8fafc);
            min-height: 100vh;
        }
        .question-card {
            border: none;
            border-radius: 1.25rem;
            box-shadow: 0 1.5rem 3rem rgba(59, 130, 246, 0.18);
            padding: 1.75rem;
            background: #fff;
        }
        .question-card h5 {
            font-weight: 700;
            color: #1e3a8a;
        }
        .result-banner {
            border-radius: 1.25rem;
            padding: 1.5rem;
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
                <h1 class="h3 fw-bold text-primary mb-1">${quiz.title}</h1>
                <div class="text-muted">
                    ${quiz.className}
                    <span class="mx-2">•</span>
                    ${quiz.subjectName}
                    <span class="mx-2">•</span>
                    ${quiz.language}
                </div>
                <c:if test="${quiz.timeLimitMinutes != null}">
                    <div class="text-muted" data-i18n="quiz.timeLimit" data-i18n-param-minutes="${quiz.timeLimitMinutes}">Time limit: ${quiz.timeLimitMinutes} minutes</div>
                </c:if>
            </div>
            <a href="${pageContext.request.contextPath}/student/quizzes" class="btn btn-outline-primary"><i class="fa-solid fa-arrow-left me-2"></i><span data-i18n="quiz.back">Back to quizzes</span></a>
        </div>
    </section>

    <c:if test="${not empty message}">
        <div class="alert alert-${empty messageType ? 'info' : messageType} shadow-sm">${message}</div>
    </c:if>

    <c:if test="${submitted}">
        <div class="result-banner bg-success text-white shadow-sm mb-4">
            <strong data-i18n="quiz.result.congrats">Great job!</strong>
            <span data-i18n="quiz.result.summary" data-i18n-param-score="${score}" data-i18n-param-total="${totalMarks}" data-i18n-param-correct="${correctAnswers}" data-i18n-param-count="${totalQuestions}">
                You scored ${score} out of ${totalMarks}. Correct answers: ${correctAnswers}/${totalQuestions}.
            </span>
        </div>
    </c:if>

    <c:if test="${not submitted && empty quiz.questions}">
        <div class="alert alert-warning shadow-sm" data-i18n="quiz.noQuestions">This quiz does not have questions yet. Check back later.</div>
    </c:if>

    <c:if test="${not submitted && not empty quiz.questions}">
        <form method="post" action="${pageContext.request.contextPath}/take-quiz" class="d-grid gap-4">
            <input type="hidden" name="quizId" value="${quiz.id}">
            <c:forEach var="question" items="${quiz.questions}" varStatus="status">
                <div class="question-card">
                    <h5>Q${status.index + 1}. ${question.questionText}</h5>
                    <div class="d-grid gap-2 mt-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="answer_${question.id}" id="q${question.id}A" value="A" required>
                            <label class="form-check-label" for="q${question.id}A">${question.optionA}</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="answer_${question.id}" id="q${question.id}B" value="B">
                            <label class="form-check-label" for="q${question.id}B">${question.optionB}</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="answer_${question.id}" id="q${question.id}C" value="C">
                            <label class="form-check-label" for="q${question.id}C">${question.optionC}</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="answer_${question.id}" id="q${question.id}D" value="D">
                            <label class="form-check-label" for="q${question.id}D">${question.optionD}</label>
                        </div>
                    </div>
                    <div class="text-muted small mt-3" data-i18n="quiz.marks" data-i18n-param-marks="${question.marks}">Marks: ${question.marks}</div>
                </div>
            </c:forEach>
            <button type="submit" class="btn btn-primary btn-lg w-100" data-i18n="quiz.submit"><i class="fa-solid fa-paper-plane me-2"></i>Submit answers</button>
        </form>
    </c:if>

    <c:if test="${submitted}">
        <h2 class="h5 fw-bold text-primary mt-5 mb-3" data-i18n="quiz.reviewTitle">Answer review</h2>
        <div class="d-grid gap-4">
            <c:forEach var="question" items="${quiz.questions}" varStatus="status">
                <c:set var="selected" value="${responses[question.id]}" />
                <div class="question-card border-2 ${question.correctOption == selected ? 'border-success' : 'border-danger'}">
                    <h5>Q${status.index + 1}. ${question.questionText}</h5>
                    <div class="mb-2" data-i18n="quiz.correctAnswer" data-i18n-param-option="${question.correctOption}">Correct answer: <strong>${question.correctOption}</strong></div>
                    <div class="mb-2" data-i18n="quiz.yourAnswer" data-i18n-param-option="${empty selected ? 'Not answered' : selected}">Your answer: <strong>${empty selected ? 'Not answered' : selected}</strong></div>
                    <div class="text-muted small" data-i18n="quiz.marks" data-i18n-param-marks="${question.marks}">Marks: ${question.marks}</div>
                </div>
            </c:forEach>
        </div>
        <a href="${pageContext.request.contextPath}/take-quiz?quizId=${quiz.id}" class="btn btn-outline-primary mt-4" data-i18n="quiz.retake"><i class="fa-solid fa-rotate-right me-2"></i>Retake quiz</a>
    </c:if>
</div>
</body>
</html>
