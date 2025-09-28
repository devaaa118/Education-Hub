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
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@WebServlet("/teacher/library")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 50,
        maxRequestSize = 1024 * 1024 * 60
)
public class TeacherResourceLibraryServlet extends HttpServlet {

    private final resourceDAO resourceDao = new resourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        Integer gradeId = parseInteger(request.getParameter("grade"));
        Integer streamId = parseInteger(request.getParameter("stream"));
        String subject = trimToNull(request.getParameter("subject"));

        List<ClassInfo> classOptions = resourceDao.getAllClasses();
        Map<Integer, List<String>> subjectsByClass = enrichSubjectsByClass(classOptions, resourceDao.getSubjectsByClass());

        applyFlashMessage(request);
        request.setAttribute("classOptions", classOptions);
        request.setAttribute("subjectsByClass", subjectsByClass);

        if (gradeId == null || !subjectsByClass.containsKey(gradeId)) {
            request.getRequestDispatcher("/views/teacherLibraryClasses.jsp").forward(request, response);
            return;
        }

        Map<Integer, String> streamOptions = resourceDao.getStreamsForClass(gradeId);
        boolean requiresStream = !streamOptions.isEmpty();

        request.setAttribute("selectedGrade", gradeId);
        request.setAttribute("selectedGradeName", resolveClassName(gradeId, classOptions));
        request.setAttribute("streams", streamOptions);

        if (requiresStream) {
            if (streamId == null || !streamOptions.containsKey(streamId)) {
                if (streamId != null && !streamOptions.containsKey(streamId)) {
                    setError(request, "Please choose a valid stream.");
                }
                request.getRequestDispatcher("/views/teacherLibraryStreams.jsp").forward(request, response);
                return;
            }
            request.setAttribute("selectedStream", streamId);
            request.setAttribute("selectedStreamName", streamOptions.get(streamId));
        } else {
            streamId = null;
        }

        List<String> subjects = resourceDao.getSubjectsForClassAndStream(gradeId, streamId);
        request.setAttribute("subjects", subjects);

        if (subject == null) {
            request.getRequestDispatcher("/views/teacherLibrarySubjects.jsp").forward(request, response);
            return;
        }

        if (!subjects.contains(subject)) {
            setError(request, "Please choose a valid subject.");
            request.getRequestDispatcher("/views/teacherLibrarySubjects.jsp").forward(request, response);
            return;
        }

