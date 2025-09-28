package com.edu.dao;

import com.edu.model.ResourceProgress;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ResourceProgressDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/education_hub", "root", "deva2k0x");
    }

    public ResourceProgress getProgress(long studentId, int resourceId) {
        String sql = "SELECT * FROM resource_progress WHERE student_id = ? AND resource_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ps.setInt(2, resourceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean upsertProgress(long studentId, int resourceId, String status, String notes, boolean touchTimestamp) {
    String sql = "INSERT INTO resource_progress (student_id, resource_id, status, notes, last_viewed_at, completed_at) " +
        "VALUES (?, ?, ?, ?, ?, ?) " +
        "ON DUPLICATE KEY UPDATE status = VALUES(status), notes = VALUES(notes), " +
        "last_viewed_at = IFNULL(VALUES(last_viewed_at), last_viewed_at), " +
        "completed_at = IFNULL(VALUES(completed_at), completed_at)";
    Timestamp now = new Timestamp(System.currentTimeMillis());
    Timestamp completed = "COMPLETED".equalsIgnoreCase(status) ? now : null;
    Timestamp lastViewed = touchTimestamp ? now : null;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ps.setInt(2, resourceId);
            ps.setString(3, status != null ? status.toUpperCase() : null);
            if (notes != null) {
                ps.setString(4, notes);
            } else {
                ps.setNull(4, java.sql.Types.VARCHAR);
            }
            if (lastViewed != null) {
                ps.setTimestamp(5, lastViewed);
            } else {
                ps.setNull(5, java.sql.Types.TIMESTAMP);
            }
            if (completed != null) {
                ps.setTimestamp(6, completed);
            } else {
                ps.setNull(6, java.sql.Types.TIMESTAMP);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Map<Integer, String> getStatusesForStudent(long studentId, List<Integer> resourceIds) {
        Map<Integer, String> statusMap = new LinkedHashMap<>();
        if (resourceIds == null || resourceIds.isEmpty()) {
            return statusMap;
        }
        String placeholders = resourceIds.stream().map(id -> "?").collect(Collectors.joining(","));
        String sql = "SELECT resource_id, status FROM resource_progress WHERE student_id = ? AND resource_id IN (" + placeholders + ")";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            for (int i = 0; i < resourceIds.size(); i++) {
                ps.setInt(i + 2, resourceIds.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                statusMap.put(rs.getInt("resource_id"), rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return statusMap;
    }

    public Map<Integer, String> getStatusesForStudent(long studentId) {
        Map<Integer, String> statusMap = new LinkedHashMap<>();
        String sql = "SELECT resource_id, status FROM resource_progress WHERE student_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                statusMap.put(rs.getInt("resource_id"), rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return statusMap;
    }

    public Map<Integer, ResourceProgress> getProgressForStudent(long studentId, List<Integer> resourceIds) {
        Map<Integer, ResourceProgress> progressMap = new LinkedHashMap<>();
        if (resourceIds == null || resourceIds.isEmpty()) {
            return progressMap;
        }
        String placeholders = resourceIds.stream().map(id -> "?").collect(Collectors.joining(","));
        String sql = "SELECT * FROM resource_progress WHERE student_id = ? AND resource_id IN (" + placeholders + ")";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            for (int i = 0; i < resourceIds.size(); i++) {
                ps.setInt(i + 2, resourceIds.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ResourceProgress progress = mapRow(rs);
                progressMap.put(progress.getResourceId(), progress);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return progressMap;
    }

    public Map<String, Integer> getStatusCounts(long studentId) {
        Map<String, Integer> counts = new HashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM resource_progress WHERE student_id = ? GROUP BY status";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                counts.put(rs.getString("status"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counts;
    }

    public List<ResourceProgress> getProgressForStudent(long studentId) {
        List<ResourceProgress> progressList = new ArrayList<>();
        String sql = "SELECT * FROM resource_progress WHERE student_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                progressList.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return progressList;
    }

    private ResourceProgress mapRow(ResultSet rs) throws SQLException {
        ResourceProgress progress = new ResourceProgress();
        progress.setId(rs.getLong("id"));
        progress.setStudentId(rs.getLong("student_id"));
        progress.setResourceId(rs.getInt("resource_id"));
        progress.setStatus(rs.getString("status"));
        progress.setNotes(rs.getString("notes"));
        progress.setLastViewedAt(rs.getTimestamp("last_viewed_at"));
        progress.setCompletedAt(rs.getTimestamp("completed_at"));
        return progress;
    }
}
