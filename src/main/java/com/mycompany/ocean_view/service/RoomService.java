package com.mycompany.ocean_view.service;

import com.mycompany.ocean_view.dao.RoomDAO;
import com.mycompany.ocean_view.model.Room;

import java.util.List;

public class RoomService {

    private final RoomDAO roomDAO = new RoomDAO();

    public void addRoom(String roomNumber, String roomType, String status) throws Exception {
        roomDAO.insertRoom(roomNumber, roomType, status);
    }

    public List<Room> getAllRooms() throws Exception {
        return roomDAO.findAll();
    }
}