// File: src/main/java/com/edu/controller/DownloadResourceServlet.java
package com.edu.controller;

import com.edu.dao.resourceDAO;
import com.edu.model.Resource;
import com.edu.model.User;
import com.edu.util.FileStorageUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet("/download-resource")
public class DownloadResourceServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
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

        String fileLink = resource.getFileLink();
        if (fileLink == null || fileLink.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource file not available");
            return;
        }

        if (isExternalLink(fileLink)) {
            response.sendRedirect(fileLink);
            return;
        }
        
        Path filePath = FileStorageUtil.resolveAbsolutePath(resource.getFileLink(), getServletContext());
        if (filePath == null || !Files.exists(filePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }
        
        // Set response headers
        String fileName = filePath.getFileName().toString();
        String contentType;
        
        if (resource.getType().equals("PDF")) {
            contentType = "application/pdf";
        } else if (resource.getType().equals("Video")) {
            contentType = "video/mp4";
        } else {
            contentType = "application/octet-stream";
        }
        
        response.setContentType(contentType);
        response.setContentLengthLong(Files.size(filePath));
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        // Stream the file to the client
        try (InputStream in = Files.newInputStream(filePath);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }

    private boolean isExternalLink(String fileLink) {
        String lower = fileLink.toLowerCase();
        return lower.startsWith("http://") || lower.startsWith("https://");
    }
}
