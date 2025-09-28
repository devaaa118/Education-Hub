package com.edu.controller;

import com.edu.dao.QuizDAO;
import com.edu.model.Quiz;
import com.edu.model.QuizAttempt;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student/quizzes")
public class StudentQuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        QuizDAO quizDAO = new QuizDAO();
        List<Quiz> quizzes = quizDAO.getQuizzesForStudent(user.getId());
        List<QuizAttempt> attempts = quizDAO.getAttemptsForStudent(user.getId());
        Map<Long, QuizAttempt> latestAttemptByQuiz = new HashMap<>();
        for (QuizAttempt attempt : attempts) {
            latestAttemptByQuiz.putIfAbsent(attempt.getQuizId(), attempt);
        }
        request.setAttribute("quizzes", quizzes);
        request.setAttribute("attempts", latestAttemptByQuiz);
        request.getRequestDispatcher("/views/studentQuizzes.jsp").forward(request, response);
    }
}
