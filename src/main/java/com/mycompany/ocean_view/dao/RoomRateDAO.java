package com.mycompany.ocean_view.dao;

import com.mycompany.ocean_view.model.RoomRate;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RoomRateDAO {

   
    public BigDecimal findRateForRoomTypeOnDate(String roomType, LocalDate onDate) throws SQLException {
        String sql =
            "SELECT rate_per_night " +
            "FROM room_rates " +
            "WHERE room_type=? AND is_active=1 " +
            "  AND effective_from <= ? " +
            "  AND (effective_to IS NULL OR effective_to >= ?) " +
            "ORDER BY effective_from DESC " +
            "LIMIT 1";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomType);
            ps.setDate(2, Date.valueOf(onDate));
            ps.setDate(3, Date.valueOf(onDate));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("rate_per_night");
                return null;
            }
        }
    }

    public List<RoomRate> findAll() throws SQLException {
        String sql =
            "SELECT rate_id, room_type, rate_per_night, effective_from, effective_to, is_active " +
            "FROM room_rates " +
            "ORDER BY room_type, effective_from DESC, rate_id DESC";

        List<RoomRate> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RoomRate rr = new RoomRate();
                rr.setRateId(rs.getLong("rate_id"));
                rr.setRoomType(rs.getString("room_type"));
                rr.setRatePerNight(rs.getBigDecimal("rate_per_night"));
                rr.setEffectiveFrom(rs.getDate("effective_from").toLocalDate());

                Date to = rs.getDate("effective_to");
                rr.setEffectiveTo(to == null ? null : to.toLocalDate());

                rr.setActive(rs.getInt("is_active") == 1);
                list.add(rr);
            }
        }
        return list;
    }

    public void insert(RoomRate rr) throws SQLException {
        String sql =
            "INSERT INTO room_rates (room_type, rate_per_night, effective_from, effective_to, is_active) " +
            "VALUES (?,?,?,?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, rr.getRoomType());
            ps.setBigDecimal(2, rr.getRatePerNight());
            ps.setDate(3, Date.valueOf(rr.getEffectiveFrom()));
            if (rr.getEffectiveTo() == null) ps.setNull(4, Types.DATE);
            else ps.setDate(4, Date.valueOf(rr.getEffectiveTo()));
            ps.setInt(5, rr.isActive() ? 1 : 0);

            ps.executeUpdate();
        }
    }

    public void setActive(long rateId, int isActive) throws SQLException {
        String sql = "UPDATE room_rates SET is_active=? WHERE rate_id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, isActive);
            ps.setLong(2, rateId);
            ps.executeUpdate();
        }
    }
}