package com.edu.controller;

import com.edu.dao.ResourceProgressDAO;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/updateResourceProgress")
public class UpdateResourceProgressServlet extends HttpServlet {

    private static final Set<String> ALLOWED_STATUSES = new HashSet<>(Arrays.asList("NOT_STARTED", "IN_PROGRESS", "COMPLETED"));

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        String subject = request.getParameter("subject");
        String resourceIdParam = request.getParameter("resourceId");
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");

        int resourceId;
        try {
            resourceId = Integer.parseInt(resourceIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/studentDashboard");
            return;
        }

        if (status == null || !ALLOWED_STATUSES.contains(status.toUpperCase())) {
            status = "NOT_STARTED";
        } else {
            status = status.toUpperCase();
        }

        if (notes != null) {
            notes = notes.trim();
            if (notes.isEmpty()) {
                notes = null;
            }
        }

        ResourceProgressDAO progressDAO = new ResourceProgressDAO();
        progressDAO.upsertProgress(user.getId(), resourceId, status, notes, true);

        String redirectSubject = subject != null && !subject.isEmpty() ? subject : request.getParameter("fallbackSubject");
        if (redirectSubject != null && !redirectSubject.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/studentSubjectResources?subject=" + java.net.URLEncoder.encode(redirectSubject, java.nio.charset.StandardCharsets.UTF_8));
        } else {
            response.sendRedirect(request.getContextPath() + "/studentDashboard");
        }
    }
}