        List<Resource> resources = resourceDao.getResourcesByUserId(user.getId(), String.valueOf(gradeId), subject, null, null, streamId);
        request.setAttribute("selectedSubject", subject);
        request.setAttribute("resources", resources);
        request.getRequestDispatcher("/views/teacherLibrary.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        Integer gradeId = parseInteger(request.getParameter("grade"));
        Integer streamId = parseInteger(request.getParameter("stream"));
        String subject = trimToNull(request.getParameter("subject"));
        String title = request.getParameter("title");
        String type = request.getParameter("type");
        String language = request.getParameter("language");
        String resourceUrl = trimToNull(request.getParameter("resourceUrl"));
        Part filePart = request.getPart("resourceFile");
        boolean hasFile = filePart != null && filePart.getSize() > 0;
        boolean hasUrl = resourceUrl != null;

        List<ClassInfo> classOptions = resourceDao.getAllClasses();
        Map<Integer, List<String>> subjectsByClass = enrichSubjectsByClass(classOptions, resourceDao.getSubjectsByClass());

        request.setAttribute("classOptions", classOptions);
        request.setAttribute("subjectsByClass", subjectsByClass);

        if (gradeId == null || !subjectsByClass.containsKey(gradeId)) {
            setError(request, "Please choose a class before uploading a resource.");
            storeFormValues(request, title, type, language, resourceUrl, streamId, subject);
            request.getRequestDispatcher("/views/teacherLibraryClasses.jsp").forward(request, response);
            return;
        }

        Map<Integer, String> streamOptions = resourceDao.getStreamsForClass(gradeId);
        boolean requiresStream = !streamOptions.isEmpty();

        request.setAttribute("selectedGrade", gradeId);
        request.setAttribute("selectedGradeName", resolveClassName(gradeId, classOptions));
        request.setAttribute("streams", streamOptions);

        if (requiresStream) {
            if (streamId == null || !streamOptions.containsKey(streamId)) {
                setError(request, "Please choose a stream before uploading a resource.");
                storeFormValues(request, title, type, language, resourceUrl, streamId, subject);
                request.getRequestDispatcher("/views/teacherLibraryStreams.jsp").forward(request, response);
                return;
            }
            request.setAttribute("selectedStream", streamId);
            request.setAttribute("selectedStreamName", streamOptions.get(streamId));
        } else {
            streamId = null;
        }

        List<String> subjects = resourceDao.getSubjectsForClassAndStream(gradeId, streamId);
        request.setAttribute("subjects", subjects);

        if (subject == null || !subjects.contains(subject)) {
            setError(request, "Please choose a subject before uploading a resource.");
            storeFormValues(request, title, type, language, resourceUrl, streamId, subject);
            request.getRequestDispatcher("/views/teacherLibrarySubjects.jsp").forward(request, response);
            return;
        }

        if (!hasFile && !hasUrl) {
            setError(request, "Please upload a file or provide a resource URL.");
            storeFormValues(request, title, type, language, resourceUrl, streamId, subject);
            request.setAttribute("showUploadModal", true);
            forwardToResourceView(request, response, classOptions, subjectsByClass, streamOptions, gradeId, streamId, subject, subjects, user);
            return;
        }

        if (hasUrl && !isValidUrl(resourceUrl)) {
            setError(request, "Please provide a valid URL that starts with http or https.");
            storeFormValues(request, title, type, language, resourceUrl, streamId, subject);
            request.setAttribute("showUploadModal", true);
            forwardToResourceView(request, response, classOptions, subjectsByClass, streamOptions, gradeId, streamId, subject, subjects, user);
            return;
        }

        String storedRelativePath = null;
        if (hasFile) {
            String fileName = getSubmittedFileName(filePart);
            if (!isValidFileType(fileName, type)) {
                setError(request, "Invalid file type for the selected resource type.");
                storeFormValues(request, title, type, language, resourceUrl, streamId, subject);
                request.setAttribute("showUploadModal", true);
                forwardToResourceView(request, response, classOptions, subjectsByClass, streamOptions, gradeId, streamId, subject, subjects, user);
                return;
            }

            try {
                storedRelativePath = FileStorageUtil.storeFile(filePart, fileName, getServletContext());
            } catch (IOException e) {
                setError(request, "Failed to save file. Please try again.");
                storeFormValues(request, title, type, language, resourceUrl, streamId, subject);
                request.setAttribute("showUploadModal", true);
                forwardToResourceView(request, response, classOptions, subjectsByClass, streamOptions, gradeId, streamId, subject, subjects, user);
                return;
            }
        }

        Resource resource = new Resource();
        resource.setTitle(title);
        resource.setGrade(String.valueOf(gradeId));
        resource.setSubject(subject);
        resource.setType(type);
        resource.setLanguage(language);
        resource.setUploadedBy(user.getId());
        resource.setStreamId(streamId);
        resource.setFileLink(hasFile ? storedRelativePath : resourceUrl);
    resource.setVerified(true);
    resource.setVerifiedBy(user.getId());
    resource.setVerifiedAt(new Timestamp(System.currentTimeMillis()));

        int resourceId = resourceDao.insertResource(resource);
        if (resourceId <= 0) {
            setError(request, "Failed to upload resource. Please try again.");
            if (hasFile && storedRelativePath != null) {
                FileStorageUtil.deleteFile(storedRelativePath, getServletContext());
            }
            storeFormValues(request, title, type, language, resourceUrl, streamId, subject);
            request.setAttribute("showUploadModal", true);
            forwardToResourceView(request, response, classOptions, subjectsByClass, streamOptions, gradeId, streamId, subject, subjects, user);
            return;
        }

        String redirectUrl = request.getContextPath() + "/teacher/library?grade=" + gradeId;
        if (streamId != null) {
            redirectUrl += "&stream=" + streamId;
        }
        redirectUrl += "&subject=" + encode(subject) + "&uploaded=1";
        response.sendRedirect(redirectUrl);
    }

