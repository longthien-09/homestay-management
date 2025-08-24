package com.homestay.controller;

import com.homestay.model.User;
import com.homestay.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class BookingController {

    @Autowired
    private BookingService bookingService;

    // Show booking form for a specific room
    @GetMapping("/homestays/{homestayId}/rooms/{roomId}/book")
    public String showBookingForm(@PathVariable int homestayId, @PathVariable int roomId, Model model, HttpSession session) {
        if (!ensureUser(session)) return "redirect:/login";
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("roomId", roomId);
        return "booking/NewFile"; // booking form JSP
    }

    // Submit booking
    @PostMapping("/homestays/{homestayId}/rooms/{roomId}/book")
    public String submitBooking(@PathVariable int homestayId,
                                @PathVariable int roomId,
                                @RequestParam("checkIn") String checkIn,
                                @RequestParam("checkOut") String checkOut,
                                @RequestParam(value = "quantity", required = false, defaultValue = "1") int quantity,
                                Model model,
                                HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        // Current schema supports booking one room per record. Enforce quantity=1 for now.
        if (quantity != 1) {
            model.addAttribute("error", "Hiện tại chỉ hỗ trợ đặt 1 phòng mỗi lần.");
            model.addAttribute("homestayId", homestayId);
            model.addAttribute("roomId", roomId);
            return "booking/NewFile";
        }

        try {
            java.sql.Date ci = java.sql.Date.valueOf(checkIn);
            java.sql.Date co = java.sql.Date.valueOf(checkOut);
            if (!co.after(ci)) {
                model.addAttribute("error", "Ngày trả phải sau ngày nhận.");
                model.addAttribute("homestayId", homestayId);
                model.addAttribute("roomId", roomId);
                return "booking/NewFile";
            }
            int bookingId = bookingService.requestBooking(user.getId(), roomId, ci, co);
            if (bookingId == -1) {
                model.addAttribute("error", "Phòng không còn trống trong khoảng thời gian đã chọn.");
                model.addAttribute("homestayId", homestayId);
                model.addAttribute("roomId", roomId);
                return "booking/NewFile";
            }
            model.addAttribute("message", "Yêu cầu đặt phòng đã được gửi. Vui lòng chờ duyệt.");
            return "redirect:/user/bookings";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", "Định dạng ngày không hợp lệ (yyyy-MM-dd).");
            model.addAttribute("homestayId", homestayId);
            model.addAttribute("roomId", roomId);
            return "booking/NewFile";
        }
    }

    // User booking history
    @GetMapping("/user/bookings")
    public String userBookings(Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";
        model.addAttribute("bookings", bookingService.userHistory(user.getId()));
        return "booking/history";
    }

    // Admin list bookings with optional filter by homestay and status
    @GetMapping("/admin/bookings")
    public String adminBookings(@RequestParam(value = "homestayId", required = false) Integer homestayId,
                                @RequestParam(value = "status", required = false) String status,
                                Model model,
                                HttpSession session) {
        if (!ensureAdmin(session)) return "redirect:/login";
        List<Map<String,Object>> list = bookingService.adminList(homestayId, status);
        model.addAttribute("bookings", list);
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("status", status);
        return "admin/booking_list";
    }

    @PostMapping("/admin/bookings/{id}/approve")
    public String approve(@PathVariable int id, HttpSession session) {
        if (!ensureAdmin(session)) return "redirect:/login";
        bookingService.approve(id);
        return "redirect:/admin/bookings";
    }

    @PostMapping("/admin/bookings/{id}/reject")
    public String reject(@PathVariable int id, HttpSession session) {
        if (!ensureAdmin(session)) return "redirect:/login";
        bookingService.reject(id);
        return "redirect:/admin/bookings";
    }

    private boolean ensureUser(HttpSession session) {
        return session.getAttribute("currentUser") != null;
    }
    private boolean ensureAdmin(HttpSession session) {
        Object obj = session.getAttribute("currentUser");
        if (obj instanceof User) {
            User u = (User) obj;
            return "ADMIN".equalsIgnoreCase(u.getRole());
        }
        return false;
    }
}
