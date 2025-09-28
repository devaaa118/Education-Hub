package com.edu.controller;

import com.edu.dao.QuizDAO;
import com.edu.dao.TutoringSessionDAO;
import com.edu.dao.resourceDAO;
import com.edu.model.ClassInfo;
import com.edu.model.SubjectInfo;
import com.edu.model.TutoringSession;
import com.edu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet("/teacher/tutoring")
public class TeacherTutoringServlet extends HttpServlet {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        TutoringSessionDAO tutoringSessionDAO = new TutoringSessionDAO();
        resourceDAO resourceDao = new resourceDAO();
        QuizDAO quizDAO = new QuizDAO();

        List<TutoringSession> sessions = tutoringSessionDAO.getSessionsForTeacher(user.getId());
        List<ClassInfo> classes = resourceDao.getAllClasses();
        Map<Integer, List<SubjectInfo>> subjectsByClass = quizDAO.getSubjectsByClass();

        request.setAttribute("sessions", sessions);
        request.setAttribute("classOptions", classes);
        request.setAttribute("subjectsByClass", subjectsByClass);
        request.getRequestDispatcher("/views/tutoringTeacher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/commonLogin.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String title = request.getParameter("title");
        String tutorName = request.getParameter("tutorName");
        String description = request.getParameter("description");
        String sessionDateTime = request.getParameter("sessionDateTime");
        String classIdParam = request.getParameter("classId");
        String subjectIdParam = request.getParameter("subjectId");
        String meetingLink = request.getParameter("meetingLink");

        if (title == null || title.isBlank() || tutorName == null || tutorName.isBlank() || sessionDateTime == null || sessionDateTime.isBlank()) {
            request.setAttribute("message", "Title, tutor name, and session date/time are required.");
            request.setAttribute("messageType", "danger");
            doGet(request, response);
            return;
        }

        TutoringSession session = new TutoringSession();
        session.setTitle(title.trim());
        session.setTutorName(tutorName.trim());
        session.setDescription(description != null ? description.trim() : null);
        try {
            session.setSessionDateTime(LocalDateTime.parse(sessionDateTime, DATE_TIME_FORMATTER));
        } catch (Exception e) {
            request.setAttribute("message", "Invalid session date and time format.");
            request.setAttribute("messageType", "danger");
            doGet(request, response);
            return;
        }
        if (classIdParam != null && !classIdParam.isBlank()) {
            session.setClassId(Long.parseLong(classIdParam));
        }
        if (subjectIdParam != null && !subjectIdParam.isBlank()) {
            session.setSubjectId(Long.parseLong(subjectIdParam));
        }
        session.setMeetingLink(meetingLink != null ? meetingLink.trim() : null);
        session.setCreatedBy(user.getId());

        TutoringSessionDAO tutoringSessionDAO = new TutoringSessionDAO();
        boolean created = tutoringSessionDAO.createSession(session);
        if (created) {
            request.setAttribute("message", "Tutoring session scheduled successfully.");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Failed to schedule tutoring session. Please try again.");
            request.setAttribute("messageType", "danger");
        }
        doGet(request, response);
    }
}
