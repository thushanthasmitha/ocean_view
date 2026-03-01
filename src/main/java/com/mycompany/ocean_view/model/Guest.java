package com.mycompany.ocean_view.model;

public class Guest {
    private long guestId;
    private String fullName;
    private String address;
    private String contactNumber;
    private String email;

    public long getGuestId() { return guestId; }
    public void setGuestId(long guestId) { this.guestId = guestId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}