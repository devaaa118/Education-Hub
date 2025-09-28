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

@WebServlet("/resources")
public class ListResourcesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        resourceDAO resourceDAO = new resourceDAO();

        // Get filter/search parameters
    String search = request.getParameter("search");
    String grade = request.getParameter("grade");
    String subject = request.getParameter("subject");
    String type = request.getParameter("type");
    String language = request.getParameter("language");
    String stream = request.getParameter("stream");

        boolean filterApplied = (search != null && !search.isEmpty()) ||
                (grade != null && !grade.isEmpty()) ||
                (type != null && !type.isEmpty()) ||
                (language != null && !language.isEmpty()) ||
                (stream != null && !stream.isEmpty());

        String userGrade = null;
        try {
            java.lang.reflect.Method getGradeMethod = user.getClass().getMethod("getGrade");
            Object gradeObj = getGradeMethod.invoke(user);
            if (gradeObj != null) userGrade = gradeObj.toString();
        } catch (Exception e) {
            userGrade = null;
        }

        if (!filterApplied) {
            grade = userGrade;
            stream = null;
        }

        List<String> grades = resourceDAO.getUniqueGrades();
        request.setAttribute("grades", grades);
        request.setAttribute("userGrade", userGrade);

        List<String> subjectsForDisplay;
        if (grade != null && !grade.isEmpty()) {
            subjectsForDisplay = resourceDAO.getSubjectsForGrade(grade, stream);
        } else {
            subjectsForDisplay = resourceDAO.getUniqueSubjects();
        }
        request.setAttribute("subjects", subjectsForDisplay);

        List<Resource> flatResources = resourceDAO.getFilteredResources(grade, subject, type, language, stream);
        if (search != null && !search.isEmpty()) {
            String searchLower = search.toLowerCase();
            flatResources.removeIf(r -> !(r.getTitle().toLowerCase().contains(searchLower)
                    || r.getSubject().toLowerCase().contains(searchLower)));
        }

        request.setAttribute("resources", flatResources);

        List<String> streams = null;
        try {
            int gradeInt = (grade != null && !grade.isEmpty()) ? Integer.parseInt(grade) : -1;
            if (gradeInt == 11 || gradeInt == 12) {
                streams = resourceDAO.getStreamsForGrade(gradeInt);
            }
        } catch (NumberFormatException e) { /* ignore */ }
        request.setAttribute("streams", streams);
        request.setAttribute("selectedStream", stream);

        request.getRequestDispatcher("/views/resources.jsp").forward(request, response);
    }
}
