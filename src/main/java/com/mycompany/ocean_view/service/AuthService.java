package com.mycompany.ocean_view.service;

import com.mycompany.ocean_view.dao.UserDAO;
import com.mycompany.ocean_view.model.User;

public class AuthService {

    private final UserDAO userDAO = new UserDAO();

    public User login(String username, String password) throws Exception {
        if (username == null || password == null) return null;

        User user = userDAO.findActiveByUsername(username.trim());
        if (user == null) return null;

        
        return password.equals(user.getPasswordHash()) ? user : null;
    }
}