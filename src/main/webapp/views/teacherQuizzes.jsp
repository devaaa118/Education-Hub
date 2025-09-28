<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Quizzes</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background: #f8fafc; }
        .container { max-width: 1200px; margin-top: 32px; }
        .card { border-radius: 16px; box-shadow: 0 14px 40px rgba(17,24,39,0.10); }
        .quiz-table thead { background: #1d4ed8; color: #fff; }
        .question-block { background: #f1f5f9; border-radius: 12px; padding: 16px; margin-bottom: 18px; }
        .question-block h6 { font-weight: 700; color: #1e3a8a; }
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/teacherDashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/teacher/library">Resource Library</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Quizzes</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/teacher/tutoring">Tutoring Calendar</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container">
    <div class="row">
        <div class="col-lg-6 mb-4">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title mb-3"><i class="fa-solid fa-square-poll-horizontal mr-2"></i>Create New Quiz</h4>
                    <c:if test="${not empty message}">
                        <div class="alert alert-${messageType != null ? messageType : 'info'}">${message}</div>
                    </c:if>
                    <form method="post" action="${pageContext.request.contextPath}/teacher/quizzes" id="quizForm">
                        <div class="form-group">
                            <label for="title">Quiz Title</label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>
                        <div class="form-group">
                            <label for="description">Instructions</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="classId">Class</label>
                                <select class="form-control" id="classId" name="classId" required>
                                    <option value="">Select class</option>
                                    <c:forEach var="classInfo" items="${classOptions}">
                                        <option value="${classInfo.id}">${classInfo.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="subjectId">Subject</label>
                                <select class="form-control" id="subjectId" name="subjectId" required>
                                    <option value="">Select subject</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="language">Language</label>
                                <select class="form-control" id="language" name="language">
                                    <option value="English">English</option>
                                    <option value="Tamil">Tamil</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="timeLimitMinutes">Time Limit (minutes)</label>
                                <input type="number" class="form-control" id="timeLimitMinutes" name="timeLimitMinutes" min="0" placeholder="Optional">
                            </div>
                        </div>
                        <hr>
                        <div id="questionsContainer"></div>
                        <button type="button" class="btn btn-outline-primary mb-3" id="addQuestionBtn"><i class="fa-solid fa-plus"></i> Add Question</button>
                        <button type="submit" class="btn btn-primary btn-block">Save Quiz</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title mb-3"><i class="fa-solid fa-list-check mr-2"></i>My Quizzes</h4>
                    <c:if test="${empty quizzes}">
                        <div class="alert alert-info">You haven't created any quizzes yet. Build one using the form.</div>
                    </c:if>
                    <c:if test="${not empty quizzes}">
                        <div class="table-responsive">
                            <table class="table table-hover quiz-table">
                                <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Class/Subject</th>
                                    <th>Questions</th>
                                    <th>Attempts</th>
                                    <th>Created</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="quiz" items="${quizzes}">
                                    <tr>
                                        <td>
                                            <div class="font-weight-bold">${quiz.title}</div>
                                            <div class="text-muted small">${quiz.language}</div>
                                        </td>
                                        <td>
                                            <span class="badge badge-primary">${quiz.className}</span>
                                            <div class="text-muted small mt-1">${quiz.subjectName}</div>
                                        </td>
                                        <td>${quiz.questionCount}</td>
                                        <td>${quiz.attemptCount}</td>
                                        <td><fmt:formatDate value="${quiz.createdAt}" pattern="dd MMM yyyy" /></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    (function() {
        const subjectsByClass = {};
        <c:forEach var="entry" items="${subjectsByClass}">
            subjectsByClass['${entry.key}'] = [
            <c:forEach var="subject" items="${entry.value}" varStatus="loop">
                {id: ${subject.id}, name: "${subject.name}"}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
        </c:forEach>

        const classSelect = document.getElementById('classId');
        const subjectSelect = document.getElementById('subjectId');
        const container = document.getElementById('questionsContainer');
        const addQuestionBtn = document.getElementById('addQuestionBtn');

        function populateSubjects(classId) {
            subjectSelect.innerHTML = '<option value="">Select subject</option>';
            if (!classId || !subjectsByClass[classId]) {
                return;
            }
            subjectsByClass[classId].forEach(subject => {
                const option = document.createElement('option');
                option.value = subject.id;
                option.textContent = subject.name;
                subjectSelect.appendChild(option);
            });
        }

        function createQuestionBlock(index) {
            const wrapper = document.createElement('div');
            wrapper.className = 'question-block';
            wrapper.innerHTML = `
                <h6>Question ${index + 1}</h6>
                <div class="form-group">
                    <label>Question Text</label>
                    <textarea class="form-control" name="questionText" rows="2" required></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label>Option A</label>
                        <input type="text" class="form-control" name="optionA" required>
                    </div>
                    <div class="form-group col-md-6">
                        <label>Option B</label>
                        <input type="text" class="form-control" name="optionB" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label>Option C</label>
                        <input type="text" class="form-control" name="optionC" required>
                    </div>
                    <div class="form-group col-md-6">
                        <label>Option D</label>
                        <input type="text" class="form-control" name="optionD" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-4">
                        <label>Correct Option</label>
                        <select class="form-control" name="correctOption">
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                        </select>
                    </div>
                    <div class="form-group col-md-4">
                        <label>Marks</label>
                        <input type="number" class="form-control" name="marks" min="1" value="1" required>
                    </div>
                    <div class="form-group col-md-4 d-flex align-items-end">
                        <button type="button" class="btn btn-link text-danger p-0" onclick="this.closest('.question-block').remove(); renumberQuestions();">Remove</button>
                    </div>
                </div>
            `;
            return wrapper;
        }

        window.renumberQuestions = function() {
            Array.from(container.querySelectorAll('.question-block')).forEach((block, idx) => {
                block.querySelector('h6').textContent = `Question ${idx + 1}`;
            });
        };

        addQuestionBtn.addEventListener('click', function() {
            const block = createQuestionBlock(container.children.length);
            container.appendChild(block);
        });

        classSelect.addEventListener('change', function() {
            populateSubjects(this.value);
        });

        // Initialize with one question block
        addQuestionBtn.click();
    })();
</script>
</body>
</html>
