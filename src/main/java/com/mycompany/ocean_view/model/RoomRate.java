package com.mycompany.ocean_view.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class RoomRate {
    private long rateId;
    private String roomType;          // STANDARD / DELUXE / SUITE
    private BigDecimal ratePerNight;
    private LocalDate effectiveFrom;
    private LocalDate effectiveTo;    // can be null
    private boolean active;

    public long getRateId() { return rateId; }
    public void setRateId(long rateId) { this.rateId = rateId; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public BigDecimal getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(BigDecimal ratePerNight) { this.ratePerNight = ratePerNight; }

    public LocalDate getEffectiveFrom() { return effectiveFrom; }
    public void setEffectiveFrom(LocalDate effectiveFrom) { this.effectiveFrom = effectiveFrom; }

    public LocalDate getEffectiveTo() { return effectiveTo; }
    public void setEffectiveTo(LocalDate effectiveTo) { this.effectiveTo = effectiveTo; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}