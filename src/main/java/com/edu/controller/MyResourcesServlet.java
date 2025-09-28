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
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/my-resources")
public class MyResourcesServlet extends HttpServlet {

    private final resourceDAO resourceDao = new resourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        String grade = trimParam(request.getParameter("grade"));
        String subject = trimParam(request.getParameter("subject"));
        String type = trimParam(request.getParameter("type"));
        String language = trimParam(request.getParameter("language"));

        List<Resource> allResources = resourceDao.getResourcesByUserId(user.getId());
        List<Resource> filteredResources = resourceDao.getResourcesByUserId(user.getId(), grade, subject, type, language);

        request.setAttribute("resources", filteredResources);
        request.setAttribute("gradeOptions", extractGrades(allResources));
        request.setAttribute("subjectOptions", extractSubjects(allResources));
        request.setAttribute("typeOptions", extractTypes(allResources));
        request.setAttribute("languageOptions", extractLanguages(allResources));
        request.setAttribute("user", user);

        request.getRequestDispatcher("/views/myResources.jsp").forward(request, response);
    }

    private String trimParam(String value) {
        if (value == null) {
            return null;
        }
        value = value.trim();
        return value.isEmpty() ? null : value;
    }

    private Set<String> extractGrades(List<Resource> resources) {
        Set<String> grades = new LinkedHashSet<>();
        for (Resource resource : resources) {
            grades.add(resource.getGrade());
        }
        return grades;
    }

    private Set<String> extractSubjects(List<Resource> resources) {
        Set<String> subjects = new LinkedHashSet<>();
        for (Resource resource : resources) {
            subjects.add(resource.getSubject());
        }
        return subjects;
    }

    private Set<String> extractTypes(List<Resource> resources) {
        Set<String> types = new LinkedHashSet<>();
        for (Resource resource : resources) {
            types.add(resource.getType());
        }
        return types;
    }

    private Set<String> extractLanguages(List<Resource> resources) {
        Set<String> languages = new LinkedHashSet<>();
        for (Resource resource : resources) {
            languages.add(resource.getLanguage());
        }
        return languages;
    }
}
