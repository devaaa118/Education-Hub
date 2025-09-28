package com.edu.dao;

import com.edu.model.TutoringSession;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class TutoringSessionDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/education_hub", "root", "deva2k0x");
    }

    public boolean createSession(TutoringSession session) {
        String sql = "INSERT INTO tutoring_sessions (title, description, tutor_name, session_datetime, class_id, subject_id, meeting_link, created_by) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, session.getTitle());
            ps.setString(2, session.getDescription());
            ps.setString(3, session.getTutorName());
            ps.setTimestamp(4, Timestamp.valueOf(session.getSessionDateTime()));
            if (session.getClassId() != null) {
                ps.setLong(5, session.getClassId());
            } else {
                ps.setNull(5, java.sql.Types.BIGINT);
            }
            if (session.getSubjectId() != null) {
                ps.setLong(6, session.getSubjectId());
            } else {
                ps.setNull(6, java.sql.Types.BIGINT);
            }
            ps.setString(7, session.getMeetingLink());
            ps.setLong(8, session.getCreatedBy());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<TutoringSession> getSessionsForTeacher(long teacherId) {
        List<TutoringSession> sessions = new ArrayList<>();
        String sql = "SELECT ts.*, c.class_name, s.subject_name FROM tutoring_sessions ts " +
                "LEFT JOIN classes c ON ts.class_id = c.id " +
                "LEFT JOIN subjects s ON ts.subject_id = s.id " +
                "WHERE ts.created_by = ? ORDER BY ts.session_datetime ASC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                sessions.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sessions;
    }

    public List<TutoringSession> getUpcomingSessionsForStudent(long studentId) {
        Long classId = getStudentClassId(studentId);
        List<TutoringSession> sessions = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT ts.*, c.class_name, s.subject_name FROM tutoring_sessions ts " +
                "LEFT JOIN classes c ON ts.class_id = c.id " +
                "LEFT JOIN subjects s ON ts.subject_id = s.id " +
                "WHERE ts.session_datetime >= NOW()");
        List<Object> params = new ArrayList<>();
        if (classId != null) {
            sql.append(" AND (ts.class_id IS NULL OR ts.class_id = ?)");
            params.add(classId);
        } else {
            sql.append(" AND ts.class_id IS NULL");
        }
        sql.append(" ORDER BY ts.session_datetime ASC");
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object value = params.get(i);
                if (value instanceof Long) {
                    ps.setLong(i + 1, (Long) value);
                } else {
                    ps.setObject(i + 1, value);
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                sessions.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sessions;
    }

    public List<TutoringSession> getUpcomingSessions(int limit) {
        List<TutoringSession> sessions = new ArrayList<>();
        String sql = "SELECT ts.*, c.class_name, s.subject_name FROM tutoring_sessions ts " +
                "LEFT JOIN classes c ON ts.class_id = c.id " +
                "LEFT JOIN subjects s ON ts.subject_id = s.id " +
                "WHERE ts.session_datetime >= NOW() ORDER BY ts.session_datetime ASC LIMIT ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                sessions.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sessions;
    }

    public boolean deleteSession(long sessionId, long teacherId) {
        String sql = "DELETE FROM tutoring_sessions WHERE id = ? AND created_by = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, sessionId);
            ps.setLong(2, teacherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public TutoringSession getSessionById(long sessionId) {
        String sql = "SELECT ts.*, c.class_name, s.subject_name FROM tutoring_sessions ts " +
                "LEFT JOIN classes c ON ts.class_id = c.id " +
                "LEFT JOIN subjects s ON ts.subject_id = s.id WHERE ts.id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, sessionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Long getStudentClassId(long studentId) {
        String sql = "SELECT class_id FROM student_classes WHERE student_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                long classId = rs.getLong("class_id");
                return rs.wasNull() ? null : classId;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private TutoringSession mapRow(ResultSet rs) throws SQLException {
        TutoringSession session = new TutoringSession();
        session.setId(rs.getLong("id"));
        session.setTitle(rs.getString("title"));
        session.setDescription(rs.getString("description"));
        session.setTutorName(rs.getString("tutor_name"));
        Timestamp sessionTs = rs.getTimestamp("session_datetime");
        if (sessionTs != null) {
            session.setSessionTimestamp(sessionTs);
        }
        long classId = rs.getLong("class_id");
        if (rs.wasNull()) {
            session.setClassId(null);
        } else {
            session.setClassId(classId);
        }
        long subjectId = rs.getLong("subject_id");
        if (rs.wasNull()) {
            session.setSubjectId(null);
        } else {
            session.setSubjectId(subjectId);
        }
        session.setMeetingLink(rs.getString("meeting_link"));
        session.setCreatedBy(rs.getLong("created_by"));
        session.setCreatedAt(rs.getTimestamp("created_at"));
        session.setClassName(rs.getString("class_name"));
        session.setSubjectName(rs.getString("subject_name"));
        return session;
    }
}
