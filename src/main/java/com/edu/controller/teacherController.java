package com.edu.controller;

import org.springframework.web.client.HttpServerErrorException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

import com.edu.dao.userDAO;
import com.edu.model.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
@WebServlet("/teachersignup")
public class teacherController extends HttpServlet {
    private userDAO userdao;

    public void init(){
        userdao = new userDAO();
    }

    protected void doPost(HttpServletRequest request , HttpServletResponse resp) throws ServletException, IOException{

     
       User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setPasswordHash(request.getParameter("passwordHash"));
        user.setRole(request.getParameter("role")); 
        
        String msg = userdao.insertUser(user);
          request.setAttribute("message", msg);
         resp.sendRedirect(request.getContextPath() + "/views/teacherSignup.jsp?msg=" 
    + URLEncoder.encode(msg, "UTF-8"));
    }
}
