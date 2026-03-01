package com.mycompany.ocean_view.dao;

import com.mycompany.ocean_view.model.Guest;
import java.sql.*;

public class GuestDAO {

    public long insertGuest(Guest g) throws SQLException {
        String sql = "INSERT INTO guests (full_name, address, contact_number, email) VALUES (?,?,?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, g.getFullName());
            ps.setString(2, g.getAddress());
            ps.setString(3, g.getContactNumber());
            ps.setString(4, g.getEmail());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        throw new SQLException("Guest insert failed.");
    }

    public Guest findById(long guestId) throws SQLException {
        String sql = "SELECT guest_id, full_name, address, contact_number, email FROM guests WHERE guest_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, guestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Guest g = new Guest();
                g.setGuestId(rs.getLong("guest_id"));
                g.setFullName(rs.getString("full_name"));
                g.setAddress(rs.getString("address"));
                g.setContactNumber(rs.getString("contact_number"));
                g.setEmail(rs.getString("email"));
                return g;
            }
        }
    }
}