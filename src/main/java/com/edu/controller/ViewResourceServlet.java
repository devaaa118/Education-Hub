// File: src/main/java/com/edu/controller/ViewResourceServlet.java
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

@WebServlet("/view-resource")
public class ViewResourceServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            if ("teacher".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/views/teacherLogin.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/studentLogin.jsp");
            }
            return;
        }
        
        // Get resource ID from request
        String resourceIdParam = request.getParameter("id");
        if (resourceIdParam == null || resourceIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Resource ID is required");
            return;
        }
        
        int resourceId;
        try {
            resourceId = Integer.parseInt(resourceIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid resource ID");
            return;
        }
        
        // Get resource from database
        resourceDAO resourceDAO = new resourceDAO();
        Resource resource = resourceDAO.getResourceById(resourceId);
        
        if (resource == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
            return;
        }
        
        // Set resource as request attribute
        request.setAttribute("resource", resource);
        
        // Forward to the view resource page
        request.getRequestDispatcher("/views/viewResource.jsp").forward(request, response);
    }
}
