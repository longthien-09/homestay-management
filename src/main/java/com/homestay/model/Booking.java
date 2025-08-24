package com.homestay.model;

public class Booking {

    private int id;
    private int userId;
    private int roomId;
    private java.sql.Date checkIn;
    private java.sql.Date checkOut;
    private String status; // PENDING, CONFIRMED, CANCELLED
    private java.sql.Timestamp createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public java.sql.Date getCheckIn() { return checkIn; }
    public void setCheckIn(java.sql.Date checkIn) { this.checkIn = checkIn; }

    public java.sql.Date getCheckOut() { return checkOut; }
    public void setCheckOut(java.sql.Date checkOut) { this.checkOut = checkOut; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
}
