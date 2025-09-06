package com.homestay.dao;

import com.homestay.model.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class ServiceDao {
    @Autowired
    private DataSource dataSource;

    public List<Service> getServicesByHomestayId(int homestayId) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE homestay_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setPrice(rs.getBigDecimal("price"));
                    s.setDescription(rs.getString("description"));
                    s.setHomestayId(rs.getInt("homestay_id"));
                    try { s.setCategoryId((Integer) rs.getObject("category_id")); } catch (Exception ignore) {}
                    services.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return services;
    }

    public List<Service> getServicesByBookingId(int bookingId) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.* FROM services s " +
                    "JOIN booking_services bs ON s.id = bs.service_id " +
                    "WHERE bs.booking_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setPrice(rs.getBigDecimal("price"));
                    s.setDescription(rs.getString("description"));
                    s.setHomestayId(rs.getInt("homestay_id"));
                    try { s.setCategoryId((Integer) rs.getObject("category_id")); } catch (Exception ignore) {}
                    services.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return services;
    }

    public boolean addService(com.homestay.model.Service service) {
        String sql = "INSERT INTO services (name, price, description, homestay_id, category_id) VALUES (?, ?, ?, ?, ?)";
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, n(service.getName()));
            ps.setBigDecimal(2, service.getPrice());
            ps.setString(3, n(service.getDescription()));
            ps.setInt(4, service.getHomestayId());
            if (service.getCategoryId() != null) ps.setInt(5, service.getCategoryId()); else ps.setNull(5, java.sql.Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public com.homestay.model.Service getServiceById(int id) {
        String sql = "SELECT * FROM services WHERE id = ?";
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    com.homestay.model.Service s = new com.homestay.model.Service();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setPrice(rs.getBigDecimal("price"));
                    s.setDescription(rs.getString("description"));
                    s.setHomestayId(rs.getInt("homestay_id"));
                    try { s.setCategoryId((Integer) rs.getObject("category_id")); } catch (Exception ignore) {}
                    return s;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean updateService(com.homestay.model.Service service) {
        String sql = "UPDATE services SET name=?, price=?, description=?, category_id=? WHERE id=?";
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, n(service.getName()));
            ps.setBigDecimal(2, service.getPrice());
            ps.setString(3, n(service.getDescription()));
            if (service.getCategoryId() != null) ps.setInt(4, service.getCategoryId()); else ps.setNull(4, java.sql.Types.INTEGER);
            ps.setInt(5, service.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean deleteService(int id) {
        String sql = "DELETE FROM services WHERE id = ?";
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Service s = new Service();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setPrice(rs.getBigDecimal("price"));
                s.setDescription(rs.getString("description"));
                s.setHomestayId(rs.getInt("homestay_id"));
                try { s.setCategoryId((Integer) rs.getObject("category_id")); } catch (Exception ignore) {}
                services.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return services;
    }

    // Lấy các dịch vụ mẫu (loại bỏ trùng lặp theo tên)
    public List<Service> getDistinctServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT DISTINCT name, price, description, category_id FROM services ORDER BY name";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Service s = new Service();
                s.setId(0); // ID tạm thời
                s.setName(rs.getString("name"));
                s.setPrice(rs.getBigDecimal("price"));
                s.setDescription(rs.getString("description"));
                s.setHomestayId(0); // Không thuộc về homestay cụ thể
                try { s.setCategoryId((Integer) rs.getObject("category_id")); } catch (Exception ignore) {}
                services.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return services;
    }

    private String n(String s) {
        if (s == null) return null;
        String t = s.trim();
        if (t.isEmpty()) return null;
        if ("null".equalsIgnoreCase(t)) return null;
        return s;
    }
}
