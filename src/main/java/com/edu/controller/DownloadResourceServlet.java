// File: src/main/java/com/edu/controller/DownloadResourceServlet.java
package com.edu.controller;

import com.edu.dao.resourceDAO;
import com.edu.model.Resource;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/download-resource")
public class DownloadResourceServlet extends HttpServlet {
    
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
        
        // Get the file path
        String filePath = getServletContext().getRealPath("") + File.separator + resource.getFileLink();
        File file = new File(filePath);
        
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }
        
        // Set response headers
        String fileName = resource.getFileLink().substring(resource.getFileLink().lastIndexOf('/') + 1);
        String contentType;
        
        if (resource.getType().equals("PDF")) {
            contentType = "application/pdf";
        } else if (resource.getType().equals("Video")) {
            contentType = "video/mp4";
        } else {
            contentType = "application/octet-stream";
        }
        
        response.setContentType(contentType);
        response.setContentLength((int) file.length());
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        // Stream the file to the client
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
