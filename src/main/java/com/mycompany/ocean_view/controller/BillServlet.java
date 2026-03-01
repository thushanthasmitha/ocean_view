package com.mycompany.ocean_view.controller;

import com.mycompany.ocean_view.dao.BillDAO;
import com.mycompany.ocean_view.dao.ReservationDAO;
import com.mycompany.ocean_view.model.ReservationDetails;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/bill/generate")
public class BillServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final BillDAO billDAO = new BillDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/bill.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            // session check (optional but recommended)
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("username") == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String reservationNumber = req.getParameter("reservationNumber");
            BigDecimal discount = parseMoney(req.getParameter("discount"));
            BigDecimal tax = parseMoney(req.getParameter("tax"));

            if (reservationNumber == null || reservationNumber.trim().isEmpty()) {
                req.setAttribute("error", "Reservation number is required.");
                req.getRequestDispatcher("/bill.jsp").forward(req, resp);
                return;
            }

            ReservationDetails res = reservationDAO.findByReservationNumber(reservationNumber.trim());
            if (res == null) {
                req.setAttribute("error", "Reservation not found.");
                req.getRequestDispatcher("/bill.jsp").forward(req, resp);
                return;
            }

            LocalDate checkIn = res.getCheckIn();
            LocalDate checkOut = res.getCheckOut();
            String roomType = res.getRoomType(); // STANDARD / DELUXE / SUITE (from rooms table)

            BigDecimal rate = billDAO.findRateForRoomType(roomType, checkIn);
            if (rate == null) {
                req.setAttribute("error", "Room rate not found. Please check the room_rates table.");
                req.getRequestDispatcher("/bill.jsp").forward(req, resp);
                return;
            }

            long nightsLong = ChronoUnit.DAYS.between(checkIn, checkOut);
            int nights = (int) Math.max(1, nightsLong);

            BigDecimal subtotal = rate.multiply(new BigDecimal(nights));

            if (discount.compareTo(BigDecimal.ZERO) < 0) discount = BigDecimal.ZERO;
            if (tax.compareTo(BigDecimal.ZERO) < 0) tax = BigDecimal.ZERO;

            BigDecimal total = subtotal.subtract(discount).add(tax);
            if (total.compareTo(BigDecimal.ZERO) < 0) total = BigDecimal.ZERO;

            // generated_by (users.user_id)
            long generatedBy = getLoggedUserId(session);

            // bills.reservation_id UNIQUE -> insert or update
            boolean exists = billDAO.billExistsForReservation(res.getReservationId());
            if (!exists) {
                billDAO.insertBill(res.getReservationId(), nights, rate, discount, tax, total, generatedBy);
            } else {
                billDAO.updateBill(res.getReservationId(), nights, rate, discount, tax, total, generatedBy);
            }

            req.setAttribute("success", "Bill generated successfully!");
            req.setAttribute("reservation", res);
            req.setAttribute("nights", nights);
            req.setAttribute("rate", rate);
            req.setAttribute("discount", discount);
            req.setAttribute("tax", tax);
            req.setAttribute("total", total);

            req.getRequestDispatcher("/bill.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Error generating bill: " + e.getMessage());
            req.getRequestDispatcher("/bill.jsp").forward(req, resp);
        }
    }

    private BigDecimal parseMoney(String s) {
        if (s == null || s.trim().isEmpty()) return BigDecimal.ZERO;
        try {
            return new BigDecimal(s.trim());
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private long getLoggedUserId(HttpSession session) {
        Object obj = session.getAttribute("userId");
        if (obj == null) {
            // fallback - but better: set userId in LoginServlet at login success
            return 1L;
        }
        if (obj instanceof Long) return (Long) obj;
        if (obj instanceof Integer) return ((Integer) obj).longValue();
        return 1L;
    }
}