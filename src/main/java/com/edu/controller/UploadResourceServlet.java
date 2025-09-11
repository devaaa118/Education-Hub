package com.edu.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UploadResourceServlet")
@MultipartConfig // Important for file upload
public class UploadResourceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String grade = request.getParameter("grade");
        String subject = request.getParameter("subject");
        String title = request.getParameter("title");
        String type = request.getParameter("type");
        String language = request.getParameter("language");

        Part filePart = request.getPart("file");
        String fileName = filePart.getSubmittedFileName();

        // ✅ Correct method names and class casing
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/education_hub", "root", "P@2005vlan")) {

            String sql = "INSERT INTO resources (grade, subject, title, file_link, type, language) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, grade);
            ps.setString(2, subject);
            ps.setString(3, title);
            ps.setString(4, "uploads/" + fileName); // relative path
            ps.setString(5, type);
            ps.setString(6, language);

            ps.executeUpdate();

            response.sendRedirect("views/teacherDashboard.jsp?msg=Resource uploaded successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Upload failed: " + e.getMessage());
            request.getRequestDispatcher("views/uploadResource.jsp").forward(request, response);
        }
    }
}
