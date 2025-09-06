package com.homestay.dao;

import com.homestay.model.HomestayImage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Repository
public class HomestayImageDao {
    @Autowired
    private DataSource dataSource;

    public List<HomestayImage> getImagesByHomestayId(int homestayId) {
        List<HomestayImage> images = new ArrayList<>();
        String sql = "SELECT id, homestay_id, file_path, sort_order FROM homestay_images WHERE homestay_id = ? ORDER BY COALESCE(sort_order, 9999), id";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HomestayImage img = new HomestayImage();
                    img.setId(rs.getInt("id"));
                    img.setHomestayId(rs.getInt("homestay_id"));
                    img.setFilePath(rs.getString("file_path"));
                    img.setSortOrder((Integer) rs.getObject("sort_order"));
                    images.add(img);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return images;
    }

    public boolean addImage(int homestayId, String filePath, Integer sortOrder) {
        String sql = "INSERT INTO homestay_images (homestay_id, file_path, sort_order) VALUES (?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            ps.setString(2, filePath);
            if (sortOrder != null) ps.setInt(3, sortOrder); else ps.setNull(3, java.sql.Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}