    private void applyFlashMessage(HttpServletRequest request) {
        if (request.getAttribute("message") != null) {
            return;
        }
        if ("1".equals(request.getParameter("uploaded"))) {
            request.setAttribute("message", "Resource uploaded successfully!");
            request.setAttribute("messageType", "success");
        } else if (request.getParameter("error") != null) {
            request.setAttribute("message", request.getParameter("error"));
            request.setAttribute("messageType", "danger");
        }
    }

    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void setError(HttpServletRequest request, String message) {
        request.setAttribute("message", message);
        request.setAttribute("messageType", "danger");
    }

    private void storeFormValues(HttpServletRequest request, String title, String type, String language, String resourceUrl,
                                 Integer streamId, String subject) {
        request.setAttribute("formTitle", title);
        request.setAttribute("formType", type);
        request.setAttribute("formLanguage", language);
        request.setAttribute("formResourceUrl", resourceUrl);
        if (streamId != null) {
            request.setAttribute("formStreamId", streamId);
        }
        if (subject != null) {
            request.setAttribute("formSubject", subject);
        }
    }

    private Map<Integer, List<String>> enrichSubjectsByClass(List<ClassInfo> classOptions, Map<Integer, List<String>> subjectsByClass) {
        if (subjectsByClass == null) {
            subjectsByClass = new java.util.LinkedHashMap<>();
        }
        for (ClassInfo info : classOptions) {
            subjectsByClass.computeIfAbsent(info.getId(), key -> new ArrayList<>());
        }
        return subjectsByClass;
    }

    private void forwardToResourceView(HttpServletRequest request, HttpServletResponse response,
                                       List<ClassInfo> classOptions,
                                       Map<Integer, List<String>> subjectsByClass,
                                       Map<Integer, String> streamOptions,
                                       Integer gradeId,
                                       Integer streamId,
                                       String subject,
                                       List<String> subjectOptions,
                                       User user) throws ServletException, IOException {
        request.setAttribute("classOptions", classOptions);
        request.setAttribute("subjectsByClass", subjectsByClass);
        request.setAttribute("streams", streamOptions);
        request.setAttribute("selectedGrade", gradeId);
        request.setAttribute("selectedGradeName", resolveClassName(gradeId, classOptions));
        if (streamId != null) {
            request.setAttribute("selectedStream", streamId);
            request.setAttribute("selectedStreamName", streamOptions.get(streamId));
        }
        request.setAttribute("subjects", subjectOptions);
        request.setAttribute("selectedSubject", subject);

        List<Resource> resources = Collections.emptyList();
        if (user != null && gradeId != null && subject != null) {
            resources = resourceDao.getResourcesByUserId(user.getId(), String.valueOf(gradeId), subject, null, null, streamId);
        }
        request.setAttribute("resources", resources);

        request.getRequestDispatcher("/views/teacherLibrary.jsp").forward(request, response);
    }

    private String resolveClassName(Integer gradeId, List<ClassInfo> classOptions) {
        if (gradeId == null) {
            return null;
        }
        for (ClassInfo info : classOptions) {
            if (info.getId() == gradeId) {
                return info.getName();
            }
        }
        return null;
    }

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
        if (resourceType == null) {
            return false;
        }
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

    private boolean isValidUrl(String resourceUrl) {
        String lower = resourceUrl.toLowerCase();
        return lower.startsWith("http://") || lower.startsWith("https://");
    }

    private String encode(String value) {
        try {
            return java.net.URLEncoder.encode(value, java.nio.charset.StandardCharsets.UTF_8.name());
        } catch (Exception e) {
            return value;
        }
    }
}
