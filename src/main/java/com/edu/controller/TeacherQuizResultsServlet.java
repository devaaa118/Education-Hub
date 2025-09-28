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
import java.util.List;

@WebServlet("/teacher/quiz/results")
public class TeacherQuizResultsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        Long quizId = parseLong(request.getParameter("id"));
        if (quizId == null) {
            response.sendRedirect(request.getContextPath() + "/teacher/quizzes?error=invalidQuiz");
            return;
        }

        QuizDAO quizDAO = new QuizDAO();
        Quiz quiz = quizDAO.getQuizWithQuestions(quizId);
        if (quiz == null || quiz.getCreatedBy() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/teacher/quizzes?error=missingQuiz");
            return;
        }

        List<QuizAttempt> attempts = quizDAO.getAttemptsForQuiz(quizId);

        int totalScore = 0;
        int totalCorrect = 0;
        int totalQuestions = 0;
        QuizAttempt topAttempt = null;
        for (QuizAttempt attempt : attempts) {
            totalScore += attempt.getScore();
            totalCorrect += attempt.getCorrectAnswers();
            totalQuestions += attempt.getTotalQuestions();
            if (topAttempt == null || attempt.getScore() > topAttempt.getScore()) {
                topAttempt = attempt;
            }
        }

        int maxScore = 0;
        if (quiz.getQuestions() != null) {
            for (QuizQuestion question : quiz.getQuestions()) {
                maxScore += question.getMarks();
            }
        }

        double averageScore = attempts.isEmpty() ? 0 : (double) totalScore / attempts.size();
        double averageAccuracy = totalQuestions == 0 ? 0 : ((double) totalCorrect / totalQuestions) * 100;

        request.setAttribute("quiz", quiz);
        request.setAttribute("attempts", attempts);
        request.setAttribute("maxScore", maxScore);
        request.setAttribute("averageScore", averageScore);
        request.setAttribute("averageAccuracy", averageAccuracy);
        request.setAttribute("topAttempt", topAttempt);

        request.getRequestDispatcher("/views/teacherQuizResults.jsp").forward(request, response);
    }

    private Long parseLong(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Long.parseLong(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
