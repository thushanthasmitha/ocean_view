package com.mycompany.ocean_view.controller;

import com.mycompany.ocean_view.model.ReservationDetails;
import com.mycompany.ocean_view.service.ReservationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reservation/view")
public class ReservationViewServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession(false) == null || req.getSession(false).getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNumber = req.getParameter("reservationNumber");
        if (reservationNumber == null || reservationNumber.trim().isEmpty()) {
            req.getRequestDispatcher("/reservation_view.jsp").forward(req, resp);
            return;
        }

        try {
            ReservationDetails res = reservationService.getReservation(reservationNumber.trim());
            if (res == null) {
                req.setAttribute("error", "Reservation not found.");
            } else {
                req.setAttribute("res", res);
            }
            req.getRequestDispatcher("/reservation_view.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/reservation_view.jsp").forward(req, resp);
        }
    }
}