package com.homestay.dao;

import com.homestay.model.Homestay;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class HomestayDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Homestay> mapper = new RowMapper<Homestay>() {
        @Override
        public Homestay mapRow(ResultSet rs, int rowNum) throws SQLException {
            Homestay h = new Homestay();
            h.setId(rs.getInt("id"));
            h.setName(rs.getString("name"));
            h.setAddress(rs.getString("address"));
            h.setPhone(rs.getString("phone"));
            h.setEmail(rs.getString("email"));
            h.setDescription(rs.getString("description"));
            return h;
        }
    };

    public int insert(Homestay h) {
        String sql = "INSERT INTO homestays(name, address, phone, email, description) VALUES (?,?,?,?,?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, h.getName());
            ps.setString(2, h.getAddress());
            ps.setString(3, h.getPhone());
            ps.setString(4, h.getEmail());
            ps.setString(5, h.getDescription());
            return ps;
        }, keyHolder);
        Number key = keyHolder.getKey();
        return key == null ? 0 : key.intValue();
    }

    public Homestay findByName(String name) {
        List<Homestay> list = jdbcTemplate.query("SELECT * FROM homestays WHERE name = ?", mapper, name);
        return list.isEmpty() ? null : list.get(0);
    }
}
