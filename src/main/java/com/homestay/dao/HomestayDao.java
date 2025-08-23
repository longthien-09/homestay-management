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
            ps.setString(1, h.getName());
            ps.setString(2, h.getAddress());
            ps.setString(3, h.getPhone());
            ps.setString(4, h.getEmail());
            ps.setString(5, h.getDescription());
            ps.setString(6, h.getImage());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateHomestay(Homestay h) {
        String sql = "UPDATE homestays SET name=?, address=?, phone=?, email=?, description=?, image=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getName());
            ps.setString(2, h.getAddress());
            ps.setString(3, h.getPhone());
            ps.setString(4, h.getEmail());
            ps.setString(5, h.getDescription());
            ps.setString(6, h.getImage());
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
}
