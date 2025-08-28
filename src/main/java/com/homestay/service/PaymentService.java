package com.homestay.service;

import org.springframework.beans.factory.annotation.Autowired;
import com.homestay.dao.PaymentDao;
import com.homestay.dao.BookingDao;
import com.homestay.dao.RoomDao;
import java.util.*;
import org.springframework.stereotype.Service;

@Service
public class PaymentService {
    @Autowired
    private PaymentDao paymentDao;
    @Autowired
    private BookingDao bookingDao;
    @Autowired
    private RoomDao roomDao;

    public List<Map<String,Object>> getPaymentsByUser(int userId) {
        return paymentDao.findByUser(userId);
    }

    public List<Map<String,Object>> getPaymentsByHomestayIds(List<Integer> homestayIds) {
        return paymentDao.findByHomestayIds(homestayIds);
    }

    public void pay(int paymentId, int userId, String method) {
        Map<String,Object> payment = paymentDao.findById(paymentId);
        if (payment != null && "UNPAID".equals(payment.get("status"))) {
            int bookingId = (int) payment.get("booking_id");
            com.homestay.model.Booking booking = bookingDao.findById(bookingId);
            if (booking != null && booking.getUserId() == userId) {
                paymentDao.updateStatusAndMethod(paymentId, "PAID", method);
            }
        }
    }

    public int createPayment(int bookingId, java.math.BigDecimal amount) {
        return paymentDao.createPayment(bookingId, amount);
    }

    public Map<String,Object> getPaymentById(int id) {
        return paymentDao.findById(id);
    }

    public Map<String,Object> getLatestPaymentByBooking(int bookingId) {
        return paymentDao.findByBookingId(bookingId);
    }
}
