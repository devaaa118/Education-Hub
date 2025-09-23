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
          try{
            boolean isnewusername = userdao.isUsernameAvailable(username);
if(isnewusername){
            User user = new User();
             user.setName(fullname);
            user.setUsername(username);
             user.setEmail(email);
            user.setRole(role);
            user.setPasswordHash(password_hash);

        
            long userid = userdao.insertUser(user);

            if (userid!=-1) {
                resp.getWriter().write("{\"status\":\"success\",\"message\":\"" + "INSERTED SUCCESSFULLY" + "\"}");
            } else {
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"" +"USER NOT INSERTED" + "\"}");
            }
        }}
        catch(SQLException e){

        }
        } 
        else if ("/teacherloginServlet".equals(path)) {
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
