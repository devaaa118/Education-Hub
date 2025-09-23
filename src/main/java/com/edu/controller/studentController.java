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
@WebServlet({"/studentsignupServlet","studentloginServlet"})
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

    if ("/studentsignupServlet".equals(path)) {
        String username = request.getParameter("username");
        String fullname = request.getParameter("fullname");
        String grade = request.getParameter("grade");
        String email = request.getParameter("email");
        String password_hash = request.getParameter("password_hash");
        String confirmpassword = request.getParameter("confirmpassword");
        String role = request.getParameter("role");

        try {
            boolean isAvailable = userdao.isUsernameAvailable(username);

            if (!isAvailable) {
                response.getWriter().println("❌ Username already exists!");
                return;
            }

            if (!password_hash.equals(confirmpassword)) {
                response.getWriter().println("❌ Passwords do not match!");
                return;
            }

            // ✅ Everything is fine → insert user
            User user = new User();
            user.setName(fullname);
            user.setUsername(username);
            user.setEmail(email);
            user.setRole(role);
            user.setPasswordHash(confirmpassword);

            long userid = userdao.insertUser(user);

            if (userid == -1) {
                response.getWriter().println("❌ Error: Could not insert user into database.");
                return;
            }

            // ✅ Insert student_class mapping
            try {
                long class_id = Long.parseLong(grade);
                userdao.insertStudentClasses(userid, class_id);
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("❌ Error: Could not insert student-class mapping.");
                return;
            }

            // ✅ Success
           HttpSession session =    request.getSession();
           session.setAttribute("username",username);
            session.setAttribute("role", role);
        session.setMaxInactiveInterval(30 * 60); 
        response.sendRedirect(request.getContextPath() +"/views/signupSuccess.jsp");
          
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("❌ Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.getWriter().println("❌ Invalid grade value.");
        } catch (Exception e) {
            response.getWriter().println("❌ Unknown error: " + e.getMessage());
        }

    } 
    else if("/studentloginServlet".equals(path)){
         String username = request.getParameter("username");
            String password = request.getParameter("passwordHash");

            boolean valid = userdao.userlogin(username, password);

            if (valid) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                String role = userdao.getUserRole(username);

                response.getWriter().write("{\"status\":\"success\", \"role\":\"" + role + "\"}");
            } else {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid username or password\"}");
            }
    }
    
    else {
        response.getWriter().println(" Invalid request path.");
    }
}

}
