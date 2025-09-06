package com.homestay.dao;

import com.homestay.model.Homestay;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Repository
public class HomestayDao {
    @Autowired
    private DataSource dataSource;

    public List<Homestay> getAllHomestays() {
        List<Homestay> homestays = new ArrayList<>();
        String sql = "SELECT * FROM homestays";
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Homestay h = new Homestay();
                h.setId(rs.getInt("id"));
                h.setName(rs.getString("name"));
                h.setAddress(rs.getString("address"));
                h.setDescription(rs.getString("description"));
                h.setImage(rs.getString("image"));
                h.setPhone(rs.getString("phone"));
                h.setEmail(rs.getString("email"));
                homestays.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return homestays;
    }

    public Homestay getHomestayById(int id) {
        String sql = "SELECT * FROM homestays WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Homestay h = new Homestay();
                    h.setId(rs.getInt("id"));
                    h.setName(rs.getString("name"));
                    h.setAddress(rs.getString("address"));
                    h.setDescription(rs.getString("description"));
                    h.setImage(rs.getString("image"));
                    h.setPhone(rs.getString("phone"));
                    h.setEmail(rs.getString("email"));
                    return h;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addHomestay(Homestay h) {
        String sql = "INSERT INTO homestays (name, address, phone, email, description, image) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, n(h.getName()));
            ps.setString(2, n(h.getAddress()));
            ps.setString(3, n(h.getPhone()));
            ps.setString(4, n(h.getEmail()));
            ps.setString(5, n(h.getDescription()));
            ps.setString(6, n(h.getImage()));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int createHomestay(Homestay h) {
        String sql = "INSERT INTO homestays (name, address, phone, email, description, image) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, n(h.getName()));
            ps.setString(2, n(h.getAddress()));
            ps.setString(3, n(h.getPhone()));
            ps.setString(4, n(h.getEmail()));
            ps.setString(5, n(h.getDescription()));
            ps.setString(6, n(h.getImage()));
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void updateHomestay(Homestay h) {
        String sql = "UPDATE homestays SET name=?, address=?, phone=?, email=?, description=?, image=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, n(h.getName()));
            ps.setString(2, n(h.getAddress()));
            ps.setString(3, n(h.getPhone()));
            ps.setString(4, n(h.getEmail()));
            ps.setString(5, n(h.getDescription()));
            ps.setString(6, n(h.getImage()));
            ps.setInt(7, h.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean deleteHomestay(int id) {
        try (Connection conn = dataSource.getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            try {
                // 1. Xóa payments liên quan đến bookings của homestay này
                String deletePaymentsSql = "DELETE p FROM payments p " +
                    "JOIN bookings b ON p.booking_id = b.id " +
                    "JOIN rooms r ON b.room_id = r.id " +
                    "WHERE r.homestay_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(deletePaymentsSql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                
                // 2. Xóa bookings liên quan đến rooms của homestay này
                String deleteBookingsSql = "DELETE b FROM bookings b " +
                    "JOIN rooms r ON b.room_id = r.id " +
                    "WHERE r.homestay_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(deleteBookingsSql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                
                // 3. Xóa services liên quan đến homestay này
                String deleteServicesSql = "DELETE FROM services WHERE homestay_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(deleteServicesSql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                
                // 4. Xóa rooms của homestay này
                String deleteRoomsSql = "DELETE FROM rooms WHERE homestay_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(deleteRoomsSql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                
                // 5. Xóa manager_homestays relationships
                String deleteManagerHomestaySql = "DELETE FROM manager_homestays WHERE homestay_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(deleteManagerHomestaySql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                
                // 6. Cuối cùng xóa homestay
                String deleteHomestaySql = "DELETE FROM homestays WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(deleteHomestaySql)) {
                    ps.setInt(1, id);
                    int affected = ps.executeUpdate();
                    if (affected > 0) {
                        conn.commit(); // Commit transaction
                        return true;
                    } else {
                        conn.rollback(); // Rollback nếu không tìm thấy homestay
                        return false;
                    }
                }
                
            } catch (Exception e) {
                conn.rollback(); // Rollback nếu có lỗi
                throw e;
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            System.err.println("Không thể xóa homestay do ràng buộc dữ liệu liên quan (ví dụ: phòng, người dùng, ...)");
            return false;
        } catch (Exception e) {
            System.err.println("Lỗi khi xóa homestay: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Homestay> getHomestaysByServiceName(String serviceName) {
        List<Homestay> homestays = new ArrayList<>();
        String sql = "SELECT DISTINCT h.* FROM homestays h " +
                    "INNER JOIN services s ON h.id = s.homestay_id " +
                    "WHERE LOWER(s.name) LIKE LOWER(?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + serviceName + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = new Homestay();
                    h.setId(rs.getInt("id"));
                    h.setName(rs.getString("name"));
                    h.setAddress(rs.getString("address"));
                    h.setDescription(rs.getString("description"));
                    h.setImage(rs.getString("image"));
                    h.setPhone(rs.getString("phone"));
                    h.setEmail(rs.getString("email"));
                    homestays.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return homestays;
    }
    
    public List<Homestay> getHomestaysByServiceNameWithPagination(String serviceName, int page, int size) {
        List<Homestay> homestays = new ArrayList<>();
        int offset = (page - 1) * size;
        
        String sql = "SELECT DISTINCT h.* FROM homestays h " +
                    "INNER JOIN services s ON h.id = s.homestay_id " +
                    "WHERE LOWER(s.name) LIKE LOWER(?) " +
                    "LIMIT ? OFFSET ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + serviceName + "%");
            ps.setInt(2, size);
            ps.setInt(3, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = new Homestay();
                    h.setId(rs.getInt("id"));
                    h.setName(rs.getString("name"));
                    h.setAddress(rs.getString("address"));
                    h.setDescription(rs.getString("description"));
                    h.setImage(rs.getString("image"));
                    h.setPhone(rs.getString("phone"));
                    h.setEmail(rs.getString("email"));
                    homestays.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return homestays;
    }
    
    public int getTotalHomestaysByServiceName(String serviceName) {
        String sql = "SELECT COUNT(DISTINCT h.id) FROM homestays h " +
                    "INNER JOIN services s ON h.id = s.homestay_id " +
                    "WHERE LOWER(s.name) LIKE LOWER(?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + serviceName + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<Homestay> getAllHomestaysWithPagination(int page, int size) {
        List<Homestay> homestays = new ArrayList<>();
        int offset = (page - 1) * size;
        
        String sql = "SELECT * FROM homestays LIMIT ? OFFSET ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, size);
            ps.setInt(2, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = new Homestay();
                    h.setId(rs.getInt("id"));
                    h.setName(rs.getString("name"));
                    h.setAddress(rs.getString("address"));
                    h.setDescription(rs.getString("description"));
                    h.setImage(rs.getString("image"));
                    h.setPhone(rs.getString("phone"));
                    h.setEmail(rs.getString("email"));
                    homestays.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return homestays;
    }
    
    public int getTotalHomestays() {
        String sql = "SELECT COUNT(*) FROM homestays";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy ngẫu nhiên n homestay (phục vụ hiển thị nổi bật trang chủ)
    public List<Homestay> getRandomHomestays(int limit) {
        List<Homestay> homestays = new ArrayList<>();
        String sql = "SELECT * FROM homestays ORDER BY RAND() LIMIT ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = new Homestay();
                    h.setId(rs.getInt("id"));
                    h.setName(rs.getString("name"));
                    h.setAddress(rs.getString("address"));
                    h.setDescription(rs.getString("description"));
                    h.setImage(rs.getString("image"));
                    h.setPhone(rs.getString("phone"));
                    h.setEmail(rs.getString("email"));
                    homestays.add(h);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return homestays;
    }

    // Tìm kiếm theo tên homestay, địa chỉ, loại phòng, khoảng giá
    public List<Homestay> search(String keyword, String roomType, java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice) {
        List<Homestay> result = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        List<Object> params = new ArrayList<>();
        sb.append("SELECT DISTINCT h.* FROM homestays h LEFT JOIN rooms r ON h.id = r.homestay_id WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sb.append(" AND (LOWER(h.name) LIKE LOWER(?) OR LOWER(h.address) LIKE LOWER(?))");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        if (roomType != null && !roomType.trim().isEmpty()) {
            sb.append(" AND LOWER(r.type) LIKE LOWER(?)");
            params.add("%" + roomType.trim() + "%");
        }
        if (minPrice != null) { sb.append(" AND r.price >= ?"); params.add(minPrice); }
        if (maxPrice != null) { sb.append(" AND r.price <= ?"); params.add(maxPrice); }
        sb.append(" ORDER BY h.name ASC LIMIT 30");
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i=0;i<params.size();i++) ps.setObject(i+1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = new Homestay();
                    h.setId(rs.getInt("id"));
                    h.setName(rs.getString("name"));
                    h.setAddress(rs.getString("address"));
                    h.setDescription(rs.getString("description"));
                    h.setImage(rs.getString("image"));
                    h.setPhone(rs.getString("phone"));
                    h.setEmail(rs.getString("email"));
                    result.add(h);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    // Tìm homestay còn phòng trống trong khoảng ngày (dựa vào bookings)
    public List<Homestay> searchAvailableHomestays(String keyword,
                                                   String roomType,
                                                   java.sql.Date checkIn,
                                                   java.sql.Date checkOut,
                                                   java.math.BigDecimal minPrice,
                                                   java.math.BigDecimal maxPrice) {
        List<Homestay> result = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        List<Object> params = new ArrayList<>();
        sb.append("SELECT DISTINCT h.* FROM homestays h ");
        sb.append("JOIN rooms r ON h.id = r.homestay_id ");
        sb.append("WHERE 1=1 ");
        // Keyword theo tên/địa chỉ
        if (keyword != null && !keyword.trim().isEmpty()) {
            sb.append(" AND (LOWER(h.name) LIKE LOWER(?) OR LOWER(h.address) LIKE LOWER(?))");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        // Giá
        if (minPrice != null) { sb.append(" AND r.price >= ?"); params.add(minPrice); }
        if (maxPrice != null) { sb.append(" AND r.price <= ?"); params.add(maxPrice); }
        // Loại phòng
        if (roomType != null && !roomType.trim().isEmpty()) {
            sb.append(" AND LOWER(r.type) LIKE LOWER(?)");
            params.add("%" + roomType.trim() + "%");
        }
        // Còn phòng: loại trừ các phòng đã được đặt chồng lấn
        sb.append(" AND r.id NOT IN (SELECT b.room_id FROM bookings b WHERE b.status IN ('PENDING','CONFIRMED') ");
        sb.append(" AND NOT (b.check_out <= ? OR b.check_in >= ?)) ");
        params.add(checkIn);
        params.add(checkOut);
        sb.append(" ORDER BY h.name ASC LIMIT 50");

        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = new Homestay();
                    h.setId(rs.getInt("id"));
                    h.setName(rs.getString("name"));
                    h.setAddress(rs.getString("address"));
                    h.setDescription(rs.getString("description"));
                    h.setImage(rs.getString("image"));
                    h.setPhone(rs.getString("phone"));
                    h.setEmail(rs.getString("email"));
                    result.add(h);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    // Lọc homestay theo danh sách tên dịch vụ (homestay có TẤT CẢ dịch vụ được chọn)
    public List<Homestay> filterByServiceNames(List<String> serviceNames) {
        if (serviceNames == null || serviceNames.isEmpty()) return getAllHomestays();
        List<Homestay> result = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT h.* FROM homestays h WHERE h.id IN (\n");
        sb.append("  SELECT homestay_id FROM services WHERE LOWER(name) IN (");
        for (int i = 0; i < serviceNames.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
        sb.append(") GROUP BY homestay_id HAVING COUNT(DISTINCT LOWER(name)) = ?\n");
        sb.append(") ORDER BY h.name ASC");
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            int idx = 1;
            for (String n : serviceNames) ps.setString(idx++, n.toLowerCase());
            ps.setInt(idx, serviceNames.size());
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = new Homestay();
                    h.setId(rs.getInt("id"));
                    h.setName(rs.getString("name"));
                    h.setAddress(rs.getString("address"));
                    h.setDescription(rs.getString("description"));
                    h.setImage(rs.getString("image"));
                    h.setPhone(rs.getString("phone"));
                    h.setEmail(rs.getString("email"));
                    result.add(h);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    // Chuẩn hóa chuỗi: null/blank/"null" -> null (SQL)
    private String n(String s) {
        if (s == null) return null;
        String t = s.trim();
        if (t.isEmpty()) return null;
        if ("null".equalsIgnoreCase(t)) return null;
        return s;
    }
}
