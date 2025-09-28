package com.edu.controller;

import com.edu.dao.ResourceProgressDAO;
import com.edu.dao.resourceDAO;
import com.edu.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
        List<String> subjects = null;
        Object cachedSubjects = request.getSession().getAttribute("studentSubjects");
        if (cachedSubjects instanceof List<?>) {
            subjects = ((List<?>) cachedSubjects).stream()
                    .map(Object::toString)
                    .collect(Collectors.toList());
        }
        if (subjects != null) {
            System.out.println("[DEBUG] Loaded subjects from session: " + subjects);
        } else {
            subjects = dao.getCoursesForStudent(user.getId());
            request.getSession().setAttribute("studentSubjects", subjects);
            System.out.println("[DEBUG] Loaded subjects from DB and stored in session: " + subjects);
        }

        request.setAttribute("subjects", subjects);

        // Pull stream name if available (from dynamic proxies / extended user models)
        String streamName = null;
        try {
            java.lang.reflect.Method getStreamMethod = user.getClass().getMethod("getStream");
            Object streamObj = getStreamMethod.invoke(user);
            if (streamObj != null) {
                streamName = String.valueOf(streamObj);
            }
        } catch (Exception ignored) {
            streamName = null;
        }
        request.setAttribute("streamName", streamName);

        ResourceProgressDAO progressDAO = new ResourceProgressDAO();
        Map<String, Integer> progressCounts = progressDAO.getStatusCounts(user.getId());
        request.setAttribute("progressCounts", progressCounts);
        request.setAttribute("statusOptions", Arrays.asList("NOT_STARTED", "IN_PROGRESS", "COMPLETED"));

        request.getRequestDispatcher("/views/studentDashboard.jsp").forward(request, response);
    }
}