package com.edu.controller;

import java.io.IOException;
import java.sql.*;

import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/TeacherLoginServlet")
public class TeacherLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("passwordHash");

        try {
            // ✅ Load Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // ✅ Connect DB
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/education_hub", "root", "P@2005vlan");

            // ✅ Check user exists
            String sql = "SELECT * FROM users WHERE username=? AND password_hash=? AND role='teacher'";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password); // (For now plain text, later we hash)

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ Store user in session
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setUsername(rs.getString("username"));
                user.setName(rs.getString("name"));
                user.setRole(rs.getString("role"));

                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                // ✅ Redirect to Teacher Dashboard
                response.sendRedirect(request.getContextPath() + "/views/teacherDashboard.jsp");
            } else {
                // Invalid login
                response.sendRedirect(request.getContextPath() + "/views/teacherLogin.jsp?msg=Invalid+credentials");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/teacherLogin.jsp?msg=Error");
        }
    }
}
