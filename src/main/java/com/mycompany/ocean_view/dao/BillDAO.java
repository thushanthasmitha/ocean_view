package com.mycompany.ocean_view.dao;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;

public class BillDAO {

    /**
     * Find active room rate for given roomType at given date.
     * Rule:
     *  - is_active = 1
     *  - effective_from <= date
     *  - (effective_to is null OR effective_to >= date)
     *  - latest effective_from wins
     */
    public BigDecimal findRateForRoomType(String roomType, LocalDate forDate) throws SQLException {
        String sql =
            "SELECT rate_per_night " +
            "FROM room_rates " +
            "WHERE room_type = ? " +
            "  AND is_active = 1 " +
            "  AND effective_from <= ? " +
            "  AND (effective_to IS NULL OR effective_to >= ?) " +
            "ORDER BY effective_from DESC " +
            "LIMIT 1";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomType);
            ps.setDate(2, Date.valueOf(forDate));
            ps.setDate(3, Date.valueOf(forDate));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("rate_per_night");
                return null;
            }
        }
    }

    public boolean billExistsForReservation(long reservationId) throws SQLException {
        String sql = "SELECT bill_id FROM bills WHERE reservation_id = ? LIMIT 1";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void insertBill(long reservationId, int nights, BigDecimal ratePerNight,
                           BigDecimal discount, BigDecimal tax, BigDecimal totalAmount,
                           long generatedBy) throws SQLException {

        String sql =
            "INSERT INTO bills (reservation_id, nights, rate_per_night, discount, tax, total_amount, generated_by) " +
            "VALUES (?,?,?,?,?,?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, reservationId);
            ps.setInt(2, nights);
            ps.setBigDecimal(3, ratePerNight);
            ps.setBigDecimal(4, discount);
            ps.setBigDecimal(5, tax);
            ps.setBigDecimal(6, totalAmount);
            ps.setLong(7, generatedBy);

            ps.executeUpdate();
        }
    }

    public void updateBill(long reservationId, int nights, BigDecimal ratePerNight,
                           BigDecimal discount, BigDecimal tax, BigDecimal totalAmount,
                           long generatedBy) throws SQLException {

        String sql =
            "UPDATE bills " +
            "SET nights=?, rate_per_night=?, discount=?, tax=?, total_amount=?, generated_by=?, generated_at=CURRENT_TIMESTAMP " +
            "WHERE reservation_id=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, nights);
            ps.setBigDecimal(2, ratePerNight);
            ps.setBigDecimal(3, discount);
            ps.setBigDecimal(4, tax);
            ps.setBigDecimal(5, totalAmount);
            ps.setLong(6, generatedBy);
            ps.setLong(7, reservationId);

            ps.executeUpdate();
        }
    }
}