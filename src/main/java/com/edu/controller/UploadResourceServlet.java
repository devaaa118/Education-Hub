// File: src/main/java/com/edu/controller/UploadResourceServlet.java
package com.edu.controller;

import com.edu.dao.resourceDAO;
import com.edu.model.Resource;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/upload-resource")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 50,       // 50MB
    maxRequestSize = 1024 * 1024 * 60     // 60MB
)
public class UploadResourceServlet extends HttpServlet {
    
    private static final String UPLOAD_DIRECTORY = "WEB-INF/uploads";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in and is a teacher
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equals(user.getRole())) {response.sendRedirect(request.getContextPath() + "/views/teacherLogin.jsp");

            return;
        }
        
        // Forward to the upload form
        request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in and is a teacher
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get form parameters
        String title = request.getParameter("title");
        String grade = request.getParameter("grade");
        String subject = request.getParameter("subject");
        String type = request.getParameter("type");
        String language = request.getParameter("language");
        
        // Get the uploaded file
        Part filePart = request.getPart("resourceFile");
        String fileName = getSubmittedFileName(filePart);
        
        // Validate file type based on the selected resource type
        if (!isValidFileType(fileName, type)) {
            request.setAttribute("message", "Invalid file type for the selected resource type.");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
            return;
        }
        
        // Create upload directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Generate a unique file name to prevent overwriting
        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
        String filePath = uploadPath + File.separator + uniqueFileName;
        
        // Save the file
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
        }
        
   // In the doPost method of UploadResourceServlet, update the resource creation:
Resource resource = new Resource();
resource.setTitle(title);
resource.setGrade(grade);
resource.setSubject(subject);
resource.setType(type);
resource.setLanguage(language);
resource.setFileLink(UPLOAD_DIRECTORY + "/" + uniqueFileName);
resource.setUploadedBy(user.getId());  // Set the user ID as the uploader
  
        // Save the resource to the database
        resourceDAO resourceDAO = new resourceDAO();
        int resourceId = resourceDAO.insertResource(resource);
        
        if (resourceId > 0) {
            // Success
            request.setAttribute("message", "Resource uploaded successfully!");
            request.setAttribute("messageType", "success");
        } else {
            // Error
            request.setAttribute("message", "Failed to upload resource. Please try again.");
            request.setAttribute("messageType", "danger");
        }
        
        request.getRequestDispatcher("/views/uploadResource.jsp").forward(request, response);
    }
    
    // Helper method to get the submitted file name
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return "";
    }
    
    // Helper method to validate file type
    private boolean isValidFileType(String fileName, String resourceType) {
        String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        
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
}
