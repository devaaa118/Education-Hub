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

@WebServlet("/delete-resource")
public class DeleteResourceServlet extends HttpServlet {

    private final resourceDAO resourceDao = new resourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        Integer resourceId = parseId(request.getParameter("id"));
        if (resourceId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid resource id");
            return;
        }

        Resource resource = resourceDao.getResourceByIdAndUser(resourceId, user.getId());
        if (resource == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
            return;
        }

        boolean deleted = resourceDao.deleteResource(resourceId, user.getId());
        if (deleted && resource.getFileLink() != null) {
            FileStorageUtil.deleteFile(resource.getFileLink(), getServletContext());
        }

        response.sendRedirect(request.getContextPath() + "/my-resources?deleted=" + (deleted ? "1" : "0"));
    }

    private Integer parseId(String idParam) {
        if (idParam == null || idParam.isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
