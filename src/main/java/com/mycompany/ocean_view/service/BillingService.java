package com.mycompany.ocean_view.service;

import com.mycompany.ocean_view.dao.BillDAO;
import com.mycompany.ocean_view.dao.RateDAO;
import com.mycompany.ocean_view.model.ReservationDetails;

import java.math.BigDecimal;
import java.time.temporal.ChronoUnit;

public class BillingService {

    private final RateDAO rateDAO = new RateDAO();
    private final BillDAO billDAO = new BillDAO();

    public BillResult generateBill(ReservationDetails res, BigDecimal discount, BigDecimal tax, long generatedBy) throws Exception {

        if (billDAO.billExistsForReservation(res.getReservationId())) {
            throw new IllegalStateException("A bill has already been generated for this reservation.");
        }

        int nights = (int) ChronoUnit.DAYS.between(res.getCheckIn(), res.getCheckOut());
        if (nights <= 0) throw new IllegalArgumentException("Invalid nights count.");

        BigDecimal rate = rateDAO.findRatePerNight(res.getRoomType(), res.getCheckIn());
        if (rate == null) throw new IllegalStateException("Room rate not found. Please check the room_rates table.");

        if (discount == null) discount = BigDecimal.ZERO;
        if (tax == null) tax = BigDecimal.ZERO;

        BigDecimal subTotal = rate.multiply(BigDecimal.valueOf(nights));
        BigDecimal total = subTotal.subtract(discount).add(tax);

        billDAO.insertBill(res.getReservationId(), nights, rate, discount, tax, total, generatedBy);

        return new BillResult(nights, rate, subTotal, discount, tax, total);
    }

    public static class BillResult {
        public final int nights;
        public final BigDecimal rate;
        public final BigDecimal subTotal;
        public final BigDecimal discount;
        public final BigDecimal tax;
        public final BigDecimal total;

        public BillResult(int nights, BigDecimal rate, BigDecimal subTotal,
                          BigDecimal discount, BigDecimal tax, BigDecimal total) {
            this.nights = nights;
            this.rate = rate;
            this.subTotal = subTotal;
            this.discount = discount;
            this.tax = tax;
            this.total = total;
        }
    }
}