package com.homestay.dao;

import com.homestay.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class UserDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    private RowMapper<User> userRowMapper = new RowMapper<User>() {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User user = new User();
            user.setId(rs.getInt("id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setFullName(rs.getString("full_name"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            user.setRole(rs.getString("role"));
            user.setActive(rs.getBoolean("active"));
            return user;
        }
    };

    public int register(User user) {
        String sql = "INSERT INTO users (username, password, full_name, email, phone, role, active) VALUES (?, ?, ?, ?, ?, ?, 1)";
        return jdbcTemplate.update(sql, user.getUsername(), user.getPassword(), user.getFullName(), user.getEmail(), user.getPhone(), user.getRole());
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND active = 1";
        List<User> users = jdbcTemplate.query(sql, userRowMapper, username, password);
        return users.isEmpty() ? null : users.get(0);
    }

    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        List<User> users = jdbcTemplate.query(sql, userRowMapper, id);
        return users.isEmpty() ? null : users.get(0);
    }

    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        List<User> users = jdbcTemplate.query(sql, userRowMapper, username);
        return users.isEmpty() ? null : users.get(0);
    }

    public int updateUser(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE id = ?";
        return jdbcTemplate.update(sql, user.getFullName(), user.getEmail(), user.getPhone(), user.getId());
    }

    public int updatePassword(int id, String password) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        return jdbcTemplate.update(sql, password, id);
    }

    public int setActive(int id, boolean active) {
        String sql = "UPDATE users SET active = ? WHERE id = ?";
        return jdbcTemplate.update(sql, active, id);
    }

    public List<User> findAll() {
        String sql = "SELECT * FROM users";
        return jdbcTemplate.query(sql, userRowMapper);
    }
}
