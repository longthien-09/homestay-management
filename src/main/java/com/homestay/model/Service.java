package com.homestay.model;

public class Service {
    private int id;
    private String name;
    private java.math.BigDecimal price;
    private String description;
    private int homestayId;
    private Integer categoryId; // nullable until DB updated

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public java.math.BigDecimal getPrice() { return price; }
    public void setPrice(java.math.BigDecimal price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getHomestayId() { return homestayId; }
    public void setHomestayId(int homestayId) { this.homestayId = homestayId; }

    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }
}
