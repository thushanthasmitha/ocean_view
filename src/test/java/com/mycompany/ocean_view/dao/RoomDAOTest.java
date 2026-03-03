package com.mycompany.ocean_view.dao;

import com.mycompany.ocean_view.model.Room;
import org.junit.Test;
import static org.junit.Assert.*;
import java.util.List;

public class RoomDAOTest {

    @Test
    public void testRoomCRUD() {
        System.out.println("Starting Room DAO CRUD Test...");
        RoomDAO dao = new RoomDAO();
        
        
        String testRoomNo = "R-" + System.currentTimeMillis() % 10000;

        try {
            
            System.out.println("Testing Insert Room...");
            
            dao.insertRoom(testRoomNo, "DELUXE", "ACTIVE");

            
            System.out.println("Testing Find All Rooms...");
            List<Room> allRooms = dao.findAll();
            assertNotNull("Room list should not be null", allRooms);
            assertFalse("Room list should not be empty", allRooms.isEmpty());

            
            System.out.println("Testing List Active Rooms...");
            List<Room> activeRooms = dao.listActiveRooms();
            assertNotNull("Active rooms list should not be null", activeRooms);
            
            
            boolean found = false;
            for (Room r : activeRooms) {
                if (r.getRoomNumber().equals(testRoomNo)) {
                    found = true;
                    assertEquals("Room type should be DELUXE", "DELUXE", r.getRoomType());
                    assertEquals("Status should be ACTIVE", "ACTIVE", r.getStatus());
                    break;
                }
            }
            assertTrue("Inserted test room should be found in active list", found);

            System.out.println("Room DAO CRUD Test passed successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            fail("Test failed due to exception: " + e.getMessage());
        }
    }
}