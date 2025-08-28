package com.homestay.controller;

import com.homestay.model.User;
import com.homestay.service.BookingService;
import com.homestay.service.RoomService;
import com.homestay.service.PaymentService;
import com.homestay.model.Room;
import com.homestay.dao.ManagerHomestayDao;
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

    @Autowired
    private RoomService roomService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private ManagerHomestayDao managerHomestayDao;

    @Autowired
    private com.homestay.service.ServiceService serviceService;

    // Show booking form for a specific room
    @GetMapping("/homestays/{homestayId}/rooms/{roomId}/book")
    public String showBookingForm(@PathVariable int homestayId, @PathVariable int roomId, Model model, HttpSession session) {
        if (!ensureUser(session)) return "redirect:/login";
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("roomId", roomId);
        
        // Lấy danh sách dịch vụ của homestay này
        List<com.homestay.model.Service> homestayServices = serviceService.getServicesByHomestayId(homestayId);
        model.addAttribute("homestayServices", homestayServices);
        
        return "booking/NewFile"; // booking form JSP
    }

    // Submit booking
    @PostMapping("/homestays/{homestayId}/rooms/{roomId}/book")
    public String submitBooking(@PathVariable int homestayId,
                                @PathVariable int roomId,
                                @RequestParam("checkIn") String checkIn,
                                @RequestParam("checkOut") String checkOut,
                                @RequestParam(value = "quantity", required = false, defaultValue = "1") int quantity,
                                @RequestParam(value = "selectedServices", required = false) List<String> selectedServices,
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
            
            // Lưu dịch vụ đã chọn vào DB (và vẫn giữ session để hiển thị tức thời)
            if (selectedServices != null && !selectedServices.isEmpty()) {
                session.setAttribute("selectedServices_" + bookingId, selectedServices);
                java.util.List<Integer> serviceIds = new java.util.ArrayList<>();
                for (String s : selectedServices) {
                    try { serviceIds.add(Integer.parseInt(s)); } catch (NumberFormatException ignore) {}
                }
                if (!serviceIds.isEmpty()) {
                    bookingService.saveSelectedServices(bookingId, serviceIds);
                }
            }
            
            // Tạo payment ngay sau khi booking thành công
            Room room = roomService.getRoomById(roomId);
            java.math.BigDecimal amount = room != null ? room.getPrice() : java.math.BigDecimal.ZERO;
            int paymentId = paymentService.createPayment(bookingId, amount);
            // Chuyển hướng sang trang thanh toán chi tiết
            return "redirect:/user/payments/" + paymentId + "/pay";
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

    // Manager: Quản lý booking của các homestay mình quản lý
    @GetMapping("/manager/bookings")
    public String managerBookings(@RequestParam(value = "homestayId", required = false) Integer homestayId,
                                 @RequestParam(value = "status", required = false) String status,
                                 Model model,
                                 HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) return "redirect:/login";
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        // Nếu manager chọn lọc theo homestayId, chỉ lấy booking của homestay đó, ngược lại lấy tất cả booking của các homestay manager quản lý
        java.util.List<java.util.Map<String,Object>> bookings = new java.util.ArrayList<>();
        if (homestayId != null && homestayIds.contains(homestayId)) {
            bookings = bookingService.adminList(homestayId, status);
        } else {
            for (Integer hid : homestayIds) {
                bookings.addAll(bookingService.adminList(hid, status));
            }
        }
        model.addAttribute("bookings", bookings);
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("status", status);
        return "booking/booking_list";
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

    // Manager duyệt booking
    @PostMapping("/manager/bookings/{id}/approve")
    public String managerApprove(@PathVariable int id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) return "redirect:/login";
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        com.homestay.model.Booking booking = bookingService.getBookingById(id);
        if (booking != null) {
            com.homestay.model.Room room = roomService.getRoomById(booking.getRoomId());
            if (room != null && homestayIds.contains(room.getHomestayId())) {
                bookingService.approve(id);
            }
        }
        return "redirect:/manager/bookings";
    }

    @PostMapping("/manager/bookings/{id}/reject")
    public String managerReject(@PathVariable int id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) return "redirect:/login";
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        com.homestay.model.Booking booking = bookingService.getBookingById(id);
        if (booking != null) {
            com.homestay.model.Room room = roomService.getRoomById(booking.getRoomId());
            if (room != null && homestayIds.contains(room.getHomestayId())) {
                bookingService.reject(id);
            }
        }
        return "redirect:/manager/bookings";
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
