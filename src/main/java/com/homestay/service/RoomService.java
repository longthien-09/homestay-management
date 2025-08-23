package com.homestay.service;

import com.homestay.dao.RoomDao;
import com.homestay.model.Room;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RoomService {
    @Autowired
    private RoomDao roomDao;
    public List<Room> getAllRooms() {
        return roomDao.getAllRooms();
    }

    public List<Room> getRoomsByHomestayId(int homestayId) {
        return roomDao.getRoomsByHomestayId(homestayId);
    }

    public int addRoom(Room room) {
        return roomDao.addRoom(room);
    }
    public boolean updateRoom(Room room) {
        return roomDao.updateRoom(room);
    }
    public boolean deleteRoom(int id) {
        return roomDao.deleteRoom(id);
    }
}
