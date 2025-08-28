package com.homestay.dao;

import com.homestay.model.Booking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Repository
public class BookingDao {
    @Autowired
    private DataSource dataSource;

    public boolean isRoomAvailable(int roomId, java.sql.Date checkIn, java.sql.Date checkOut) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE room_id=? AND status IN ('PENDING','CONFIRMED') AND NOT (check_out <= ? OR check_in >= ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, checkIn);
            ps.setDate(3, checkOut);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int create(Booking b) {
        String sql = "INSERT INTO bookings (user_id, room_id, check_in, check_out, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, b.getUserId());
            ps.setInt(2, b.getRoomId());
            ps.setDate(3, b.getCheckIn());
            ps.setDate(4, b.getCheckOut());
            ps.setString(5, b.getStatus());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE bookings SET status=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Booking> findByUser(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE user_id=? ORDER BY created_at DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Booking findById(int id) {
        String sql = "SELECT * FROM bookings WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<Map<String,Object>> adminList(Integer homestayId, String status) {
        List<Map<String,Object>> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT b.id, b.check_in, b.check_out, b.status, b.created_at, ");
        sb.append("u.full_name AS user_name, u.username, r.room_number, r.id AS room_id, h.name AS homestay_name, h.id AS homestay_id ");
        sb.append("FROM bookings b JOIN users u ON b.user_id=u.id JOIN rooms r ON b.room_id=r.id JOIN homestays h ON r.homestay_id=h.id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (homestayId != null) { sb.append(" AND h.id=?"); params.add(homestayId); }
        if (status != null && !status.isEmpty()) { sb.append(" AND b.status=?"); params.add(status); }
        sb.append(" ORDER BY b.created_at DESC");
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i=0;i<params.size();i++) ps.setObject(i+1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> row = new HashMap<>();
                    row.put("id", rs.getInt("id"));
                    row.put("check_in", rs.getDate("check_in"));
                    row.put("check_out", rs.getDate("check_out"));
                    row.put("status", rs.getString("status"));
                    row.put("created_at", rs.getTimestamp("created_at"));
                    row.put("user_name", rs.getString("user_name"));
                    row.put("username", rs.getString("username"));
                    row.put("room_number", rs.getString("room_number"));
                    row.put("room_id", rs.getInt("room_id"));
                    row.put("homestay_name", rs.getString("homestay_name"));
                    row.put("homestay_id", rs.getInt("homestay_id"));
                    list.add(row);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Lưu dịch vụ bổ sung đã chọn cho một booking
    public void addServicesToBooking(int bookingId, List<Integer> serviceIds) {
        if (serviceIds == null || serviceIds.isEmpty()) return;
        String sql = "INSERT INTO booking_services (booking_id, service_id) VALUES (?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer sid : serviceIds) {
                if (sid == null) continue;
                ps.setInt(1, bookingId);
                ps.setInt(2, sid);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy các booking đang hoạt động của user (PENDING/CONFIRMED) kèm thông tin homestay
    public List<Map<String,Object>> findActiveBookingsByUser(int userId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT b.id AS booking_id, h.id AS homestay_id, h.name AS homestay_name, b.status, b.check_in, b.check_out " +
                     "FROM bookings b " +
                     "JOIN rooms r ON b.room_id=r.id " +
                     "JOIN homestays h ON r.homestay_id=h.id " +
                     "WHERE b.user_id=? AND b.status IN ('PENDING','CONFIRMED') ORDER BY b.created_at DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> m = new HashMap<>();
                    m.put("booking_id", rs.getInt("booking_id"));
                    m.put("homestay_id", rs.getInt("homestay_id"));
                    m.put("homestay_name", rs.getString("homestay_name"));
                    m.put("status", rs.getString("status"));
                    m.put("check_in", rs.getDate("check_in"));
                    m.put("check_out", rs.getDate("check_out"));
                    list.add(m);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setUserId(rs.getInt("user_id"));
        b.setRoomId(rs.getInt("room_id"));
        b.setCheckIn(rs.getDate("check_in"));
        b.setCheckOut(rs.getDate("check_out"));
        b.setStatus(rs.getString("status"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        return b;
    }
}
