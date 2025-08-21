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
}
