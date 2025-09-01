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
        String sql = "DELETE FROM homestays WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                System.out.println("Đã xóa homestay với id: " + id);
                return true;
            } else {
                System.out.println("Không tìm thấy homestay với id: " + id);
                return false;
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

    // Chuẩn hóa chuỗi: null/blank/"null" -> null (SQL)
    private String n(String s) {
        if (s == null) return null;
        String t = s.trim();
        if (t.isEmpty()) return null;
        if ("null".equalsIgnoreCase(t)) return null;
        return s;
    }
    
    // Lấy danh sách tên services của homestay
    public List<String> getServiceNamesByHomestayId(int homestayId) {
        List<String> serviceNames = new ArrayList<>();
        String sql = "SELECT name FROM services WHERE homestay_id = ? ORDER BY name";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    serviceNames.add(rs.getString("name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return serviceNames;
    }
    
    // Lấy homestay với services
    public Homestay getHomestayWithServices(int id) {
        Homestay homestay = getHomestayById(id);
        if (homestay != null) {
            List<String> services = getServiceNamesByHomestayId(id);
            // Lưu services vào description tạm thời để hiển thị
            if (!services.isEmpty()) {
                homestay.setDescription(homestay.getDescription() + " | Dịch vụ: " + String.join(", ", services));
            }
        }
        return homestay;
    }
    
    // Lấy giá phòng thấp nhất của homestay
    public java.math.BigDecimal getMinRoomPriceByHomestayId(int homestayId) {
        String sql = "SELECT MIN(price) FROM rooms WHERE homestay_id = ? AND status = 'AVAILABLE'";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
    
    // Lấy thông tin giá phòng của homestay
    public java.util.Map<String, Object> getRoomPriceInfoByHomestayId(int homestayId) {
        String sql = "SELECT MIN(price) as min_price, MAX(price) as max_price, COUNT(*) as room_count " +
                    "FROM rooms WHERE homestay_id = ? AND status = 'AVAILABLE'";
        
        java.util.Map<String, Object> priceInfo = new java.util.HashMap<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    priceInfo.put("minPrice", rs.getBigDecimal("min_price"));
                    priceInfo.put("maxPrice", rs.getBigDecimal("max_price"));
                    priceInfo.put("roomCount", rs.getInt("room_count"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return priceInfo;
    }
}
