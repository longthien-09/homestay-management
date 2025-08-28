package com.homestay.service;

import com.homestay.dao.BookingDao;
import com.homestay.model.Booking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class BookingService {
    @Autowired
    private BookingDao bookingDao;

    public boolean isRoomAvailable(int roomId, java.sql.Date checkIn, java.sql.Date checkOut) {
        return bookingDao.isRoomAvailable(roomId, checkIn, checkOut);
    }

    public int requestBooking(int userId, int roomId, java.sql.Date checkIn, java.sql.Date checkOut) {
        if (!isRoomAvailable(roomId, checkIn, checkOut)) return -1;
        Booking b = new Booking();
        b.setUserId(userId);
        b.setRoomId(roomId);
        b.setCheckIn(checkIn);
        b.setCheckOut(checkOut);
        b.setStatus("PENDING");
        return bookingDao.create(b);
    }

    public boolean approve(int bookingId) { return bookingDao.updateStatus(bookingId, "CONFIRMED"); }
    public boolean reject(int bookingId) { return bookingDao.updateStatus(bookingId, "CANCELLED"); }

    public List<Booking> userHistory(int userId) { return bookingDao.findByUser(userId); }

    public List<Map<String,Object>> adminList(Integer homestayId, String status) { return bookingDao.adminList(homestayId, status); }

    public com.homestay.model.Booking getBookingById(int id) {
        return bookingDao.findById(id);
    }

    // Lưu dịch vụ đã chọn cho booking
    public void saveSelectedServices(int bookingId, java.util.List<Integer> serviceIds) {
        bookingDao.addServicesToBooking(bookingId, serviceIds);
    }

    public java.util.List<java.util.Map<String,Object>> getActiveBookingsByUser(int userId) {
        return bookingDao.findActiveBookingsByUser(userId);
    }
}
