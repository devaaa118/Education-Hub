package com.edu.controller;

import org.springframework.web.client.HttpServerErrorException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

import com.edu.dao.userDAO;
import com.edu.model.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.io.PrintWriter;

@WebServlet({ "/teachersignup", "/teacherLogin" })
public class teacherController extends HttpServlet {
    private userDAO userdao;

    public void init() {
        userdao = new userDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/teachersignup".equals(path)) {
            // --- signup logic (unchanged) ---
            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPasswordHash(request.getParameter("passwordHash"));
            user.setRole(request.getParameter("role"));

            String msg = userdao.insertUser(user);
            resp.sendRedirect(request.getContextPath() + "/views/teacherSignup.jsp?msg="
                    + URLEncoder.encode(msg, "UTF-8"));

        } else if ("/teacherLogin".equals(path)) {
            // --- login logic ---
            String username = request.getParameter("username");
            String password = request.getParameter("passwordHash");

            boolean valid = userdao.userlogin(username, password);

            if (valid) {
                // Create session for user
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                // Forward to JSP with message
                request.setAttribute("msg", "Login Successful ✅");
                request.getRequestDispatcher("/views/teacherLogin.jsp").forward(request, resp);

            } else {
                request.setAttribute("msg", "Invalid username or password ❌");
                request.getRequestDispatcher("/views/teacherLogin.jsp").forward(request, resp);
            }
        }
    }
}