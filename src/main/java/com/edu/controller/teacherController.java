package com.edu.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

import com.edu.dao.userDAO;
import com.edu.model.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet({ "/teachersignupServlet", "/teacherloginServlet" })
public class teacherController extends HttpServlet {
    private userDAO userdao;

    public void init() {
        userdao = new userDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = request.getServletPath();

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if ("/teachersignupServlet".equals(path)) {
            // --- signup logic ---
            String username = request.getParameter("username");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String password_hash = request.getParameter("password_hash");
            String confirmpassword = request.getParameter("confirmpassword");
            String role = request.getParameter("role");
            try {
                boolean isnewusername = userdao.isUsernameAvailable(username);
                if (isnewusername) {
                    User user = new User();
                    user.setName(fullname);
                    user.setUsername(username);
                    user.setEmail(email);
                    user.setRole(role);
                    user.setPasswordHash(password_hash);

                    long userid = userdao.insertUser(user);

                    if (userid != -1) {
                        // Redirect to commonLogin.jsp with success message
                        String successMsg = java.net.URLEncoder.encode("Signup successful! Please login.", "UTF-8");
                        resp.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp?success=" + successMsg);
                    } else {
                        String errorMsg = java.net.URLEncoder.encode("User not inserted. Please try again.", "UTF-8");
                        resp.sendRedirect(request.getContextPath() + "/views/teacherSignup.jsp?error=" + errorMsg);
                    }
                } else {
                    String errorMsg = java.net.URLEncoder.encode("Username already exists. Please choose another.", "UTF-8");
                    resp.sendRedirect(request.getContextPath() + "/views/teacherSignup.jsp?error=" + errorMsg);
                }
            } catch (SQLException e) {
                String errorMsg = java.net.URLEncoder.encode("An error occurred. Please try again.", "UTF-8");
                resp.sendRedirect(request.getContextPath() + "/views/teacherSignup.jsp?error=" + errorMsg);
            }
        }
  // In teacherController.java, modify the login logic:
else if ("/teacherloginServlet".equals(path)) {
    String username = request.getParameter("username");
    String password = request.getParameter("passwordHash");

    boolean valid = userdao.userlogin(username, password);

    if (valid) {
        // Get the user from the database
        User user = userdao.getUserByUsername(username);
        if (user != null && "teacher".equalsIgnoreCase(user.getRole())) {
            // Set the user in the session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            // Redirect to dashboard
            resp.sendRedirect(request.getContextPath() + "/views/teacherDashboard.jsp");
        } else {
            // Not a teacher
            String errorMsg = java.net.URLEncoder.encode("You are not a teacher. Please use the correct login form.", "UTF-8");
            resp.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp?error=" + errorMsg);
        }
    } else {
        // Set error message and redirect back to commonLogin.jsp
        String errorMsg = java.net.URLEncoder.encode("Invalid username or password", "UTF-8");
        resp.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp?error=" + errorMsg);
    }
}

    }
}
