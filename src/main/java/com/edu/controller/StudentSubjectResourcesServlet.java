package com.edu.controller;

import com.edu.dao.ResourceProgressDAO;
import com.edu.dao.resourceDAO;
import com.edu.model.Resource;
import com.edu.model.ResourceProgress;
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

@WebServlet("/studentSubjectResources")
public class StudentSubjectResourcesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        String subject = request.getParameter("subject");
        if (subject == null || subject.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/studentDashboard");
            return;
        }

        resourceDAO dao = new resourceDAO();
        List<Resource> resources = dao.getResourcesForStudentBySubject(user.getId(), subject);

        ResourceProgressDAO progressDAO = new ResourceProgressDAO();
        List<Integer> resourceIds = resources.stream().map(Resource::getId).collect(Collectors.toList());
        Map<Integer, ResourceProgress> progressMap = progressDAO.getProgressForStudent(user.getId(), resourceIds);
        List<String> statusOptions = Arrays.asList("NOT_STARTED", "IN_PROGRESS", "COMPLETED");

        String className = null;
        String streamName = null;
        try {
            java.lang.reflect.Method getGradeMethod = user.getClass().getMethod("getGrade");
            Object gradeObj = getGradeMethod.invoke(user);
            if (gradeObj != null) {
                className = "Grade " + gradeObj.toString();
            }
        } catch (Exception e) {
            className = null;
        }
        try {
            java.lang.reflect.Method getStreamMethod = user.getClass().getMethod("getStream");
            Object streamObj = getStreamMethod.invoke(user);
            if (streamObj != null && !streamObj.toString().isEmpty()) {
                streamName = streamObj.toString();
            }
        } catch (Exception e) {
            streamName = null;
        }

        request.setAttribute("subject", subject);
        request.setAttribute("resources", resources);
        request.setAttribute("progressMap", progressMap);
        request.setAttribute("statusOptions", statusOptions);
        request.setAttribute("className", className);
        request.setAttribute("streamName", streamName);
        request.getRequestDispatcher("/views/resourcesBySubject.jsp").forward(request, response);
    }
}