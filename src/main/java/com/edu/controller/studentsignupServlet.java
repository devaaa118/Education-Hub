package com.edu.controller;

import com.edu.dao.userDAO;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/studentsignupServlet")
public class studentsignupServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password_hash");
        String grade = request.getParameter("grade");
        String stream = request.getParameter("stream"); // may be null

        System.out.println("[DEBUG] Raw request params: username=" + username + ", fullname=" + fullname + ", email=" + email + ", password=" + password + ", grade=" + grade + ", stream=" + stream);

        User user = new User();
        user.setUsername(username);
        user.setName(fullname);
        user.setEmail(email);
        user.setPasswordHash(password);
        user.setRole("student");

        System.out.println("[DEBUG] User object: " + user);

        userDAO userDAO = new userDAO();
        long userId = userDAO.insertUser(user);
        System.out.println("[DEBUG] userDAO.insertUser returned userId=" + userId);
        if (userId == -1) {
            System.out.println("[DEBUG] Signup failed at user insert");
            request.setAttribute("error", "Signup failed. Please try again.");
            request.getRequestDispatcher("/views/studentSignup.jsp").forward(request, response);
            return;
        }
        try {
            long classId = Long.parseLong(grade); // assuming class_id matches grade
            System.out.println("[DEBUG] Parsed classId=" + classId);
            if ("11".equals(grade) || "12".equals(grade)) {
                int streamId = getStreamIdByName(stream);
                System.out.println("[DEBUG] getStreamIdByName(" + stream + ") returned streamId=" + streamId);
                // Server-side validation: stream must be present and valid for grades 11/12
                if (stream == null || stream.isEmpty() || streamId == 0) {
                    System.out.println("[DEBUG] Stream missing or invalid for grade " + grade + ". stream=" + stream + ", streamId=" + streamId);
                    request.setAttribute("error", "Please select a valid stream for Grade " + grade + ".");
                    request.getRequestDispatcher("/views/studentSignup.jsp").forward(request, response);
                    return;
                }
                System.out.println("[DEBUG] Calling userDAO.insertStudentClasses(userId=" + userId + ", classId=" + classId + ", streamId=" + streamId + ")");
                userDAO.insertStudentClasses(userId, classId, streamId);
            } else {
                System.out.println("[DEBUG] Calling userDAO.insertStudentClasses(userId=" + userId + ", classId=" + classId + ") (no stream)");
                userDAO.insertStudentClasses(userId, classId);
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG] SQLException during student class insert: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Signup failed. Please try again.");
            request.getRequestDispatcher("/views/studentSignup.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            System.out.println("[DEBUG] Exception during signup flow: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Signup failed. Please try again.");
            request.getRequestDispatcher("/views/studentSignup.jsp").forward(request, response);
            return;
        }
    System.out.println("[DEBUG] Signup flow completed successfully for userId=" + userId);
    // Redirect to studentLogin.jsp after successful signup
    response.sendRedirect(request.getContextPath() + "/views/studentLogin.jsp");
    }

    // Map stream name to stream_id (hardcoded for Science, Commerce, Arts)
    private int getStreamIdByName(String stream) {
    System.out.println("[DEBUG] getStreamIdByName called with stream=" + stream);
    if (stream == null) return 0;
    if ("science".equalsIgnoreCase(stream)) return 1;
    if ("arts".equalsIgnoreCase(stream)) return 3;
    if ("commerce".equalsIgnoreCase(stream)) return 2;
    return 0;
    }
}
