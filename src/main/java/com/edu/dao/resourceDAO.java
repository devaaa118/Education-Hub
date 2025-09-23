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
    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/education_hub", "root", "deva2k0x");
    }
    
public int insertResource(Resource resource) {
    String sql = "INSERT INTO resources (grade, subject, title, file_link, type, language) VALUES (?, ?, ?, ?, ?, ?)";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
        
        ps.setString(1, resource.getGrade());
        ps.setString(2, resource.getSubject());
        ps.setString(3, resource.getTitle());
        ps.setString(4, resource.getFileLink());
        ps.setString(5, resource.getType());
        ps.setString(6, resource.getLanguage());
        
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
    String sql = "SELECT * FROM resources WHERE grade = ? ORDER BY created_at DESC";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, grade);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            resources.add(mapResultSetToResource(rs));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return resources;
}


public List<Resource> getResourcesBySubject(String subject) {
    List<Resource> resources = new ArrayList<>();
    String sql = "SELECT * FROM resources WHERE subject = ? ORDER BY created_at DESC";
    
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
    String sql = "SELECT * FROM resources WHERE title LIKE ? OR subject LIKE ? ORDER BY created_at DESC";
    
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
public List<Resource> getFilteredResources(String grade, String subject, String type, String language) {
    List<Resource> resources = new ArrayList<>();
    StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM resources WHERE 1=1");
    List<Object> params = new ArrayList<>();
    
    if (grade != null && !grade.isEmpty()) {
        sqlBuilder.append(" AND grade = ?");
        params.add(grade);
    }
    
    if (subject != null && !subject.isEmpty()) {
        sqlBuilder.append(" AND subject = ?");
        params.add(subject);
    }
    
    if (type != null && !type.isEmpty()) {
        sqlBuilder.append(" AND type = ?");
        params.add(type);
    }
    
    if (language != null && !language.isEmpty()) {
        sqlBuilder.append(" AND language = ?");
        params.add(language);
    }
    
    sqlBuilder.append(" ORDER BY created_at DESC");
    
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
    String sql = "SELECT DISTINCT grade FROM resources ORDER BY grade";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            grades.add(rs.getString("grade"));
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
    String sql = "SELECT DISTINCT subject FROM resources ORDER BY subject";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            subjects.add(rs.getString("subject"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return subjects;
}

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


private Resource mapResultSetToResource(ResultSet rs) throws SQLException {
    Resource resource = new Resource();
    resource.setId(rs.getInt("id"));
    resource.setGrade(rs.getString("grade"));
    resource.setSubject(rs.getString("subject"));
    resource.setTitle(rs.getString("title"));
    resource.setFileLink(rs.getString("file_link"));
    resource.setType(rs.getString("type"));
    resource.setLanguage(rs.getString("language"));
    return resource;
}


    


}
