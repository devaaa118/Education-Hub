package com.edu.dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.edu.model.User;

public class userDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/education_hub", "root", "deva2k0x");
    }

    public long insertUser(User user) {
        String sql = "INSERT INTO users (username, name, email, password_hash, role) VALUES (?,?,?,?,?)";

            try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql,PreparedStatement.RETURN_GENERATED_KEYS    )) {
                ps.setString(1, user.getUsername());
            ps.setString(2, user.getName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPasswordHash());
            ps.setString(5, user.getRole());


            int rowsAffected = ps.executeUpdate(); // ✅ actually insert

        if (rowsAffected > 0) {
            try (ResultSet rs = ps.getGeneratedKeys()) { // ✅ get generated key
                if (rs.next()) {
                    return rs.getLong(1); // return auto-generated ID
                }
            }
        }
        } 
        catch (SQLException e) {
            e.printStackTrace();

        }
        return -1;
    }

    public void insertStudentClasses(long student_id, long class_id) throws SQLException{
        try(Connection con = getConnection();){
            String sql = "INsert into student_classes (student_id,class_id) VALUES (?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setLong(1,student_id);
            ps.setLong(2,class_id);

            ps.executeUpdate();
        }

    }


    public boolean userlogin(String username, String password) {
        String sql = "SELECT password_hash FROM users WHERE username = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password_hash");
                return password.equals(storedPassword);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getUserRole(String username) {
        String sql = "SELECT role FROM users WHERE username = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("role");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

public boolean isUsernameAvailable(String username) throws SQLException {
    String sql = "SELECT 1 FROM users WHERE username = ? LIMIT 1";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        return !rs.next(); 

    } 
}
    }

