package com.mycompany.ocean_view.service;

import com.mycompany.ocean_view.dao.UserDAO;
import com.mycompany.ocean_view.model.User;

public class AuthService {
    private final UserDAO userDAO = new UserDAO();

    public User login(String username, String password) throws Exception {
        User user = userDAO.findActiveByUsername(username);
        if (user == null) return null;

        // A: plain password compare
        return user.getPasswordHash().equals(password) ? user : null;
    }
}