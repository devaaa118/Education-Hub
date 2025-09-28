<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="studentDashboardHeader.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Take Quiz</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background: linear-gradient(140deg, #e0e7ff, #f8fafc); }
        .container { max-width: 900px; margin-top: 30px; }
        .question-card { border-radius: 16px; box-shadow: 0 12px 32px rgba(59,130,246,0.16); padding: 24px; margin-bottom: 20px; background: #fff; }
        .question-card h5 { font-weight: 700; color: #1e3a8a; }
        .result-banner { border-radius: 16px; padding: 20px; margin-bottom: 24px; font-size: 1.1rem; }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 style="font-weight:800;color:#1d4ed8;">${quiz.title}</h2>
            <div class="text-muted">${quiz.className} &bullet; ${quiz.subjectName} &bullet; ${quiz.language}</div>
            <c:if test="${quiz.timeLimitMinutes != null}">
                <div class="text-muted">Time limit: ${quiz.timeLimitMinutes} minutes</div>
            </c:if>
        </div>
        <a href="${pageContext.request.contextPath}/student/quizzes" class="btn btn-outline-primary">Back to quizzes</a>
    </div>
    <c:if test="${not empty message}">
        <div class="alert alert-${empty messageType ? 'info' : messageType}">${message}</div>
    </c:if>
    <c:if test="${submitted}">
        <div class="result-banner bg-success text-white">
            <strong>Great job!</strong> You scored ${score} out of ${totalMarks}. Correct answers: ${correctAnswers}/${totalQuestions}.
        </div>
    </c:if>
    <c:if test="${not submitted && empty quiz.questions}">
        <div class="alert alert-warning">This quiz does not have questions yet. Check back later.</div>
    </c:if>
    <c:if test="${not submitted && not empty quiz.questions}">
        <form method="post" action="${pageContext.request.contextPath}/take-quiz">
            <input type="hidden" name="quizId" value="${quiz.id}">
            <c:forEach var="question" items="${quiz.questions}" varStatus="status">
                <div class="question-card">
                    <h5>Q${status.index + 1}. ${question.questionText}</h5>
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
                    <div class="text-muted small mt-2">Marks: ${question.marks}</div>
                </div>
            </c:forEach>
            <button type="submit" class="btn btn-primary btn-lg btn-block">Submit Answers</button>
        </form>
    </c:if>
    <c:if test="${submitted}">
        <h4 class="mt-5 mb-3" style="color:#1e3a8a; font-weight:700;">Answer Review</h4>
        <c:forEach var="question" items="${quiz.questions}" varStatus="status">
            <c:set var="selected" value="${responses[question.id]}" />
            <div class="question-card ${question.correctOption == selected ? 'border-success' : 'border-danger'}" style="border-width:2px;">
                <h5>Q${status.index + 1}. ${question.questionText}</h5>
                <div class="mb-2">Correct answer: <strong>${question.correctOption}</strong></div>
                <div class="mb-2">Your answer: <strong>${empty selected ? 'Not answered' : selected}</strong></div>
                <div class="text-muted small">Marks: ${question.marks}</div>
            </div>
        </c:forEach>
        <a href="${pageContext.request.contextPath}/take-quiz?quizId=${quiz.id}" class="btn btn-outline-primary">Retake quiz</a>
    </c:if>
</div>
</body>
</html>
