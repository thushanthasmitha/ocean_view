package com.mycompany.ocean_view.dao;

import com.mycompany.ocean_view.model.ReservationDetails;
import java.sql.*;
import java.time.LocalDate;

public class ReservationDAO {

    // Overlap rule: existing.check_in < new.check_out AND existing.check_out > new.check_in
    public boolean isRoomAvailable(long roomId, LocalDate checkIn, LocalDate checkOut) throws SQLException {
        String sql =
            "SELECT COUNT(*) AS cnt " +
            "FROM reservations " +
            "WHERE room_id=? AND status IN ('BOOKED','CHECKED_IN') " +
            "AND check_in < ? AND check_out > ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, roomId);
            ps.setDate(2, Date.valueOf(checkOut));
            ps.setDate(3, Date.valueOf(checkIn));

            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt("cnt") == 0;
            }
        }
    }

    public long insertReservation(String reservationNumber, long guestId, long roomId,
                                 LocalDate checkIn, LocalDate checkOut, long createdBy) throws SQLException {
        String sql = "INSERT INTO reservations (reservation_number, guest_id, room_id, check_in, check_out, created_by) " +
                     "VALUES (?,?,?,?,?,?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, reservationNumber);
            ps.setLong(2, guestId);
            ps.setLong(3, roomId);
            ps.setDate(4, Date.valueOf(checkIn));
            ps.setDate(5, Date.valueOf(checkOut));
            ps.setLong(6, createdBy);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        throw new SQLException("Reservation insert failed.");
    }

    public ReservationDetails findByReservationNumber(String reservationNumber) throws SQLException {
        String sql =
            "SELECT r.reservation_id, r.reservation_number, r.check_in, r.check_out, r.status, " +
            "       g.guest_id, g.full_name, g.address, g.contact_number, g.email, " +
            "       rm.room_id, rm.room_number, rm.room_type, " +
            "       u.user_id, u.username " +
            "FROM reservations r " +
            "JOIN guests g ON r.guest_id=g.guest_id " +
            "JOIN rooms rm ON r.room_id=rm.room_id " +
            "JOIN users u ON r.created_by=u.user_id " +
            "WHERE r.reservation_number=?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, reservationNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                ReservationDetails d = new ReservationDetails();
                d.setReservationId(rs.getLong("reservation_id"));
                d.setReservationNumber(rs.getString("reservation_number"));
                d.setCheckIn(rs.getDate("check_in").toLocalDate());
                d.setCheckOut(rs.getDate("check_out").toLocalDate());
                d.setStatus(rs.getString("status"));

                d.setGuestId(rs.getLong("guest_id"));
                d.setGuestName(rs.getString("full_name"));
                d.setGuestAddress(rs.getString("address"));
                d.setGuestContact(rs.getString("contact_number"));
                d.setGuestEmail(rs.getString("email"));

                d.setRoomId(rs.getLong("room_id"));
                d.setRoomNumber(rs.getString("room_number"));
                d.setRoomType(rs.getString("room_type"));

                d.setCreatedByUserId(rs.getLong("user_id"));
                d.setCreatedByUsername(rs.getString("username"));

                return d;
            }
        }
    }
}