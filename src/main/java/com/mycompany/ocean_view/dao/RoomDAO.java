package com.mycompany.ocean_view.dao;

import com.mycompany.ocean_view.model.Room;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public void insertRoom(String roomNumber, String roomType, String status) throws Exception {
        String sql = "INSERT INTO rooms (room_number, room_type, status) VALUES (?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomNumber);
            ps.setString(2, roomType);
            ps.setString(3, status);

            ps.executeUpdate();
        }
    }

    public List<Room> findAll() throws Exception {
        String sql = "SELECT room_id, room_number, room_type, status FROM rooms ORDER BY room_number";
        List<Room> list = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Room r = mapRoom(rs);
                list.add(r);
            }
        }
        return list;
    }

    // ✅ THIS IS THE METHOD YOUR JSP NEEDS
    public List<Room> listActiveRooms() throws Exception {
        String sql = "SELECT room_id, room_number, room_type, status " +
                     "FROM rooms WHERE status = 'ACTIVE' ORDER BY room_number";

        List<Room> list = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room r = mapRoom(rs);
                list.add(r);
            }
        }
        return list;
    }

    // helper method (duplicate code reduce)
    private Room mapRoom(ResultSet rs) throws Exception {
        Room r = new Room();
        r.setRoomId(rs.getLong("room_id"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setRoomType(rs.getString("room_type"));
        r.setStatus(rs.getString("status"));
        return r;
    }
}