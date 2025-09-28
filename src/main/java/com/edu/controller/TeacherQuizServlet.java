package com.edu.controller;

import com.edu.dao.QuizDAO;
import com.edu.dao.resourceDAO;
import com.edu.model.ClassInfo;
import com.edu.model.Quiz;
import com.edu.model.QuizQuestion;
import com.edu.model.SubjectInfo;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/teacher/quizzes")
public class TeacherQuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        String error = request.getParameter("error");
        if (error != null) {
            if ("invalidQuiz".equals(error)) {
                request.setAttribute("message", "We couldn't identify that quiz. Please try again.");
                request.setAttribute("messageType", "danger");
            } else if ("missingQuiz".equals(error)) {
                request.setAttribute("message", "That quiz isn't available anymore or doesn't belong to you.");
                request.setAttribute("messageType", "warning");
            }
        }

        QuizDAO quizDAO = new QuizDAO();
        resourceDAO resourceDao = new resourceDAO();
        List<Quiz> quizzes = quizDAO.getQuizzesByTeacher(user.getId());
        List<ClassInfo> classes = resourceDao.getAllClasses();
        Map<Integer, List<SubjectInfo>> subjectsByClass = quizDAO.getSubjectsByClass();

        request.setAttribute("quizzes", quizzes);
        request.setAttribute("classOptions", classes);
        request.setAttribute("subjectsByClass", subjectsByClass);
        request.getRequestDispatcher("/views/teacherQuizzes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String classIdParam = request.getParameter("classId");
        String subjectIdParam = request.getParameter("subjectId");
        String language = request.getParameter("language");
        String timeLimitParam = request.getParameter("timeLimitMinutes");

        String[] questionTexts = request.getParameterValues("questionText");
        String[] optionA = request.getParameterValues("optionA");
        String[] optionB = request.getParameterValues("optionB");
        String[] optionC = request.getParameterValues("optionC");
        String[] optionD = request.getParameterValues("optionD");
        String[] correctOption = request.getParameterValues("correctOption");
        String[] marks = request.getParameterValues("marks");

        if (title == null || title.isBlank() || classIdParam == null || classIdParam.isBlank() ||
                subjectIdParam == null || subjectIdParam.isBlank() || language == null) {
            request.setAttribute("message", "Title, class, subject, and language are required.");
            request.setAttribute("messageType", "danger");
            doGet(request, response);
            return;
        }

        List<QuizQuestion> questions = new ArrayList<>();
        if (questionTexts != null) {
            for (int i = 0; i < questionTexts.length; i++) {
                String qText = questionTexts[i];
                if (qText == null || qText.isBlank()) {
                    continue;
                }
                QuizQuestion question = new QuizQuestion();
                question.setQuestionText(qText.trim());
                question.setOptionA(optionA != null && optionA.length > i ? optionA[i].trim() : "");
                question.setOptionB(optionB != null && optionB.length > i ? optionB[i].trim() : "");
                question.setOptionC(optionC != null && optionC.length > i ? optionC[i].trim() : "");
                question.setOptionD(optionD != null && optionD.length > i ? optionD[i].trim() : "");
                question.setCorrectOption(correctOption != null && correctOption.length > i ? correctOption[i] : "A");
                int markValue = 1;
                if (marks != null && marks.length > i) {
                    try {
                        markValue = Integer.parseInt(marks[i]);
                    } catch (NumberFormatException ignored) {
                    }
                }
                question.setMarks(markValue);
                questions.add(question);
            }
        }

        if (questions.isEmpty()) {
            request.setAttribute("message", "Please provide at least one question for the quiz.");
            request.setAttribute("messageType", "danger");
            doGet(request, response);
            return;
        }

        Quiz quiz = new Quiz();
        quiz.setTitle(title.trim());
        quiz.setDescription(description != null ? description.trim() : null);
        quiz.setClassId(Integer.parseInt(classIdParam));
        quiz.setSubjectId(Integer.parseInt(subjectIdParam));
        quiz.setLanguage(language);
        if (timeLimitParam != null && !timeLimitParam.isBlank()) {
            try {
                quiz.setTimeLimitMinutes(Integer.parseInt(timeLimitParam));
            } catch (NumberFormatException ignored) {
            }
        }
        quiz.setCreatedBy(user.getId());

        QuizDAO quizDAO = new QuizDAO();
        int quizId = quizDAO.createQuiz(quiz);
        if (quizId > 0) {
            for (QuizQuestion question : questions) {
                quizDAO.addQuestion(quizId, question);
            }
            request.setAttribute("message", "Quiz created successfully.");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Failed to create quiz. Please try again.");
            request.setAttribute("messageType", "danger");
        }
        doGet(request, response);
    }
}
