package com.mycompany.ocean_view.controller;

import com.mycompany.ocean_view.model.Guest;
import com.mycompany.ocean_view.service.ReservationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/reservation/add")
public class ReservationServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();

    private boolean notLoggedIn(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s == null || s.getAttribute("userId") == null);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (notLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/reservation_add.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (notLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Guest
            String fullName = req.getParameter("fullName");
            String address = req.getParameter("address");
            String contactNumber = req.getParameter("contactNumber");
            String email = req.getParameter("email");

            // Reservation
            String reservationNumber = req.getParameter("reservationNumber");
            long roomId = Long.parseLong(req.getParameter("roomId"));
            LocalDate checkIn = LocalDate.parse(req.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(req.getParameter("checkOut"));

            HttpSession session = req.getSession(false);
            long createdBy = (long) session.getAttribute("userId");

            Guest guest = new Guest();
            guest.setFullName(fullName);
            guest.setAddress(address);
            guest.setContactNumber(contactNumber);
            guest.setEmail(email);

            reservationService.addReservation(reservationNumber, guest, roomId, checkIn, checkOut, createdBy);

            req.setAttribute("msg", "Reservation saved successfully.");
            req.getRequestDispatcher("/reservation_add.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/reservation_add.jsp").forward(req, resp);
        }
    }
}