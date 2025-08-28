package com.homestay.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Repository
public class ManagerHomestayDao {
    @Autowired
    private DataSource dataSource;

    public void addManagerHomestay(int userId, int homestayId) {
        String sql = "INSERT INTO manager_homestays (user_id, homestay_id) VALUES (?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, homestayId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Integer> getHomestayIdsByManager(int userId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT homestay_id FROM manager_homestays WHERE user_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("homestay_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }
}
