// File: src/main/java/com/edu/controller/ViewResourceServlet.java
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

@WebServlet("/view-resource")
public class ViewResourceServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/studentLogin.jsp");
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
        
        if ("student".equalsIgnoreCase(user.getRole())) {
            ResourceProgressDAO progressDAO = new ResourceProgressDAO();
            ResourceProgress existingProgress = progressDAO.getProgress(user.getId(), resourceId);
            String statusToPersist = "IN_PROGRESS";
            String notesToPersist = null;
            if (existingProgress != null) {
                notesToPersist = existingProgress.getNotes();
                if (existingProgress.getStatus() != null) {
                    if ("COMPLETED".equalsIgnoreCase(existingProgress.getStatus())) {
                        statusToPersist = "COMPLETED";
                    } else if (!"NOT_STARTED".equalsIgnoreCase(existingProgress.getStatus())) {
                        statusToPersist = existingProgress.getStatus().toUpperCase();
                    }
                }
            }
            progressDAO.upsertProgress(user.getId(), resourceId, statusToPersist, notesToPersist, true);
        }

        // Set resource as request attribute
        request.setAttribute("resource", resource);
        
        // Forward to the view resource page
        request.getRequestDispatcher("/views/viewResource.jsp").forward(request, response);
    }
}
