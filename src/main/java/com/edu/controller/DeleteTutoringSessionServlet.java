package com.edu.controller;

import com.edu.dao.TutoringSessionDAO;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/teacher/tutoring/delete")
public class DeleteTutoringSessionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                long sessionId = Long.parseLong(idParam);
                TutoringSessionDAO dao = new TutoringSessionDAO();
                dao.deleteSession(sessionId, user.getId());
            } catch (NumberFormatException ignored) {
            }
        }
        response.sendRedirect(request.getContextPath() + "/teacher/tutoring");
    }
}
