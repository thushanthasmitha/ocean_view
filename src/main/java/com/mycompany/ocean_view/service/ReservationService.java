package com.mycompany.ocean_view.service;

import com.mycompany.ocean_view.dao.GuestDAO;
import com.mycompany.ocean_view.dao.ReservationDAO;
import com.mycompany.ocean_view.model.Guest;
import com.mycompany.ocean_view.model.ReservationDetails;

import java.time.LocalDate;

public class ReservationService {

    private final GuestDAO guestDAO = new GuestDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    public long addReservation(String reservationNumber, Guest guest, long roomId,
                               LocalDate checkIn, LocalDate checkOut, long createdBy) throws Exception {

        if (checkIn == null || checkOut == null || !checkOut.isAfter(checkIn)) {
            throw new IllegalArgumentException("Check-out date must be after check-in date.");
        }

        boolean available = reservationDAO.isRoomAvailable(roomId, checkIn, checkOut);
        if (!available) {
            throw new IllegalStateException("This room is already booked for the selected dates.");
        }

        long guestId = guestDAO.insertGuest(guest);

        return reservationDAO.insertReservation(reservationNumber, guestId, roomId, checkIn, checkOut, createdBy);
    }

    public ReservationDetails getReservation(String reservationNumber) throws Exception {
        return reservationDAO.findByReservationNumber(reservationNumber);
    }
}