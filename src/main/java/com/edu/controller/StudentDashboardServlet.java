package com.edu.controller;

import com.edu.dao.resourceDAO;
import com.edu.model.Resource;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/studentDashboard")
public class StudentDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        resourceDAO dao = new resourceDAO();
        List<String> subjects = dao.getSubjectsForStudent(user.getId());
        request.setAttribute("subjects", subjects);

        String subject = request.getParameter("subject");
        List<Resource> resources = null;
        if (subject != null && !subject.isEmpty()) {
            resources = dao.getResourcesForStudentBySubject(user.getId(), subject);
        }
        request.setAttribute("selectedSubject", subject);
        request.setAttribute("resources", resources);

        request.getRequestDispatcher("/views/studentDashboard.jsp").forward(request, response);
    }
}