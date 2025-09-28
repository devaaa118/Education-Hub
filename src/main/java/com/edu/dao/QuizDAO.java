package com.edu.dao;

import com.edu.model.Quiz;
import com.edu.model.QuizAttempt;
import com.edu.model.QuizQuestion;
import com.edu.model.SubjectInfo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class QuizDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/education_hub", "root", "deva2k0x");
    }

    public int createQuiz(Quiz quiz) {
        String sql = "INSERT INTO quizzes (title, description, class_id, subject_id, language, time_limit_minutes, created_by) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, quiz.getTitle());
            ps.setString(2, quiz.getDescription());
            ps.setInt(3, quiz.getClassId());
            ps.setInt(4, quiz.getSubjectId());
            ps.setString(5, quiz.getLanguage());
            if (quiz.getTimeLimitMinutes() != null) {
                ps.setInt(6, quiz.getTimeLimitMinutes());
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.setLong(7, quiz.getCreatedBy());
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean addQuestion(long quizId, QuizQuestion question) {
        String sql = "INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, quizId);
            ps.setString(2, question.getQuestionText());
            ps.setString(3, question.getOptionA());
            ps.setString(4, question.getOptionB());
            ps.setString(5, question.getOptionC());
            ps.setString(6, question.getOptionD());
            ps.setString(7, question.getCorrectOption());
            ps.setInt(8, question.getMarks());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Quiz> getQuizzesByTeacher(long teacherId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT q.*, c.class_name, s.subject_name, COUNT(qq.id) AS question_count, " +
                "(SELECT COUNT(*) FROM quiz_attempts qa WHERE qa.quiz_id = q.id) AS attempt_count " +
                "FROM quizzes q " +
                "LEFT JOIN classes c ON q.class_id = c.id " +
                "LEFT JOIN subjects s ON q.subject_id = s.id " +
                "LEFT JOIN quiz_questions qq ON q.id = qq.quiz_id " +
                "WHERE q.created_by = ? GROUP BY q.id, c.class_name, s.subject_name ORDER BY q.created_at DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                quizzes.add(mapQuiz(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizzes;
    }

    public List<Quiz> getQuizzesForStudent(long studentId) {
        Integer classId = getStudentClassId(studentId);
        if (classId == null) {
            return new ArrayList<>();
        }
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT q.*, c.class_name, s.subject_name, COUNT(qq.id) AS question_count, " +
                "(SELECT COUNT(*) FROM quiz_attempts qa WHERE qa.quiz_id = q.id AND qa.student_id = ?) AS attempt_count " +
                "FROM quizzes q " +
                "LEFT JOIN classes c ON q.class_id = c.id " +
                "LEFT JOIN subjects s ON q.subject_id = s.id " +
                "LEFT JOIN quiz_questions qq ON q.id = qq.quiz_id " +
                "WHERE q.class_id = ? GROUP BY q.id, c.class_name, s.subject_name ORDER BY q.created_at DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ps.setInt(2, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                quizzes.add(mapQuiz(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizzes;
    }

    public Quiz getQuizWithQuestions(long quizId) {
        Quiz quiz = null;
        String quizSql = "SELECT q.*, c.class_name, s.subject_name FROM quizzes q " +
                "LEFT JOIN classes c ON q.class_id = c.id " +
                "LEFT JOIN subjects s ON q.subject_id = s.id WHERE q.id = ?";
        String questionSql = "SELECT * FROM quiz_questions WHERE quiz_id = ? ORDER BY id";
        try (Connection con = getConnection();
             PreparedStatement quizPs = con.prepareStatement(quizSql);
             PreparedStatement questionPs = con.prepareStatement(questionSql)) {
            quizPs.setLong(1, quizId);
            try (ResultSet rs = quizPs.executeQuery()) {
                if (rs.next()) {
                    quiz = mapQuiz(rs);
                }
            }
            if (quiz == null) {
                return null;
            }
            questionPs.setLong(1, quizId);
            try (ResultSet rs = questionPs.executeQuery()) {
                List<QuizQuestion> questions = new ArrayList<>();
                while (rs.next()) {
                    questions.add(mapQuestion(rs));
                }
                quiz.setQuestions(questions);
                quiz.setQuestionCount(questions.size());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quiz;
    }

    public int recordAttempt(QuizAttempt attempt) {
        String sql = "INSERT INTO quiz_attempts (quiz_id, student_id, score, total_questions, correct_answers, responses_json, attempted_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, attempt.getQuizId());
            ps.setLong(2, attempt.getStudentId());
            ps.setInt(3, attempt.getScore());
            ps.setInt(4, attempt.getTotalQuestions());
            ps.setInt(5, attempt.getCorrectAnswers());
            ps.setString(6, attempt.getResponsesJson());
            if (attempt.getAttemptedAt() != null) {
                ps.setTimestamp(7, attempt.getAttemptedAt());
            } else {
                ps.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            }
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<QuizAttempt> getAttemptsForStudent(long studentId) {
        List<QuizAttempt> attempts = new ArrayList<>();
        String sql = "SELECT qa.*, q.title FROM quiz_attempts qa JOIN quizzes q ON qa.quiz_id = q.id " +
                "WHERE qa.student_id = ? ORDER BY qa.attempted_at DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                attempts.add(mapAttempt(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attempts;
    }

    public List<QuizAttempt> getAttemptsForQuiz(long quizId) {
        List<QuizAttempt> attempts = new ArrayList<>();
    String sql = "SELECT qa.*, u.name AS student_name, q.title FROM quiz_attempts qa " +
        "JOIN quizzes q ON qa.quiz_id = q.id " +
                "JOIN users u ON qa.student_id = u.id WHERE qa.quiz_id = ? ORDER BY qa.attempted_at DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, quizId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuizAttempt attempt = mapAttempt(rs);
                attempt.setStudentName(rs.getString("student_name"));
                attempts.add(attempt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attempts;
    }

    public Map<Integer, List<SubjectInfo>> getSubjectsByClass() {
        Map<Integer, List<SubjectInfo>> map = new HashMap<>();
        String sql = "SELECT cs.class_id, s.id AS subject_id, s.subject_name FROM class_subjects cs " +
                "JOIN subjects s ON cs.subject_id = s.id ORDER BY cs.class_id, s.subject_name";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int classId = rs.getInt("class_id");
                List<SubjectInfo> subjects = map.computeIfAbsent(classId, key -> new ArrayList<>());
                subjects.add(new SubjectInfo(rs.getInt("subject_id"), rs.getString("subject_name")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    public Integer getClassIdForStudent(long studentId) {
        return getStudentClassId(studentId);
    }

    private Integer getStudentClassId(long studentId) {
        String sql = "SELECT class_id FROM student_classes WHERE student_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("class_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Quiz mapQuiz(ResultSet rs) throws SQLException {
        Quiz quiz = new Quiz();
        quiz.setId(rs.getLong("id"));
        quiz.setTitle(rs.getString("title"));
        quiz.setDescription(rs.getString("description"));
        quiz.setClassId(rs.getInt("class_id"));
        quiz.setSubjectId(rs.getInt("subject_id"));
        quiz.setLanguage(rs.getString("language"));
        int timeLimit = rs.getInt("time_limit_minutes");
        if (rs.wasNull()) {
            quiz.setTimeLimitMinutes(null);
        } else {
            quiz.setTimeLimitMinutes(timeLimit);
        }
        quiz.setCreatedBy(rs.getLong("created_by"));
        quiz.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            quiz.setClassName(rs.getString("class_name"));
        } catch (SQLException ignored) {
        }
        try {
            quiz.setSubjectName(rs.getString("subject_name"));
        } catch (SQLException ignored) {
        }
        try {
            quiz.setQuestionCount(rs.getInt("question_count"));
        } catch (SQLException ignored) {
        }
        try {
            quiz.setAttemptCount(rs.getInt("attempt_count"));
        } catch (SQLException ignored) {
        }
        return quiz;
    }

    private QuizQuestion mapQuestion(ResultSet rs) throws SQLException {
        QuizQuestion question = new QuizQuestion();
        question.setId(rs.getLong("id"));
        question.setQuizId(rs.getLong("quiz_id"));
        question.setQuestionText(rs.getString("question_text"));
        question.setOptionA(rs.getString("option_a"));
        question.setOptionB(rs.getString("option_b"));
        question.setOptionC(rs.getString("option_c"));
        question.setOptionD(rs.getString("option_d"));
        question.setCorrectOption(rs.getString("correct_option"));
        question.setMarks(rs.getInt("marks"));
        return question;
    }

    private QuizAttempt mapAttempt(ResultSet rs) throws SQLException {
        QuizAttempt attempt = new QuizAttempt();
        attempt.setId(rs.getLong("id"));
        attempt.setQuizId(rs.getLong("quiz_id"));
        attempt.setStudentId(rs.getLong("student_id"));
        attempt.setScore(rs.getInt("score"));
        attempt.setTotalQuestions(rs.getInt("total_questions"));
        attempt.setCorrectAnswers(rs.getInt("correct_answers"));
        attempt.setResponsesJson(rs.getString("responses_json"));
        attempt.setAttemptedAt(rs.getTimestamp("attempted_at"));
        try {
            attempt.setQuizTitle(rs.getString("title"));
        } catch (SQLException ignored) {
        }
        try {
            attempt.setStudentName(rs.getString("student_name"));
        } catch (SQLException ignored) {
        }
        return attempt;
    }
}
