package com.mycompany.ocean_view.dao;

import java.math.BigDecimal;
import java.sql.*;

public class BillDAO {

    public boolean billExistsForReservation(long reservationId) throws SQLException {
        String sql = "SELECT COUNT(*) AS cnt FROM bills WHERE reservation_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt("cnt") > 0;
            }
        }
    }

    public long insertBill(long reservationId, int nights, BigDecimal ratePerNight,
                           BigDecimal discount, BigDecimal tax, BigDecimal total, long generatedBy)
            throws SQLException {

        String sql = "INSERT INTO bills (reservation_id, nights, rate_per_night, discount, tax, total_amount, generated_by) " +
                     "VALUES (?,?,?,?,?,?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, reservationId);
            ps.setInt(2, nights);
            ps.setBigDecimal(3, ratePerNight);
            ps.setBigDecimal(4, discount);
            ps.setBigDecimal(5, tax);
            ps.setBigDecimal(6, total);
            ps.setLong(7, generatedBy);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        throw new SQLException("Bill insert failed.");
    }
}