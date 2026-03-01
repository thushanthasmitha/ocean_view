package com.mycompany.ocean_view.controller;

import com.mycompany.ocean_view.model.Room;
import com.mycompany.ocean_view.service.RoomService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/rooms")
public class RoomServlet extends HttpServlet {

    private final RoomService roomService = new RoomService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // Only ADMIN or MANAGER allowed
        if (!"ADMIN".equals(role) && !"MANAGER".equals(role)) {
            resp.sendRedirect("dashboard.jsp");
            return;
        }

        try {
            List<Room> rooms = roomService.getAllRooms();
            req.setAttribute("rooms", rooms);
            req.getRequestDispatcher("room_manage.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equals(role) && !"MANAGER".equals(role)) {
            resp.sendRedirect("dashboard.jsp");
            return;
        }

        String roomNumber = req.getParameter("roomNumber");
        String roomType = req.getParameter("roomType");
        String status = req.getParameter("status");

        try {
            roomService.addRoom(roomNumber, roomType, status);
            resp.sendRedirect("rooms");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}