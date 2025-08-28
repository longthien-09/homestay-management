package com.homestay.dao;

import org.springframework.beans.factory.annotation.Autowired;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;
import org.springframework.stereotype.Repository;

@Repository
public class PaymentDao {
    @Autowired
    private DataSource dataSource;

    public List<Map<String,Object>> findByUser(int userId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT p.*, b.user_id FROM payments p JOIN bookings b ON p.booking_id=b.id WHERE b.user_id=? ORDER BY p.payment_date DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(rowToMap(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String,Object>> findByHomestayIds(List<Integer> homestayIds) {
        List<Map<String,Object>> list = new ArrayList<>();
        if (homestayIds == null || homestayIds.isEmpty()) return list;
        String inClause = String.join(",", Collections.nCopies(homestayIds.size(), "?"));
        String sql = "SELECT p.*, b.user_id, r.homestay_id FROM payments p JOIN bookings b ON p.booking_id=b.id JOIN rooms r ON b.room_id=r.id WHERE r.homestay_id IN ("+inClause+") ORDER BY p.payment_date DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i=0;i<homestayIds.size();i++) ps.setInt(i+1, homestayIds.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(rowToMap(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Map<String,Object> findById(int id) {
        String sql = "SELECT * FROM payments WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rowToMap(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public Map<String,Object> findByBookingId(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id=? ORDER BY id DESC LIMIT 1";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rowToMap(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void updateStatus(int id, String status) {
        String sql = "UPDATE payments SET status=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void updateStatusAndMethod(int id, String status, String method) {
        String sql = "UPDATE payments SET status=?, method=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, method);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public int createPayment(int bookingId, java.math.BigDecimal amount) {
        String sql = "INSERT INTO payments (booking_id, amount, status) VALUES (?, ?, 'UNPAID')";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bookingId);
            ps.setBigDecimal(2, amount);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    private Map<String,Object> rowToMap(ResultSet rs) throws SQLException {
        Map<String,Object> m = new HashMap<>();
        ResultSetMetaData meta = rs.getMetaData();
        for (int i=1;i<=meta.getColumnCount();i++) {
            m.put(meta.getColumnLabel(i), rs.getObject(i));
        }
        return m;
    }
}
