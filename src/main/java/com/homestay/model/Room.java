package com.homestay.model;

public class Room {

    private int id;
    private String roomNumber;
    private String type;
    private java.math.BigDecimal price;
    private String status;
    private String description;
    private int homestayId;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public java.math.BigDecimal getPrice() { return price; }
    public void setPrice(java.math.BigDecimal price) { this.price = price; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getHomestayId() { return homestayId; }
    public void setHomestayId(int homestayId) { this.homestayId = homestayId; }
}
