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

@WebServlet({ "/teachersignup", "/teacherLogin" })
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

        if ("/teachersignup".equals(path)) {
            // --- signup logic ---
            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPasswordHash(request.getParameter("passwordHash"));
            user.setRole(request.getParameter("role"));

            String msg = userdao.insertUser(user);

            if (msg.contains("successfully")) {
                resp.getWriter().write("{\"status\":\"success\",\"message\":\"" + msg + "\"}");
            } else {
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"" + msg + "\"}");
            }

        } else if ("/teacherLogin".equals(path)) {
            // --- login logic ---
            String username = request.getParameter("username");
            String password = request.getParameter("passwordHash");

            boolean valid = userdao.userlogin(username, password);

            if (valid) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                String role = userdao.getUserRole(username);

                resp.getWriter().write("{\"status\":\"success\", \"role\":\"" + role + "\"}");
            } else {
                resp.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid username or password\"}");
            }
        }
    }
}
