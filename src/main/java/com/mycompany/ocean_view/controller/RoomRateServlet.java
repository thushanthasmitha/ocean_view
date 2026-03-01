package com.mycompany.ocean_view.controller;

import com.mycompany.ocean_view.dao.RoomRateDAO;
import com.mycompany.ocean_view.model.RoomRate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet(urlPatterns = {"/rates/manage"})
public class RoomRateServlet extends HttpServlet {

    private final RoomRateDAO roomRateDAO = new RoomRateDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setAttribute("rates", roomRateDAO.findAll());
            request.getRequestDispatcher("/room_rates.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {

                RoomRate rr = new RoomRate();
                rr.setRoomType(request.getParameter("roomType")); // STANDARD/DELUXE/SUITE
                rr.setRatePerNight(new BigDecimal(request.getParameter("ratePerNight")));
                rr.setEffectiveFrom(LocalDate.parse(request.getParameter("effectiveFrom")));

                String effectiveTo = request.getParameter("effectiveTo");
                rr.setEffectiveTo((effectiveTo == null || effectiveTo.isBlank())
                        ? null
                        : LocalDate.parse(effectiveTo));

                rr.setActive("1".equals(request.getParameter("isActive")));
                roomRateDAO.insert(rr);

            } else if ("toggle".equals(action)) {

                long rateId = Long.parseLong(request.getParameter("rateId"));
                int isActive = Integer.parseInt(request.getParameter("isActive"));
                roomRateDAO.setActive(rateId, isActive);
            }

            response.sendRedirect(request.getContextPath() + "/rates/manage");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}