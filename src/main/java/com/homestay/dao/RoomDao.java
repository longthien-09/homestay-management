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
                room.setHomestayId(rs.getInt("homestay_id"));
                rooms.add(room);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rooms;
    }
}
