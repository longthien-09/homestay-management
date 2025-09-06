package com.homestay.dao;

import com.homestay.model.Booking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.*;
import java.util.HashMap;

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
    
    public boolean updateBookingDates(int id, java.time.LocalDate checkIn, java.time.LocalDate checkOut) {
        String sql = "UPDATE bookings SET check_in=?, check_out=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(checkIn));
            ps.setDate(2, java.sql.Date.valueOf(checkOut));
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateBookingDatesAndRecalculate(int id, java.time.LocalDate checkIn, java.time.LocalDate checkOut) {
        try (Connection conn = dataSource.getConnection()) {
            conn.setAutoCommit(false);
            
            // 1. Cập nhật ngày check-in và check-out
            String updateBookingSql = "UPDATE bookings SET check_in=?, check_out=? WHERE id=?";
            try (PreparedStatement ps1 = conn.prepareStatement(updateBookingSql)) {
                ps1.setDate(1, java.sql.Date.valueOf(checkIn));
                ps1.setDate(2, java.sql.Date.valueOf(checkOut));
                ps1.setInt(3, id);
                ps1.executeUpdate();
            }
            
            // 2. Cập nhật số tiền thanh toán dựa trên giá phòng mới
            String updatePaymentSql = "UPDATE payments p " +
                                    "JOIN bookings b ON p.booking_id = b.id " +
                                    "JOIN rooms r ON b.room_id = r.id " +
                                    "SET p.amount = r.price * DATEDIFF(?, ?) " +
                                    "WHERE b.id = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(updatePaymentSql)) {
                ps2.setDate(1, java.sql.Date.valueOf(checkOut));
                ps2.setDate(2, java.sql.Date.valueOf(checkIn));
                ps2.setInt(3, id);
                ps2.executeUpdate();
            }
            
            conn.commit();
            return true;
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

    public List<Map<String,Object>> findDetailedByUser(int userId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT b.*, r.room_number, h.name as homestay_name, " +
                    "DATE_FORMAT(b.created_at, '%d/%m/%Y') as created_date_formatted, " +
                    "DATE_FORMAT(b.created_at, '%H:%i') as created_time, " +
                    "CASE " +
                    "  WHEN b.status = 'CANCELLED' THEN 'CANCELLED' " +
                    "  WHEN b.status = 'PENDING' THEN 'PENDING' " +
                    "  WHEN b.status = 'CONFIRMED' AND CURDATE() < b.check_in THEN 'CONFIRMED' " +
                    "  WHEN b.status = 'CONFIRMED' AND CURDATE() >= b.check_in AND CURDATE() < b.check_out THEN 'CHECKED_IN' " +
                    "  WHEN b.status = 'CONFIRMED' AND CURDATE() >= b.check_out THEN 'CHECKED_OUT' " +
                    "  ELSE 'PENDING' " +
                    "END AS booking_status " +
                    "FROM bookings b " +
                    "JOIN rooms r ON b.room_id = r.id " +
                    "JOIN homestays h ON r.homestay_id = h.id " +
                    "WHERE b.user_id=? ORDER BY b.created_at DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> row = new HashMap<>();
                    row.put("id", rs.getInt("id"));
                    row.put("user_id", rs.getInt("user_id"));
                    row.put("room_id", rs.getInt("room_id"));
                    row.put("check_in", rs.getDate("check_in"));
                    row.put("check_out", rs.getDate("check_out"));
                    row.put("status", rs.getString("status"));
                    row.put("created_at", rs.getTimestamp("created_at"));
                    row.put("room_number", rs.getString("room_number"));
                    row.put("homestay_name", rs.getString("homestay_name"));
                    row.put("created_date_formatted", rs.getString("created_date_formatted"));
                    row.put("created_time", rs.getString("created_time"));
                    row.put("booking_status", rs.getString("booking_status"));
                    list.add(row);
                }
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
        sb.append("u.full_name AS user_name, u.username, u.phone, r.room_number, r.type AS room_type, r.id AS room_id, ");
        sb.append("h.name AS homestay_name, h.id AS homestay_id, r.price AS room_price, ");
        sb.append("DATEDIFF(b.check_out, b.check_in) AS nights, ");
        sb.append("(r.price * DATEDIFF(b.check_out, b.check_in)) AS total_amount, ");
        sb.append("CASE ");
        sb.append("  WHEN b.status = 'CANCELLED' THEN 'CANCELLED' ");
        sb.append("  WHEN b.status = 'PENDING' THEN 'PENDING' ");
        sb.append("  WHEN b.status = 'CONFIRMED' AND CURDATE() < b.check_in THEN 'CONFIRMED' ");
        sb.append("  WHEN b.status = 'CONFIRMED' AND CURDATE() >= b.check_in AND CURDATE() < b.check_out THEN 'CHECKED_IN' ");
        sb.append("  WHEN b.status = 'CONFIRMED' AND CURDATE() >= b.check_out THEN 'CHECKED_OUT' ");
        sb.append("  ELSE 'PENDING' ");
        sb.append("END AS booking_status, ");
        sb.append("COALESCE(p.status, 'UNPAID') AS payment_status ");
        sb.append("FROM bookings b ");
        sb.append("JOIN users u ON b.user_id=u.id ");
        sb.append("JOIN rooms r ON b.room_id=r.id ");
        sb.append("JOIN homestays h ON r.homestay_id=h.id ");
        sb.append("LEFT JOIN payments p ON b.id=p.booking_id ");
        sb.append("WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (homestayId != null) { sb.append(" AND h.id=?"); params.add(homestayId); }
        if (status != null && !status.isEmpty()) { 
            if ("PENDING".equals(status)) {
                sb.append(" AND (b.status='PENDING' OR (b.status='CONFIRMED' AND CURDATE() < b.check_in))");
            } else if ("CHECKED_IN".equals(status)) {
                sb.append(" AND b.status='CONFIRMED' AND CURDATE() >= b.check_in AND CURDATE() < b.check_out");
            } else if ("CHECKED_OUT".equals(status)) {
                sb.append(" AND b.status='CONFIRMED' AND CURDATE() >= b.check_out");
            } else {
                sb.append(" AND b.status=?"); params.add(status);
            }
        }
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
                    row.put("phone", rs.getString("phone"));
                    row.put("room_number", rs.getString("room_number"));
                    row.put("room_type", rs.getString("room_type"));
                    row.put("room_id", rs.getInt("room_id"));
                    row.put("homestay_name", rs.getString("homestay_name"));
                    row.put("homestay_id", rs.getInt("homestay_id"));
                    row.put("room_price", rs.getBigDecimal("room_price"));
                    row.put("nights", rs.getInt("nights"));
                    row.put("total_amount", rs.getBigDecimal("total_amount"));
                    row.put("booking_status", rs.getString("booking_status"));
                    row.put("payment_status", rs.getString("payment_status"));
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
