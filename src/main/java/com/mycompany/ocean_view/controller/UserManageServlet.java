package com.mycompany.ocean_view.controller;

import com.mycompany.ocean_view.dao.UserDAO;
import com.mycompany.ocean_view.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/users/manage")
public class UserManageServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<User> users = userDAO.findAll();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/user_manage.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                String role = req.getParameter("role");
                int active = Integer.parseInt(req.getParameter("active"));
                userDAO.insertUser(username, password, role, active);

            } else if ("toggleActive".equals(action)) {
                long userId = Long.parseLong(req.getParameter("userId"));
                int active = Integer.parseInt(req.getParameter("active"));
                userDAO.updateActive(userId, active);

            } else if ("updateRole".equals(action)) {
                long userId = Long.parseLong(req.getParameter("userId"));
                String role = req.getParameter("role");
                userDAO.updateRole(userId, role);

            } else if ("resetPassword".equals(action)) {
                long userId = Long.parseLong(req.getParameter("userId"));
                String newPassword = req.getParameter("newPassword");
                userDAO.updatePassword(userId, newPassword);
            }

            // IMPORTANT: always redirect back correctly
            resp.sendRedirect(req.getContextPath() + "/users/manage");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}