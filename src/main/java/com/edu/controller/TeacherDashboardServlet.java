package com.edu.controller;

import com.edu.dao.resourceDAO;
import com.edu.model.Resource;
import com.edu.model.ResourceStat;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/teacherDashboard")
public class TeacherDashboardServlet extends HttpServlet {

    private static final int RECENT_LIMIT = 6;
    private final resourceDAO resourceDao = new resourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        int resourceCount = resourceDao.countResourcesByUserId(user.getId());
        List<Resource> recentResources = resourceDao.getRecentResourcesByUserId(user.getId(), RECENT_LIMIT);
        List<ResourceStat> subjectStats = resourceDao.getSubjectStatsForTeacher(user.getId());
        List<ResourceStat> gradeStats = resourceDao.getGradeStatsForTeacher(user.getId());

        request.setAttribute("user", user);
        request.setAttribute("resourceCount", resourceCount);
        request.setAttribute("recentResources", recentResources);
        request.setAttribute("subjectStats", subjectStats);
        request.setAttribute("gradeStats", gradeStats);

        request.getRequestDispatcher("/views/teacherDashboard.jsp").forward(request, response);
    }
}
