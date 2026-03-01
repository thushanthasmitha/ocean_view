package com.mycompany.ocean_view.dao;

import com.mycompany.ocean_view.model.User;
import java.sql.*;

public class UserDAO {

    public User findActiveByUsername(String username) throws SQLException {
        String sql = "SELECT user_id, username, password_hash, role, is_active " +
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
                u.setActive(rs.getBoolean("is_active"));
                return u;
            }
        }
    }
}