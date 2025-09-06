package com.homestay.dao;

import com.homestay.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CategoryDao {
    @Autowired
    private javax.sql.DataSource dataSource;

    public java.util.List<Category> getAll() {
        java.util.List<Category> list = new java.util.ArrayList<>();
        String sql = "SELECT id, name FROM categories ORDER BY name ASC";
        try (java.sql.Connection conn = dataSource.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql);
             java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}


