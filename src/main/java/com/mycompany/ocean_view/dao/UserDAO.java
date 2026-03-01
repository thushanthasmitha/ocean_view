package com.mycompany.ocean_view.dao;

import com.mycompany.ocean_view.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // ✅ For login: active user by username
    public User findActiveByUsername(String username) throws Exception {
        String sql = "SELECT user_id, username, password_hash, role, is_active, created_at " +
                     "FROM users WHERE username=? AND is_active=1";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                User u = new User();
                u.setUserId(rs.getLong("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setRole(rs.getString("role"));
                u.setActive(rs.getInt("is_active") == 1);
                return u;
            }
        }
    }

    // ✅ Optional: find user (active/inactive) by username (useful for admin checks)
    public User findByUsername(String username) throws Exception {
        String sql = "SELECT user_id, username, password_hash, role, is_active, created_at " +
                     "FROM users WHERE username=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                User u = new User();
                u.setUserId(rs.getLong("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setRole(rs.getString("role"));
                u.setActive(rs.getInt("is_active") == 1);
                return u;
            }
        }
    }

    public List<User> findAll() throws Exception {
        String sql = "SELECT user_id, username, password_hash, role, is_active, created_at " +
                     "FROM users ORDER BY user_id DESC";
        List<User> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getLong("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setRole(rs.getString("role"));
                u.setActive(rs.getInt("is_active") == 1);
                list.add(u);
            }
        }
        return list;
    }

    public void insertUser(String username, String passwordHash, String role, int isActive) throws Exception {
        String sql = "INSERT INTO users (username, password_hash, role, is_active) VALUES (?,?,?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, passwordHash); // NOTE: currently plain text
            ps.setString(3, role);
            ps.setInt(4, isActive);
            ps.executeUpdate();
        }
    }

    public void updateActive(long userId, int isActive) throws Exception {
        String sql = "UPDATE users SET is_active=? WHERE user_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, isActive);
            ps.setLong(2, userId);
            ps.executeUpdate();
        }
    }

    public void updateRole(long userId, String role) throws Exception {
        String sql = "UPDATE users SET role=? WHERE user_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setLong(2, userId);
            ps.executeUpdate();
        }
    }

    public void updatePassword(long userId, String passwordHash) throws Exception {
        String sql = "UPDATE users SET password_hash=? WHERE user_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, passwordHash);
            ps.setLong(2, userId);
            ps.executeUpdate();
        }
    }
}