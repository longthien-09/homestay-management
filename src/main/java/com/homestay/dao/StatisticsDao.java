package com.homestay.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

@Repository
public class StatisticsDao {
    
    @Autowired
    private DataSource dataSource;
    
    // Danh sách homestay filter cấu hình qua properties, ví dụ: 1,2,3
    @Value("${manager.homestay.ids:}")
    private String configuredHomestayIds;

    private List<Integer> getConfiguredHomestayIdList() {
        if (configuredHomestayIds == null || configuredHomestayIds.trim().isEmpty()) return Collections.emptyList();
        List<Integer> ids = new ArrayList<>();
        for (String part : configuredHomestayIds.split(",")) {
            String trimmed = part.trim();
            if (trimmed.isEmpty()) continue;
            try { ids.add(Integer.parseInt(trimmed)); } catch (NumberFormatException ignore) { /* skip */ }
        }
        return ids;
    }

    private String buildInClausePlaceholders(int count) {
        if (count <= 0) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < count; i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
        return sb.toString();
    }
    
    public BigDecimal getTotalRevenue(int managerId) {
        List<Integer> ids = getConfiguredHomestayIdList();
        String sql;
        boolean useConfiguredIds = !ids.isEmpty();
        if (useConfiguredIds) {
            sql = "SELECT COALESCE(SUM(p.amount), 0) as total_revenue " +
                  "FROM payments p " +
                  "INNER JOIN bookings b ON p.booking_id = b.id " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "WHERE h.id IN (" + buildInClausePlaceholders(ids.size()) + ") AND p.status = 'PAID'";
        } else {
            sql = "SELECT COALESCE(SUM(p.amount), 0) as total_revenue " +
                  "FROM payments p " +
                  "INNER JOIN bookings b ON p.booking_id = b.id " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "INNER JOIN manager_homestays mh ON h.id = mh.homestay_id " +
                  "WHERE mh.user_id = ? AND p.status = 'PAID'";
        }
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (useConfiguredIds) {
                for (Integer id : ids) { ps.setInt(paramIndex++, id); }
            } else {
                ps.setInt(paramIndex, managerId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("total_revenue");
            }
        } catch (Exception e) {
            // Fallback: toàn hệ thống
            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "SELECT COALESCE(SUM(p.amount),0) FROM payments p WHERE p.status = 'COMPLETED'") ) {
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getBigDecimal(1); }
            } catch (Exception ignore) { e.printStackTrace(); }
        }
        return BigDecimal.ZERO;
    }
    
    public Integer getTotalBookings(int managerId) {
        List<Integer> ids = getConfiguredHomestayIdList();
        String sql;
        boolean useConfiguredIds = !ids.isEmpty();
        if (useConfiguredIds) {
            sql = "SELECT COUNT(DISTINCT b.id) as total_bookings " +
                  "FROM bookings b " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "WHERE h.id IN (" + buildInClausePlaceholders(ids.size()) + ")";
        } else {
            sql = "SELECT COUNT(DISTINCT b.id) as total_bookings " +
                  "FROM bookings b " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "INNER JOIN manager_homestays mh ON h.id = mh.homestay_id " +
                  "WHERE mh.user_id = ?";
        }
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (useConfiguredIds) {
                for (Integer id : ids) { ps.setInt(paramIndex++, id); }
            } else {
                ps.setInt(paramIndex, managerId);
            }
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt("total_bookings"); }
        } catch (Exception e) {
            // Fallback: đếm tất cả bookings
            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM bookings")) {
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
            } catch (Exception ignore) { e.printStackTrace(); }
        }
        return 0;
    }
    
    public Integer getTotalServicesSold(int managerId) {
        List<Integer> ids = getConfiguredHomestayIdList();
        String sql;
        boolean useConfiguredIds = !ids.isEmpty();
        if (useConfiguredIds) {
            sql = "SELECT COUNT(*) as total_services " +
                  "FROM booking_services bs " +
                  "INNER JOIN bookings b ON bs.booking_id = b.id " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "WHERE h.id IN (" + buildInClausePlaceholders(ids.size()) + ")";
        } else {
            sql = "SELECT COUNT(*) as total_services " +
                  "FROM booking_services bs " +
                  "INNER JOIN bookings b ON bs.booking_id = b.id " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "INNER JOIN manager_homestays mh ON h.id = mh.homestay_id " +
                  "WHERE mh.user_id = ?";
        }
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (useConfiguredIds) {
                for (Integer id : ids) { ps.setInt(paramIndex++, id); }
            } else {
                ps.setInt(paramIndex, managerId);
            }
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt("total_services"); }
        } catch (Exception e) {
            // Fallback: nếu không có bảng booking_services thì trả 0
            return 0;
        }
        return 0;
    }
    
    public Integer getTotalHomestays(int managerId) {
        List<Integer> ids = getConfiguredHomestayIdList();
        if (!ids.isEmpty()) {
            return ids.size();
        }
        String sql = "SELECT COUNT(*) as total_homestays FROM manager_homestays WHERE user_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt("total_homestays"); }
        } catch (Exception e) {
            // Fallback: đếm tất cả homestays
            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM homestays")) {
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
            } catch (Exception ignore) { e.printStackTrace(); }
        }
        return 0;
    }
    
    public List<Map<String, Object>> getMonthlyRevenue(int managerId) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<Integer> ids = getConfiguredHomestayIdList();
        boolean useConfiguredIds = !ids.isEmpty();
        String sql;
        if (useConfiguredIds) {
            sql = "SELECT DATE_FORMAT(p.payment_date, '%Y-%m') as month, COALESCE(SUM(p.amount), 0) as revenue " +
                  "FROM payments p " +
                  "INNER JOIN bookings b ON p.booking_id = b.id " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "WHERE h.id IN (" + buildInClausePlaceholders(ids.size()) + ") AND p.status = 'PAID' " +
                  "GROUP BY DATE_FORMAT(p.payment_date, '%Y-%m') ORDER BY month DESC LIMIT 8";
        } else {
            sql = "SELECT DATE_FORMAT(p.payment_date, '%Y-%m') as month, COALESCE(SUM(p.amount), 0) as revenue " +
                  "FROM payments p " +
                  "INNER JOIN bookings b ON p.booking_id = b.id " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "INNER JOIN manager_homestays mh ON h.id = mh.homestay_id " +
                  "WHERE mh.user_id = ? AND p.status = 'PAID' " +
                  "GROUP BY DATE_FORMAT(p.payment_date, '%Y-%m') ORDER BY month DESC LIMIT 8";
        }
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (useConfiguredIds) {
                for (Integer id : ids) { ps.setInt(paramIndex++, id); }
            } else { ps.setInt(paramIndex, managerId); }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> monthData = new HashMap<>();
                    monthData.put("month", rs.getString("month"));
                    monthData.put("revenue", rs.getBigDecimal("revenue"));
                    result.add(monthData);
                }
            }
        } catch (Exception e) {
            // Fallback: doanh thu theo tháng toàn hệ thống
            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "SELECT DATE_FORMAT(p.payment_date, '%Y-%m') as month, COALESCE(SUM(p.amount),0) as revenue " +
                         "FROM payments p WHERE p.status='PAID' GROUP BY DATE_FORMAT(p.payment_date, '%Y-%m') " +
                         "ORDER BY month DESC LIMIT 8")) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> monthData = new HashMap<>();
                        monthData.put("month", rs.getString("month"));
                        monthData.put("revenue", rs.getBigDecimal("revenue"));
                        result.add(monthData);
                    }
                }
            } catch (Exception ignore) { e.printStackTrace(); }
        }
        return result;
    }
    
    public List<Map<String, Object>> getMonthlyBookings(int managerId) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<Integer> ids = getConfiguredHomestayIdList();
        boolean useConfiguredIds = !ids.isEmpty();
        String sql;
        if (useConfiguredIds) {
            sql = "SELECT DATE_FORMAT(b.created_at, '%Y-%m') as month, COUNT(*) as bookings " +
                  "FROM bookings b " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "WHERE h.id IN (" + buildInClausePlaceholders(ids.size()) + ") " +
                  "GROUP BY DATE_FORMAT(b.created_at, '%Y-%m') ORDER BY month DESC LIMIT 8";
        } else {
            sql = "SELECT DATE_FORMAT(b.created_at, '%Y-%m') as month, COUNT(*) as bookings " +
                  "FROM bookings b " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "INNER JOIN manager_homestays mh ON h.id = mh.homestay_id " +
                  "WHERE mh.user_id = ? GROUP BY DATE_FORMAT(b.created_at, '%Y-%m') ORDER BY month DESC LIMIT 8";
        }
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (useConfiguredIds) { for (Integer id : ids) { ps.setInt(paramIndex++, id); } }
            else { ps.setInt(paramIndex, managerId); }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> monthData = new HashMap<>();
                    monthData.put("month", rs.getString("month"));
                    monthData.put("bookings", rs.getInt("bookings"));
                    result.add(monthData);
                }
            }
        } catch (Exception e) {
            // Fallback: bookings theo tháng toàn hệ thống
            try (Connection conn = dataSource.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "SELECT DATE_FORMAT(b.created_at, '%Y-%m') as month, COUNT(*) as bookings " +
                         "FROM bookings b GROUP BY DATE_FORMAT(b.created_at, '%Y-%m') ORDER BY month DESC LIMIT 8")) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> monthData = new HashMap<>();
                        monthData.put("month", rs.getString("month"));
                        monthData.put("bookings", rs.getInt("bookings"));
                        result.add(monthData);
                    }
                }
            } catch (Exception ignore) { e.printStackTrace(); }
        }
        return result;
    }
    
    public List<Map<String, Object>> getServiceStatistics(int managerId) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<Integer> ids = getConfiguredHomestayIdList();
        boolean useConfiguredIds = !ids.isEmpty();
        String sql;
        if (useConfiguredIds) {
            sql = "SELECT s.name as service_name, COUNT(*) as count " +
                  "FROM booking_services bs " +
                  "INNER JOIN services s ON bs.service_id = s.id " +
                  "INNER JOIN bookings b ON bs.booking_id = b.id " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "WHERE h.id IN (" + buildInClausePlaceholders(ids.size()) + ") " +
                  "GROUP BY s.id, s.name ORDER BY count DESC LIMIT 5";
        } else {
            sql = "SELECT s.name as service_name, COUNT(*) as count " +
                  "FROM booking_services bs " +
                  "INNER JOIN services s ON bs.service_id = s.id " +
                  "INNER JOIN bookings b ON bs.booking_id = b.id " +
                  "INNER JOIN rooms r ON b.room_id = r.id " +
                  "INNER JOIN homestays h ON r.homestay_id = h.id " +
                  "INNER JOIN manager_homestays mh ON h.id = mh.homestay_id " +
                  "WHERE mh.user_id = ? GROUP BY s.id, s.name ORDER BY count DESC LIMIT 5";
        }
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (useConfiguredIds) { for (Integer id : ids) { ps.setInt(paramIndex++, id); } }
            else { ps.setInt(paramIndex, managerId); }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> serviceData = new HashMap<>();
                    serviceData.put("name", rs.getString("service_name"));
                    serviceData.put("count", rs.getInt("count"));
                    result.add(serviceData);
                }
            }
        } catch (Exception e) {
            // Fallback: nếu không có bảng booking_services thì trả list rỗng
            return result;
        }
        return result;
    }
}
