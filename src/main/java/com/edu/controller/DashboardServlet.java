// File: src/main/java/com/edu/controller/DashboardServlet.java
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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
    private static final int PAGE_SIZE = 9; // Number of resources per page
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
response.sendRedirect(request.getContextPath() + "/views/teacherLogin.jsp");
            return;
        }
        
        resourceDAO resourceDAO = new resourceDAO();
        
        if ("teacher".equals(user.getRole())) {
            // For teachers, show their uploaded resources
            List<Resource> recentResources = resourceDAO.getResourcesByUserId(user.getId());
            int resourceCount = recentResources.size();
            
            request.setAttribute("recentResources", recentResources);
            request.setAttribute("resourceCount", resourceCount);
        } else if ("student".equals(user.getRole())) {
            // For students, show available resources with filters
            
            // Get filter parameters
            String grade = request.getParameter("grade");
            String subject = request.getParameter("subject");
            String type = request.getParameter("type");
            String language = request.getParameter("language");
            String search = request.getParameter("search");
            
            // Get page parameter
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    // Ignore and use default
                }
            }
            
            // Get resources based on filters
            List<Resource> resources;
            int totalResources;
            
            if (search != null && !search.isEmpty()) {
                // Search by keyword
                resources = resourceDAO.searchResources(search);
                totalResources = resources.size();
                
                // Apply pagination manually
                int fromIndex = (page - 1) * PAGE_SIZE;
                int toIndex = Math.min(fromIndex + PAGE_SIZE, resources.size());
                
                if (fromIndex < resources.size()) {
                    resources = resources.subList(fromIndex, toIndex);
                } else {
                    resources.clear();
                }
            } else if (grade != null || subject != null || type != null || language != null) {
                // Apply filters
                resources = resourceDAO.getFilteredResources(grade, subject, type, language);
                totalResources = resources.size();
                
                // Apply pagination manually
                int fromIndex = (page - 1) * PAGE_SIZE;
                int toIndex = Math.min(fromIndex + PAGE_SIZE, resources.size());
                
                if (fromIndex < resources.size()) {
                    resources = resources.subList(fromIndex, toIndex);
                } else {
                    resources.clear();
                }
            } else {
                // Get all resources with pagination
                totalResources = resourceDAO.countTotalResources();
                resources = resourceDAO.getResourcesWithPagination(page, PAGE_SIZE);
            }
            
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalResources / PAGE_SIZE);
            
            // Get unique grades and subjects for filters
            List<String> grades = resourceDAO.getUniqueGrades();
            List<String> subjects = resourceDAO.getUniqueSubjects();
            
            // Set attributes for the JSP
            request.setAttribute("resources", resources);
            request.setAttribute("grades", grades);
            request.setAttribute("subjects", subjects);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
        }
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
