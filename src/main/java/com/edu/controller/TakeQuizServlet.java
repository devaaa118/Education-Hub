package com.edu.controller;

import com.edu.dao.QuizDAO;
import com.edu.model.Quiz;
import com.edu.model.QuizAttempt;
import com.edu.model.QuizQuestion;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/take-quiz")
public class TakeQuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        String quizIdParam = request.getParameter("quizId");
        if (quizIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }

        long quizId;
        try {
            quizId = Long.parseLong(quizIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }

        QuizDAO quizDAO = new QuizDAO();
        Quiz quiz = quizDAO.getQuizWithQuestions(quizId);
        if (quiz == null) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }

        Integer classId = quizDAO.getClassIdForStudent(user.getId());
        if (classId == null || classId != quiz.getClassId()) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }

        request.setAttribute("quiz", quiz);
        request.getRequestDispatcher("/views/takeQuiz.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        String quizIdParam = request.getParameter("quizId");
        if (quizIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }

        long quizId;
        try {
            quizId = Long.parseLong(quizIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }

        QuizDAO quizDAO = new QuizDAO();
        Quiz quiz = quizDAO.getQuizWithQuestions(quizId);
        if (quiz == null) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }

        Integer classId = quizDAO.getClassIdForStudent(user.getId());
        if (classId == null || classId != quiz.getClassId()) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }

        List<QuizQuestion> questions = quiz.getQuestions();
        if (questions == null || questions.isEmpty()) {
            request.setAttribute("quiz", quiz);
            request.setAttribute("message", "Quiz currently has no questions.");
            request.setAttribute("messageType", "warning");
            request.getRequestDispatcher("/views/takeQuiz.jsp").forward(request, response);
            return;
        }

        int totalMarks = questions.stream().mapToInt(QuizQuestion::getMarks).sum();
        int correctAnswers = 0;
        int score = 0;
        Map<Long, String> responses = new HashMap<>();

        for (QuizQuestion question : questions) {
            String paramName = "answer_" + question.getId();
            String selectedOption = request.getParameter(paramName);
            if (selectedOption != null) {
                selectedOption = selectedOption.trim();
            }
            responses.put(question.getId(), selectedOption != null ? selectedOption : "");
            if (selectedOption != null && selectedOption.equalsIgnoreCase(question.getCorrectOption())) {
                correctAnswers++;
                score += question.getMarks();
            }
        }

        String responsesJson = responses.entrySet().stream()
                .map(entry -> "\"" + entry.getKey() + "\":\"" + entry.getValue() + "\"")
                .collect(Collectors.joining(",", "{", "}"));

        QuizAttempt attempt = new QuizAttempt();
        attempt.setQuizId(quizId);
        attempt.setStudentId(user.getId());
        attempt.setScore(score);
        attempt.setTotalQuestions(questions.size());
        attempt.setCorrectAnswers(correctAnswers);
        attempt.setResponsesJson(responsesJson);
        attempt.setAttemptedAt(new Timestamp(System.currentTimeMillis()));
        quizDAO.recordAttempt(attempt);

        request.setAttribute("quiz", quiz);
        request.setAttribute("submitted", true);
        request.setAttribute("score", score);
        request.setAttribute("totalMarks", totalMarks);
        request.setAttribute("correctAnswers", correctAnswers);
        request.setAttribute("totalQuestions", questions.size());
        request.setAttribute("responses", responses);
        request.getRequestDispatcher("/views/takeQuiz.jsp").forward(request, response);
    }
}
