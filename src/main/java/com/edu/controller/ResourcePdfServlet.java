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
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet("/resource/stream")
public class ResourcePdfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/studentLogin.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Resource id is required");
            return;
        }

        int resourceId;
        try {
            resourceId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid resource id");
            return;
        }

        resourceDAO dao = new resourceDAO();
        Resource resource = dao.getResourceById(resourceId);
        if (resource == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
            return;
        }

        String fileLink = resource.getFileLink();
        if (fileLink == null || fileLink.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource file not available");
            return;
        }

        // If external, redirect to external URL
        String lower = fileLink.toLowerCase();
        if (lower.startsWith("http://") || lower.startsWith("https://")) {
            response.sendRedirect(fileLink);
            return;
        }

        Path filePath = FileStorageUtil.resolveAbsolutePath(fileLink, getServletContext());
        if (filePath == null || !Files.exists(filePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        // Stream PDF inline
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"" + filePath.getFileName().toString() + "\"");
        response.setContentLengthLong(Files.size(filePath));

        try (InputStream in = Files.newInputStream(filePath); OutputStream out = response.getOutputStream()) {
            byte[] buf = new byte[8192];
            int len;
            while ((len = in.read(buf)) != -1) {
                out.write(buf, 0, len);
            }
        }
    }
}
