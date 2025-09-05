package com.edu.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.edu.model.User;

public class userDAO {

    public String insertUser(User user) {
        String result = "User registration failed!";
        
        String sql = "INSERT INTO users (username, name, email, password_hash, role) VALUES (?,?,?,?,?)";

        try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/education_hub", "root", "deva2k0x");
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPasswordHash());
            ps.setString(5, user.getRole());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                result = "User registered successfully ";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            result = "Error: " + e.getMessage();
        }

        return result;
    }
}
