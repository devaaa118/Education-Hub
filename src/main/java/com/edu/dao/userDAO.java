package com.edu.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.edu.model.User;

public class userDAO {

    public String insertUser(User user) {
        String result = "User registration failed!";

        String sql = "INSERT INTO users (username, name, email, password_hash, role) VALUES (?,?,?,?,?)";

        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/education_hub", "root", "P@2005vlan");
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

    public boolean userlogin(String username, String password) {
        String sql = "select id,password_hash from users where username = ?";
        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/education_hub", "root", "P@2005vlan");
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedpassword = rs.getString("password_hash");
                long userid = rs.getLong("id");
                if (password.equals(storedpassword)) {
                    return true;

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
