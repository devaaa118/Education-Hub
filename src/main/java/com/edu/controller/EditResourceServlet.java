package com.edu.controller;

import com.edu.dao.resourceDAO;
import com.edu.model.Resource;
import com.edu.model.User;
import com.edu.util.FileStorageUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/edit-resource")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 50,
        maxRequestSize = 1024 * 1024 * 60
)
public class EditResourceServlet extends HttpServlet {

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

        request.setAttribute("resource", resource);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/editResource.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        Resource existing = resourceDao.getResourceByIdAndUser(resourceId, user.getId());
        if (existing == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
            return;
        }

        String title = request.getParameter("title");
        String grade = request.getParameter("grade");
        String subject = request.getParameter("subject");
        String type = request.getParameter("type");
        String language = request.getParameter("language");

        Part filePart = request.getPart("resourceFile");
        boolean hasNewFile = filePart != null && filePart.getSize() > 0;
        String newRelativePath = null;

        if (hasNewFile) {
            String fileName = getSubmittedFileName(filePart);
            if (!isValidFileType(fileName, type)) {
                applyFormValues(existing, title, grade, subject, type, language, existing.getFileLink());
                request.setAttribute("message", "Invalid file type for the selected resource type.");
                request.setAttribute("messageType", "danger");
                request.setAttribute("resource", existing);
                request.getRequestDispatcher("/views/editResource.jsp").forward(request, response);
                return;
            }
            try {
                newRelativePath = FileStorageUtil.storeFile(filePart, fileName, getServletContext());
            } catch (IOException e) {
                applyFormValues(existing, title, grade, subject, type, language, existing.getFileLink());
                request.setAttribute("message", "Failed to save the uploaded file. Please try again.");
                request.setAttribute("messageType", "danger");
                request.setAttribute("resource", existing);
                request.getRequestDispatcher("/views/editResource.jsp").forward(request, response);
                return;
            }
        }

        Resource updated = new Resource();
        updated.setId(existing.getId());
        updated.setUploadedBy(user.getId());
        updated.setTitle(title);
        updated.setGrade(grade);
        updated.setSubject(subject);
        updated.setType(type);
        updated.setLanguage(language);
        updated.setVerified(true);
        updated.setVerifiedBy(user.getId());
        updated.setVerifiedAt(new Timestamp(System.currentTimeMillis()));
        if (hasNewFile) {
            updated.setFileLink(newRelativePath);
        }

        boolean success = resourceDao.updateResource(updated);
        if (!success) {
            if (hasNewFile && newRelativePath != null) {
                FileStorageUtil.deleteFile(newRelativePath, getServletContext());
            }
            applyFormValues(existing, title, grade, subject, type, language, existing.getFileLink());
            request.setAttribute("message", "Unable to update resource. Please try again.");
            request.setAttribute("messageType", "danger");
            request.setAttribute("resource", existing);
            request.getRequestDispatcher("/views/editResource.jsp").forward(request, response);
            return;
        }

        if (hasNewFile && existing.getFileLink() != null) {
            FileStorageUtil.deleteFile(existing.getFileLink(), getServletContext());
        }

        response.sendRedirect(request.getContextPath() + "/my-resources?updated=1");
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

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) {
            return "";
        }
        for (String item : contentDisp.split(";")) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "";
    }

    private boolean isValidFileType(String fileName, String resourceType) {
        if (fileName == null || !fileName.contains(".")) {
            return false;
        }
        String fileExtension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        switch (resourceType) {
            case "PDF":
                return "pdf".equals(fileExtension);
            case "Video":
                return "mp4".equals(fileExtension) || "webm".equals(fileExtension) || "mov".equals(fileExtension);
            case "Quiz":
                return "pdf".equals(fileExtension) || "docx".equals(fileExtension) || "txt".equals(fileExtension);
            default:
                return false;
        }
    }

    private void applyFormValues(Resource resource, String title, String grade, String subject,
                                 String type, String language, String fileLink) {
        resource.setTitle(title);
        resource.setGrade(grade);
        resource.setSubject(subject);
        resource.setType(type);
        resource.setLanguage(language);
        if (fileLink != null) {
            resource.setFileLink(fileLink);
        }
    }
}
