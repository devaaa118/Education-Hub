// File: src/main/java/com/edu/controller/UploadResourceServlet.java
package com.edu.controller;

import com.edu.dao.resourceDAO;
import com.edu.model.ClassInfo;
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
import java.util.List;
import java.util.Map;

@WebServlet("/upload-resource")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 50,       // 50MB
    maxRequestSize = 1024 * 1024 * 60     // 60MB
)
public class UploadResourceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in and is a teacher
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        resourceDAO dao = new resourceDAO();
        List<ClassInfo> classes = dao.getAllClasses();
        Map<Integer, List<String>> subjectsByClass = dao.getSubjectsByClass();
        prepareFormData(request, classes, subjectsByClass);
        request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in and is a teacher
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        resourceDAO dao = new resourceDAO();
        List<ClassInfo> classes = dao.getAllClasses();
        Map<Integer, List<String>> subjectsByClass = dao.getSubjectsByClass();
        prepareFormData(request, classes, subjectsByClass);

        String title = request.getParameter("title");
        String grade = trimToNull(request.getParameter("grade"));
        String subject = trimToNull(request.getParameter("subject"));
        String type = request.getParameter("type");
        String language = request.getParameter("language");
        String resourceUrl = trimToNull(request.getParameter("resourceUrl"));
        
        Part filePart = request.getPart("resourceFile");
        boolean hasFile = filePart != null && filePart.getSize() > 0;
        boolean hasUrl = resourceUrl != null;

        storeFormValues(request, title, grade, subject, type, language, resourceUrl);

        Integer gradeId = null;
        if (grade != null) {
            try {
                gradeId = Integer.valueOf(grade);
            } catch (NumberFormatException ex) {
                gradeId = null;
            }
        }

        if (gradeId == null || !subjectsByClass.containsKey(gradeId)) {
            request.setAttribute("message", "Please select a valid class before uploading.");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
            return;
        }

        List<String> availableSubjects = subjectsByClass.get(gradeId);
        if (subject == null || availableSubjects == null || !availableSubjects.contains(subject)) {
            request.setAttribute("message", "Please select a valid subject before uploading.");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
            return;
        }

        if (!hasFile && !hasUrl) {
            request.setAttribute("message", "Please select a file or provide a resource URL.");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
            return;
        }

        String storedRelativePath = null;
        if (hasFile) {
            String fileName = getSubmittedFileName(filePart);
            if (!isValidFileType(fileName, type)) {
                request.setAttribute("message", "Invalid file type for the selected resource type.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
                return;
            }

            try {
                storedRelativePath = FileStorageUtil.storeFile(filePart, fileName, getServletContext());
            } catch (IOException e) {
                request.setAttribute("message", "Failed to save file. Please try again.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
                return;
            }
        }

        if (!hasFile && hasUrl && !isValidUrl(resourceUrl)) {
            request.setAttribute("message", "Please provide a valid URL (must start with http or https).");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
            return;
        }

        Resource resource = new Resource();
        resource.setTitle(title);
        resource.setGrade(String.valueOf(gradeId));
        resource.setSubject(subject);
        resource.setType(type);
        resource.setLanguage(language);
        resource.setFileLink(hasFile ? storedRelativePath : resourceUrl);
        resource.setUploadedBy(user.getId());
    resource.setVerified(true);
    resource.setVerifiedBy(user.getId());
    resource.setVerifiedAt(new Timestamp(System.currentTimeMillis()));
  
    // Save the resource to the database
    int resourceId = dao.insertResource(resource);
        
        if (resourceId > 0) {
            // Success
            request.setAttribute("message", "Resource uploaded successfully!");
            request.setAttribute("messageType", "success");
            clearFormValues(request);
        } else {
            // Error
            request.setAttribute("message", "Failed to upload resource. Please try again.");
            request.setAttribute("messageType", "danger");
        }
        
        request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
    }
    
    // Helper method to get the submitted file name
    private String getSubmittedFileName(Part part) {
        if (part == null) {
            return "";
        }
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) {
            return "";
        }
        String[] items = contentDisp.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                String fileName = item.substring(item.indexOf('=') + 1).trim().replace("\"", "");
                return fileName;
            }
        }
        return "";
    }
    
    // Helper method to validate file type
    private boolean isValidFileType(String fileName, String resourceType) {
        if (fileName == null || !fileName.contains(".")) {
            return false;
        }
        String fileExtension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        
        switch (resourceType) {
            case "PDF":
                return fileExtension.equals("pdf");
            case "Video":
                return fileExtension.equals("mp4") || fileExtension.equals("webm") || fileExtension.equals("mov");
            case "Quiz":
                return fileExtension.equals("pdf") || fileExtension.equals("docx") || fileExtension.equals("txt");
            default:
                return false;
        }
    }

    private boolean isValidUrl(String resourceUrl) {
        String lower = resourceUrl.toLowerCase();
        return lower.startsWith("http://") || lower.startsWith("https://");
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void prepareFormData(HttpServletRequest request, List<ClassInfo> classes, Map<Integer, List<String>> subjectsByClass) {
        for (ClassInfo classInfo : classes) {
            subjectsByClass.computeIfAbsent(classInfo.getId(), key -> new java.util.ArrayList<>());
        }
        request.setAttribute("classOptions", classes);
        request.setAttribute("subjectsByClass", subjectsByClass);
    }

    private void storeFormValues(HttpServletRequest request, String title, String grade, String subject,
                                 String type, String language, String resourceUrl) {
        request.setAttribute("formTitle", title);
        request.setAttribute("formGrade", grade);
        request.setAttribute("formSubject", subject);
        request.setAttribute("formType", type);
        request.setAttribute("formLanguage", language);
        request.setAttribute("formResourceUrl", resourceUrl);
    }

    private void clearFormValues(HttpServletRequest request) {
        storeFormValues(request, "", "", "", "", "", "");
    }
}
