
package com.edu.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.edu.model.Resource;
import com.edu.model.ResourceStat;
import com.edu.model.ClassInfo;

public class resourceDAO {
    // Get subjects for a given grade and stream (for dropdown filtering)
    public List<String> getSubjectsForGrade(String grade, String stream) {
        List<String> subjects = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT DISTINCT s.subject_name FROM class_subjects cs JOIN subjects s ON cs.subject_id = s.id WHERE cs.class_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(Integer.parseInt(grade));
        if (stream != null && !stream.isEmpty()) {
            sql.append(" AND cs.stream_id = ?");
            params.add(Integer.parseInt(stream));
        }
        sql.append(" ORDER BY s.subject_name");
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                subjects.add(rs.getString("subject_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    public List<ClassInfo> getAllClasses() {
        List<ClassInfo> classes = new ArrayList<>();
        String sql = "SELECT id, class_name FROM classes ORDER BY id";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ClassInfo info = new ClassInfo();
                info.setId(rs.getInt("id"));
                info.setName(rs.getString("class_name"));
                classes.add(info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return classes;
    }

    public Map<Integer, List<String>> getSubjectsByClass() {
        Map<Integer, List<String>> subjectsByClass = new LinkedHashMap<>();
        String sql = "SELECT c.id AS class_id, c.class_name, s.subject_name " +
                "FROM classes c " +
                "LEFT JOIN class_subjects cs ON cs.class_id = c.id " +
                "LEFT JOIN subjects s ON cs.subject_id = s.id " +
                "ORDER BY c.id, s.subject_name";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int classId = rs.getInt("class_id");
                String subjectName = rs.getString("subject_name");
                List<String> subjects = subjectsByClass.computeIfAbsent(classId, k -> new ArrayList<>());
                if (subjectName != null && !subjects.contains(subjectName)) {
                    subjects.add(subjectName);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjectsByClass;
    }

    public Map<Integer, String> getStreamsForClass(int classId) {
        Map<Integer, String> streams = new LinkedHashMap<>();
        String sql = "SELECT DISTINCT s.id, s.stream_name " +
                "FROM class_subjects cs " +
                "JOIN streams s ON cs.stream_id = s.id " +
                "WHERE cs.class_id = ? ORDER BY s.id";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                streams.put(rs.getInt("id"), rs.getString("stream_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return streams;
    }

    public List<String> getSubjectsForClassAndStream(int classId, Integer streamId) {
        List<String> subjects = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT DISTINCT s.subject_name FROM class_subjects cs " +
                "JOIN subjects s ON cs.subject_id = s.id WHERE cs.class_id = ?");
        if (streamId == null) {
            sql.append(" AND cs.stream_id IS NULL");
        } else {
            sql.append(" AND cs.stream_id = ?");
        }
        sql.append(" ORDER BY s.subject_name");

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setInt(1, classId);
            if (streamId != null) {
                ps.setInt(2, streamId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                subjects.add(rs.getString("subject_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    public List<Integer> getStreamIdsForClassAndSubject(int classId, String subjectName) {
        List<Integer> streamIds = new ArrayList<>();
        String sql = "SELECT DISTINCT cs.stream_id FROM class_subjects cs " +
                "JOIN subjects s ON cs.subject_id = s.id " +
                "WHERE cs.class_id = ? AND s.subject_name = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, classId);
            ps.setString(2, subjectName);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Integer stream = (Integer) rs.getObject("stream_id");
                if (stream != null) {
                    streamIds.add(stream);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return streamIds;
    }
    /**
     * Returns a list of streams for grades 11 and 12
     */

    // Get all courses (class names) for a student
    public List<String> getCoursesForStudent(long studentId) {
        List<String> courses = new ArrayList<>();
        String sql = "SELECT DISTINCT s.subject_name " +
                     "FROM student_classes sc " +
                     "JOIN class_subjects cs ON sc.class_id = cs.class_id " +
                     "JOIN subjects s ON cs.subject_id = s.id " +
                     "WHERE sc.student_id = ? " +
                     "AND (cs.stream_id IS NULL OR sc.stream_id IS NULL OR cs.stream_id = sc.stream_id) " +
                     "ORDER BY s.subject_name";
        System.out.println("[DEBUG] getCoursesForStudent called for studentId=" + studentId);
        System.out.println("[DEBUG] SQL: " + sql);
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                String subjectName = rs.getString("subject_name");
                courses.add(subjectName);
                System.out.println("[DEBUG] Found course: " + subjectName);
                count++;
            }
            System.out.println("[DEBUG] Total courses found: " + count);
        } catch (SQLException e) {
            System.out.println("[DEBUG] SQLException in getCoursesForStudent: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("[DEBUG] Returning courses list: " + courses);
        return courses;
    }
    public List<String> getStreamsForGrade(int grade) {
        List<String> streams = new ArrayList<>();
        // Only grades 11 and 12 have streams
        if (grade != 11 && grade != 12) return streams;
        String sql = "SELECT DISTINCT s.stream_name FROM streams s " +
                     "JOIN class_subjects cs ON cs.stream_id = s.id " +
                     "JOIN classes c ON cs.class_id = c.id " +
                     "WHERE c.class_name = ?";
        String className = "Grade " + grade;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, className);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                streams.add(rs.getString("stream_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return streams;
    }
    // Get all subjects for a student (by their enrolled classes)
    public List<String> getSubjectsForStudent(long studentId) {
        List<String> subjects = new ArrayList<>();
        // Show all subjects for student's enrolled classes, even if no resources exist
        String sql = "SELECT DISTINCT s.subject_name " +
                     "FROM student_classes sc " +
                     "JOIN class_subjects cs ON sc.class_id = cs.class_id " +
                     "JOIN subjects s ON cs.subject_id = s.id " +
                     "WHERE sc.student_id = ? " +
                     "AND (cs.stream_id IS NULL OR sc.stream_id IS NULL OR cs.stream_id = sc.stream_id) " +
                     "ORDER BY s.subject_name";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                subjects.add(rs.getString("subject_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    // Get resources for a student by subject
    public List<Resource> getResourcesForStudentBySubject(long studentId, String subject) {
        List<Resource> resources = new ArrayList<>();
    String sql = "SELECT DISTINCT r.* FROM resources r " +
             "JOIN subjects s ON r.subject_id = s.id " +
             "JOIN student_classes sc ON r.class_id = sc.class_id " +
             "LEFT JOIN class_subjects cs ON r.class_id = cs.class_id AND cs.subject_id = s.id " +
             "WHERE sc.student_id = ? AND s.subject_name = ? " +
             "AND (cs.stream_id IS NULL OR sc.stream_id IS NULL OR cs.stream_id = sc.stream_id) " +
             "AND r.is_verified = 1 ORDER BY r.created_at DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ps.setString(2, subject);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }
    
    // Get resources for a student by course (class name)
    public List<Resource> getResourcesForStudentByCourse(long studentId, String courseName) {
        List<Resource> resources = new ArrayList<>();
    String sql = "SELECT DISTINCT r.* FROM resources r " +
             "JOIN classes c ON r.class_id = c.id " +
             "JOIN student_classes sc ON c.id = sc.class_id " +
             "WHERE sc.student_id = ? AND c.class_name = ? AND r.is_verified = 1 ORDER BY r.created_at DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ps.setString(2, courseName);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }
    /**
     * Retrieves all resources in the database (no filtering)
     * @return List of all resources
     */
    public List<Resource> getAllResources() {
        List<Resource> resources = new ArrayList<>();
        String sql = "SELECT * FROM resources ORDER BY created_at DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }
    /**
     * Retrieves all resources for a student based on their enrolled classes (student_classes table)
     * @param studentId The student's user ID
     * @return List of resources for all classes the student is enrolled in
     */
    public List<Resource> getResourcesForStudent(long studentId) {
        List<Resource> resources = new ArrayList<>();
    String sql = "SELECT r.* FROM resources r " +
             "JOIN student_classes sc ON r.class_id = sc.class_id " +
             "WHERE sc.student_id = ? AND r.is_verified = 1 ORDER BY r.created_at DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }
    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/education_hub", "root", "deva2k0x");
    }
    
    /**
     * Inserts a new resource into the database
     * @param resource The resource to insert
     * @return The ID of the inserted resource, or -1 if insertion failed
     */
    public int insertResource(Resource resource) {
    String sql = "INSERT INTO resources (class_id, subject_id, title, file_link, type, language, uploaded_by, stream_id, is_verified, verified_by, verified_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            // Convert grade string to class_id integer
            int classId = Integer.parseInt(resource.getGrade());
            ps.setInt(1, classId);
            
            // Get subject_id from subject name
            int subjectId = getSubjectIdByName(resource.getSubject());
            if (subjectId <= 0) {
                return -1;
            }
            ps.setInt(2, subjectId);
            
            ps.setString(3, resource.getTitle());
            ps.setString(4, resource.getFileLink());
            ps.setString(5, resource.getType());
            ps.setString(6, resource.getLanguage());
            ps.setLong(7, resource.getUploadedBy());
            if (resource.getStreamId() != null) {
                ps.setInt(8, resource.getStreamId());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            ps.setBoolean(9, resource.isVerified());
            if (resource.getVerifiedBy() != null) {
                ps.setLong(10, resource.getVerifiedBy());
            } else {
                ps.setNull(10, Types.BIGINT);
            }
            if (resource.getVerifiedAt() != null) {
                ps.setTimestamp(11, resource.getVerifiedAt());
            } else if (resource.isVerified()) {
                ps.setTimestamp(11, new java.sql.Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(11, Types.TIMESTAMP);
            }
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Return the auto-generated ID
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Return -1 if insertion failed
    }

    /**
     * Retrieves resources filtered by grade
     * @param grade The grade to filter by
     * @return A list of resources for the specified grade
     */
    public List<Resource> getResourcesByGrade(String grade) {
        List<Resource> resources = new ArrayList<>();
    String sql = "SELECT * FROM resources WHERE class_id = ? AND is_verified = 1 ORDER BY created_at DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            int classId = Integer.parseInt(grade);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }

    /**
     * Retrieves resources filtered by subject
     * @param subject The subject to filter by
     * @return A list of resources for the specified subject
     */
    public List<Resource> getResourcesBySubject(String subject) {
        List<Resource> resources = new ArrayList<>();
    String sql = "SELECT r.* FROM resources r JOIN subjects s ON r.subject_id = s.id WHERE s.subject_name = ? AND r.is_verified = 1 ORDER BY r.created_at DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, subject);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }

    /**
     * Retrieves resources uploaded by a specific user
     * @param userId The ID of the user who uploaded the resources
     * @return A list of resources uploaded by the specified user
     */
    public List<Resource> getResourcesByUserId(long userId) {
        List<Resource> resources = new ArrayList<>();
        String sql = "SELECT * FROM resources WHERE uploaded_by = ? ORDER BY created_at DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }

    public List<Resource> getResourcesByUserId(long userId, String grade, String subject, String type, String language) {
        return getResourcesByUserId(userId, grade, subject, type, language, null);
    }

    public List<Resource> getResourcesByUserId(long userId, String grade, String subject, String type, String language, Integer streamId) {
        List<Resource> resources = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.* FROM resources r");
        List<Object> params = new ArrayList<>();
        boolean joinSubject = subject != null && !subject.isEmpty();

        if (joinSubject) {
            sql.append(" JOIN subjects s ON r.subject_id = s.id");
        }

        sql.append(" WHERE r.uploaded_by = ?");
        params.add(userId);

        if (grade != null && !grade.isEmpty()) {
            sql.append(" AND r.class_id = ?");
            try {
                params.add(Integer.parseInt(grade));
            } catch (NumberFormatException e) {
                params.add(-1);
            }
        }
        if (joinSubject) {
            sql.append(" AND s.subject_name = ?");
            params.add(subject);
        }
        if (type != null && !type.isEmpty()) {
            sql.append(" AND r.type = ?");
            params.add(type);
        }
        if (language != null && !language.isEmpty()) {
            sql.append(" AND r.language = ?");
            params.add(language);
        }
        if (streamId != null) {
            sql.append(" AND r.stream_id = ?");
            params.add(streamId);
        }

        sql.append(" ORDER BY r.created_at DESC");

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }

    public int countResourcesByUserId(long userId) {
        String sql = "SELECT COUNT(*) FROM resources WHERE uploaded_by = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Resource> getRecentResourcesByUserId(long userId, int limit) {
        List<Resource> resources = new ArrayList<>();
        String sql = "SELECT * FROM resources WHERE uploaded_by = ? ORDER BY created_at DESC LIMIT ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setInt(2, Math.max(1, limit));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }

    public List<ResourceStat> getSubjectStatsForTeacher(long userId) {
        List<ResourceStat> stats = new ArrayList<>();
        String sql = "SELECT s.subject_name, COUNT(*) AS cnt FROM resources r " +
                     "JOIN subjects s ON r.subject_id = s.id " +
                     "WHERE r.uploaded_by = ? GROUP BY s.subject_name ORDER BY cnt DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stats.add(new ResourceStat(rs.getString("subject_name"), rs.getLong("cnt")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<ResourceStat> getGradeStatsForTeacher(long userId) {
        List<ResourceStat> stats = new ArrayList<>();
        String sql = "SELECT COALESCE(c.class_name, CONCAT('Class ', r.class_id)) AS grade_label, COUNT(*) AS cnt " +
                     "FROM resources r LEFT JOIN classes c ON r.class_id = c.id " +
                     "WHERE r.uploaded_by = ? GROUP BY grade_label ORDER BY r.class_id";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stats.add(new ResourceStat(rs.getString("grade_label"), rs.getLong("cnt")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Resource getResourceByIdAndUser(int resourceId, long userId) {
        String sql = "SELECT * FROM resources WHERE id = ? AND uploaded_by = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, resourceId);
            ps.setLong(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToResource(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateResource(Resource resource) {
        StringBuilder sql = new StringBuilder("UPDATE resources SET class_id = ?, subject_id = ?, title = ?, type = ?, language = ?, stream_id = ?, is_verified = ?, verified_by = ?, verified_at = ?");
        boolean updateFile = resource.getFileLink() != null && !resource.getFileLink().isEmpty();
        if (updateFile) {
            sql.append(", file_link = ?");
        }
        sql.append(" WHERE id = ? AND uploaded_by = ?");

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int classId = Integer.parseInt(resource.getGrade());
            int subjectId = getSubjectIdByName(resource.getSubject());

            int index = 1;
            ps.setInt(index++, classId);
            ps.setInt(index++, subjectId);
            ps.setString(index++, resource.getTitle());
            ps.setString(index++, resource.getType());
            ps.setString(index++, resource.getLanguage());
            if (resource.getStreamId() != null) {
                ps.setInt(index++, resource.getStreamId());
            } else {
                ps.setNull(index++, Types.INTEGER);
            }
            ps.setBoolean(index++, resource.isVerified());
            if (resource.getVerifiedBy() != null) {
                ps.setLong(index++, resource.getVerifiedBy());
            } else {
                ps.setNull(index++, Types.BIGINT);
            }
            if (resource.getVerifiedAt() != null) {
                ps.setTimestamp(index++, resource.getVerifiedAt());
            } else if (resource.isVerified()) {
                ps.setTimestamp(index++, new java.sql.Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(index++, Types.TIMESTAMP);
            }
            if (updateFile) {
                ps.setString(index++, resource.getFileLink());
            }
            ps.setInt(index++, resource.getId());
            ps.setLong(index, resource.getUploadedBy());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteResource(int resourceId, long userId) {
        String sql = "DELETE FROM resources WHERE id = ? AND uploaded_by = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, resourceId);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Searches for resources containing the specified keyword in title or subject
     * @param keyword The keyword to search for
     * @return A list of resources matching the search criteria
     */
    public List<Resource> searchResources(String keyword) {
        List<Resource> resources = new ArrayList<>();
    String sql = "SELECT r.* FROM resources r JOIN subjects s ON r.subject_id = s.id WHERE (r.title LIKE ? OR s.subject_name LIKE ?) AND r.is_verified = 1 ORDER BY r.created_at DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            String searchTerm = "%" + keyword + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }

    /**
     * Retrieves resources with multiple filter criteria
     * @param grade The grade to filter by (can be null)
     * @param subject The subject to filter by (can be null)
     * @param type The type to filter by (can be null)
     * @param language The language to filter by (can be null)
     * @return A list of resources matching the filter criteria
     */
    public List<Resource> getFilteredResources(String grade, String subject, String type, String language, String stream) {
        List<Resource> resources = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("SELECT r.* FROM resources r");
        boolean joinSubjects = (subject != null && !subject.isEmpty());
        boolean joinClassSubjects = false;
        boolean filterByStream = false;
        int gradeInt = -1;
        try {
            if (grade != null && !grade.isEmpty()) gradeInt = Integer.parseInt(grade);
        } catch (NumberFormatException e) { gradeInt = -1; }

        // For grades 11/12, if stream is provided, join class_subjects for stream filtering
        if ((gradeInt == 11 || gradeInt == 12) && stream != null && !stream.isEmpty()) {
            joinClassSubjects = true;
            filterByStream = true;
        }
        if (joinSubjects) {
            sqlBuilder.append(" JOIN subjects s ON r.subject_id = s.id");
        }
        if (joinClassSubjects) {
            sqlBuilder.append(" JOIN class_subjects cs ON r.class_id = cs.class_id AND r.subject_id = cs.subject_id");
        }
    sqlBuilder.append(" WHERE r.is_verified = 1");
        List<Object> params = new ArrayList<>();
        if (grade != null && !grade.isEmpty()) {
            sqlBuilder.append(" AND r.class_id = ?");
            params.add(gradeInt);
        }
        if (subject != null && !subject.isEmpty()) {
            sqlBuilder.append(" AND s.subject_name = ?");
            params.add(subject);
        }
        if (type != null && !type.isEmpty()) {
            sqlBuilder.append(" AND r.type = ?");
            params.add(type);
        }
        if (language != null && !language.isEmpty()) {
            sqlBuilder.append(" AND r.language = ?");
            params.add(language);
        }
        if (filterByStream) {
            sqlBuilder.append(" AND cs.stream_id = ?");
            params.add(Integer.parseInt(stream));
        }
        sqlBuilder.append(" ORDER BY r.created_at DESC");
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }

    /**
     * Counts the total number of resources in the database
     * @return The total count of resources
     */
    public int countTotalResources() {
    String sql = "SELECT COUNT(*) FROM resources WHERE is_verified = 1";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Retrieves resources with pagination
     * @param page The page number (1-based)
     * @param pageSize The number of resources per page
     * @return A list of resources for the specified page
     */
    public List<Resource> getResourcesWithPagination(int page, int pageSize) {
        List<Resource> resources = new ArrayList<>();
    String sql = "SELECT * FROM resources WHERE is_verified = 1 ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                resources.add(mapResultSetToResource(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resources;
    }

    /**
     * Retrieves a list of all unique grades in the database
     * @return A list of unique grade values
     */
    public List<String> getUniqueGrades() {
        List<String> grades = new ArrayList<>();
    String sql = "SELECT DISTINCT r.class_id, c.class_name FROM resources r JOIN classes c ON r.class_id = c.id WHERE r.is_verified = 1 ORDER BY r.class_id";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                // You can choose to return class_id or class_name based on your needs
                grades.add(String.valueOf(rs.getInt("class_id")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return grades;
    }

    /**
     * Retrieves a list of all unique subjects in the database
     * @return A list of unique subject values
     */
    public List<String> getUniqueSubjects() {
        List<String> subjects = new ArrayList<>();
    String sql = "SELECT DISTINCT s.subject_name FROM resources r JOIN subjects s ON r.subject_id = s.id WHERE r.is_verified = 1 ORDER BY s.subject_name";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                subjects.add(rs.getString("subject_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    /**
     * Retrieves a resource by its ID
     * @param id The ID of the resource to retrieve
     * @return The resource with the specified ID, or null if not found
     */
    public Resource getResourceById(int id) {
        String sql = "SELECT * FROM resources WHERE id = ?";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToResource(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Maps a ResultSet row to a Resource object
     * @param rs The ResultSet containing resource data
     * @return A Resource object populated with data from the ResultSet
     * @throws SQLException If a database access error occurs
     */
    private Resource mapResultSetToResource(ResultSet rs) throws SQLException {
        Resource resource = new Resource();
        resource.setId(rs.getInt("id"));
        
        // Convert class_id to grade string
        int classId = rs.getInt("class_id");
        resource.setGrade(String.valueOf(classId));
        
        // Get subject name from subject_id
        int subjectId = rs.getInt("subject_id");
        String subjectName = getSubjectNameById(subjectId);
        resource.setSubject(subjectName);
        
        resource.setTitle(rs.getString("title"));
        resource.setFileLink(rs.getString("file_link"));
        resource.setType(rs.getString("type"));
        resource.setLanguage(rs.getString("language"));
        
        try {
            resource.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            resource.setCreatedAt(null);
        }

        // Check if the column exists before trying to get it
        try {
            resource.setUploadedBy(rs.getLong("uploaded_by"));
        } catch (SQLException e) {
            // Column doesn't exist, set a default value or leave it as 0
            resource.setUploadedBy(0);
        }
        try {
            Object streamObj = rs.getObject("stream_id");
            resource.setStreamId(streamObj != null ? rs.getInt("stream_id") : null);
        } catch (SQLException e) {
            resource.setStreamId(null);
        }
        try {
            resource.setVerified(rs.getBoolean("is_verified"));
        } catch (SQLException e) {
            resource.setVerified(false);
        }
        try {
            long verifier = rs.getLong("verified_by");
            if (!rs.wasNull()) {
                resource.setVerifiedBy(verifier);
            }
        } catch (SQLException e) {
            resource.setVerifiedBy(null);
        }
        try {
            resource.setVerifiedAt(rs.getTimestamp("verified_at"));
        } catch (SQLException e) {
            resource.setVerifiedAt(null);
        }
        
        return resource;
    }

    /**
     * Gets the subject ID for a given subject name
     * @param subjectName The name of the subject
     * @return The ID of the subject, or 1 if not found
     */
    private int getSubjectIdByName(String subjectName) {
        String sql = "SELECT id FROM subjects WHERE subject_name = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, subjectName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Gets the subject name for a given subject ID
     * @param subjectId The ID of the subject
     * @return The name of the subject, or "Unknown Subject" if not found
     */
    private String getSubjectNameById(int subjectId) {
        String sql = "SELECT subject_name FROM subjects WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("subject_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // If subject not found, return a default value
        return "Unknown Subject";
    }

    /**
     * Gets the class name for a given class ID
     * @param classId The ID of the class
     * @return The name of the class, or "Class " + classId if not found
     */
    public String getClassNameById(int classId) {
        String sql = "SELECT class_name FROM classes WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("class_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Class " + classId;
    }
}
