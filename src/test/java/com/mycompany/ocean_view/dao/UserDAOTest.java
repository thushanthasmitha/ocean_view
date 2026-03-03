package com.mycompany.ocean_view.dao;

import com.mycompany.ocean_view.model.User;
import org.junit.Test;
import static org.junit.Assert.*;
import java.util.List;

public class UserDAOTest {

    @Test
    public void testUserCRUD() {
        System.out.println("Starting User DAO CRUD Test...");
        UserDAO dao = new UserDAO();
        String testUsername = "test_user_" + System.currentTimeMillis();

        try {
            
            System.out.println("Testing Insert...");
            dao.insertUser(testUsername, "pass123", "ADMIN", 1);

            
            System.out.println("Testing Read/Find...");
            User foundUser = dao.findByUsername(testUsername);
            assertNotNull("User should be found in database", foundUser);
            assertEquals("Username should match", testUsername, foundUser.getUsername());
            long userId = foundUser.getUserId();

            
            System.out.println("Testing Update Role...");
            dao.updateRole(userId, "MANAGER");
            User updatedUser = dao.findByUsername(testUsername);
            assertEquals("Role should be updated to MANAGER", "MANAGER", updatedUser.getRole());

            
            System.out.println("Testing Update Password...");
            dao.updatePassword(userId, "new_secure_pass");
            
            
            System.out.println("Testing Find All...");
            List<User> userList = dao.findAll();
            assertTrue("User list should not be empty", userList.size() > 0);

            System.out.println("✅ All UserDAO tests passed successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            fail("Test failed due to exception: " + e.getMessage());
        }
    }
}