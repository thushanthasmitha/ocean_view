package com.mycompany.ocean_view.dao;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;

public class RateDAO {

    public BigDecimal findRatePerNight(String roomType, LocalDate onDate) throws SQLException {
        String sql =
            "SELECT rate_per_night " +
            "FROM room_rates " +
            "WHERE room_type=? AND is_active=1 " +
            "AND effective_from <= ? " +
            "AND (effective_to IS NULL OR effective_to >= ?) " +
            "ORDER BY effective_from DESC LIMIT 1";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomType);
            ps.setDate(2, Date.valueOf(onDate));
            ps.setDate(3, Date.valueOf(onDate));

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return rs.getBigDecimal("rate_per_night");
            }
        }
    }
}