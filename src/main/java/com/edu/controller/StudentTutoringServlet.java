package com.edu.controller;

import com.edu.dao.TutoringSessionDAO;
import com.edu.model.TutoringSession;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/tutoring")
public class StudentTutoringServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        TutoringSessionDAO dao = new TutoringSessionDAO();
        List<TutoringSession> sessions = dao.getUpcomingSessionsForStudent(user.getId());
        request.setAttribute("sessions", sessions);
        request.getRequestDispatcher("/views/tutoringStudent.jsp").forward(request, response);
    }
}
