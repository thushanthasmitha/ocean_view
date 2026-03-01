package com.mycompany.ocean_view.controller;

import com.mycompany.ocean_view.model.ReservationDetails;
import com.mycompany.ocean_view.service.BillingService;
import com.mycompany.ocean_view.service.ReservationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/bill/generate")
public class BillServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();
    private final BillingService billingService = new BillingService();

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

        req.getRequestDispatcher("/bill.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (notLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String reservationNumber = req.getParameter("reservationNumber");

            // optional inputs (if empty -> 0)
            BigDecimal discount = parseMoney(req.getParameter("discount"));
            BigDecimal tax = parseMoney(req.getParameter("tax"));

            HttpSession session = req.getSession(false);
            long generatedBy = (long) session.getAttribute("userId");

            ReservationDetails details = reservationService.getReservation(reservationNumber);
            if (details == null) {
                req.setAttribute("error", "Reservation not found.");
                req.getRequestDispatcher("/bill.jsp").forward(req, resp);
                return;
            }

            BillingService.BillResult bill = billingService.generateBill(details, discount, tax, generatedBy);

            req.setAttribute("details", details);
            req.setAttribute("bill", bill);
            req.setAttribute("msg", "Bill generated successfully.");

            req.getRequestDispatcher("/bill.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/bill.jsp").forward(req, resp);
        }
    }

    private BigDecimal parseMoney(String s) {
        if (s == null) return BigDecimal.ZERO;
        s = s.trim();
        if (s.isEmpty()) return BigDecimal.ZERO;
        return new BigDecimal(s);
    }
}