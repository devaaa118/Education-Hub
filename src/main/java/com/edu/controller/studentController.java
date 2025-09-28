package com.edu.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.edu.dao.userDAO;
import com.edu.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("studentloginServlet")
public class studentController extends HttpServlet {
    private userDAO userdao;

    public void init(){
        userdao = new userDAO();
    }
    
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

    response.setContentType("text/plain"); // default for all responses

    String path = request.getServletPath();
 if("/studentloginServlet".equals(path)){
    String username = request.getParameter("username");
    String password = request.getParameter("passwordHash");

    boolean valid = userdao.userlogin(username, password);

    if (valid) {
        // Get the user from the database
        User user = userdao.getUserByUsername(username);
        if (user != null && "student".equalsIgnoreCase(user.getRole())) {
            // Set the user in the session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            // Redirect to student dashboard servlet
            response.sendRedirect(request.getContextPath() + "/studentDashboard");
        } else {
            // Not a student
            String errorMsg = java.net.URLEncoder.encode("You are not a student. Please use the correct login form.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp?error=" + errorMsg);
        }
    } else {
        // Set error message and redirect back to commonLogin.jsp
        String errorMsg = java.net.URLEncoder.encode("Invalid username or password", "UTF-8");
        response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp?error=" + errorMsg);
    }
}

    
}

}
