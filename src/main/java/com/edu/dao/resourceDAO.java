
package com.edu.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.edu.model.Resource;

public class resourceDAO {
    /**
     * Returns a list of streams for grades 11 and 12
     */
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
        String sql = "SELECT DISTINCT s.subject_name FROM resources r " +
                     "JOIN subjects s ON r.subject_id = s.id " +
                     "JOIN student_classes sc ON r.class_id = sc.class_id " +
                     "WHERE sc.student_id = ? ORDER BY s.subject_name";
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
        String sql = "SELECT r.* FROM resources r " +
                     "JOIN subjects s ON r.subject_id = s.id " +
                     "JOIN student_classes sc ON r.class_id = sc.class_id " +
                     "WHERE sc.student_id = ? AND s.subject_name = ? ORDER BY r.created_at DESC";
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
                     "WHERE sc.student_id = ? ORDER BY r.created_at DESC";
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
        String sql = "INSERT INTO resources (class_id, subject_id, title, file_link, type, language, uploaded_by) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            // Convert grade string to class_id integer
            int classId = Integer.parseInt(resource.getGrade());
            ps.setInt(1, classId);
            
            // Get subject_id from subject name
            int subjectId = getSubjectIdByName(resource.getSubject());
            ps.setInt(2, subjectId);
            
            ps.setString(3, resource.getTitle());
            ps.setString(4, resource.getFileLink());
            ps.setString(5, resource.getType());
            ps.setString(6, resource.getLanguage());
            ps.setLong(7, resource.getUploadedBy());
            
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
        String sql = "SELECT * FROM resources WHERE class_id = ? ORDER BY created_at DESC";
        
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
        String sql = "SELECT r.* FROM resources r JOIN subjects s ON r.subject_id = s.id WHERE s.subject_name = ? ORDER BY r.created_at DESC";
        
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

    /**
     * Searches for resources containing the specified keyword in title or subject
     * @param keyword The keyword to search for
     * @return A list of resources matching the search criteria
     */
    public List<Resource> searchResources(String keyword) {
        List<Resource> resources = new ArrayList<>();
        String sql = "SELECT r.* FROM resources r JOIN subjects s ON r.subject_id = s.id WHERE r.title LIKE ? OR s.subject_name LIKE ? ORDER BY r.created_at DESC";
        
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
        sqlBuilder.append(" WHERE 1=1");
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
        String sql = "SELECT COUNT(*) FROM resources";
        
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
        String sql = "SELECT * FROM resources ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
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
        String sql = "SELECT DISTINCT r.class_id, c.class_name FROM resources r JOIN classes c ON r.class_id = c.id ORDER BY r.class_id";
        
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
        String sql = "SELECT DISTINCT s.subject_name FROM resources r JOIN subjects s ON r.subject_id = s.id ORDER BY s.subject_name";
        
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
        
        // Check if the column exists before trying to get it
        try {
            resource.setUploadedBy(rs.getLong("uploaded_by"));
        } catch (SQLException e) {
            // Column doesn't exist, set a default value or leave it as 0
            resource.setUploadedBy(0);
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
        // If subject not found, return a default value or throw an exception
        return 1; // Default to first subject
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
    private String getClassNameById(int classId) {
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
        // If class not found, return a default value
        return "Class " + classId;
    }
}
