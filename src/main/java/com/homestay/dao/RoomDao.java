package com.homestay.dao;

import com.homestay.model.Room;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Repository
public class RoomDao {
    @Autowired
    private DataSource dataSource;

    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM rooms")) {
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setType(rs.getString("type"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setStatus(rs.getString("status"));
                room.setDescription(rs.getString("description"));
                room.setImage(rs.getString("image"));
                room.setHomestayId(rs.getInt("homestay_id"));
                rooms.add(room);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public List<Room> getRoomsByHomestayId(int homestayId) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE homestay_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setId(rs.getInt("id"));
                    room.setRoomNumber(rs.getString("room_number"));
                    room.setType(rs.getString("type"));
                    room.setPrice(rs.getBigDecimal("price"));
                    room.setStatus(rs.getString("status"));
                    room.setDescription(rs.getString("description"));
                    room.setImage(rs.getString("image"));
                    room.setHomestayId(rs.getInt("homestay_id"));
                    rooms.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public int addRoom(Room room) {
        String sql = "INSERT INTO rooms (room_number, type, price, status, description, image, homestay_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getType());
            ps.setBigDecimal(3, room.getPrice());
            ps.setString(4, room.getStatus());
            ps.setString(5, room.getDescription());
            ps.setString(6, room.getImage());
            ps.setInt(7, room.getHomestayId());
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

    public boolean updateRoom(Room room) {
        String sql = "UPDATE rooms SET room_number=?, type=?, price=?, status=?, description=?, image=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getType());
            ps.setBigDecimal(3, room.getPrice());
            ps.setString(4, room.getStatus());
            ps.setString(5, room.getDescription());
            ps.setString(6, room.getImage());
            ps.setInt(7, room.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRoom(int id) {
        String sql = "DELETE FROM rooms WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
