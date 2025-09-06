package com.homestay.controller;

import com.homestay.model.User;
import com.homestay.service.BookingService;
import com.homestay.service.RoomService;
import com.homestay.service.PaymentService;
import com.homestay.service.ServiceService;
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
    private ServiceService serviceService;

    @Autowired
    private ManagerHomestayDao managerHomestayDao;
    
    @Autowired
    private com.homestay.service.HomestayService homestayService;

    // Pick a random available room for the given dates, then redirect to booking form
    @GetMapping("/homestays/{homestayId}/book-random")
    public String bookRandom(@PathVariable int homestayId,
                             @RequestParam("checkin") String checkin,
                             @RequestParam("checkout") String checkout,
                             HttpSession session) {
        com.homestay.model.User currentUser = (com.homestay.model.User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            java.sql.Date ci = java.sql.Date.valueOf(checkin);
            java.sql.Date co = java.sql.Date.valueOf(checkout);
            if (!co.after(ci)) {
                return "redirect:/homestays/" + homestayId + "?error=invalid_date";
            }

            java.util.List<com.homestay.model.Room> rooms = roomService.getRoomsByHomestayId(homestayId);
            java.util.List<com.homestay.model.Room> available = new java.util.ArrayList<>();
            for (com.homestay.model.Room r : rooms) {
                if (r != null && bookingService.isRoomAvailable(r.getId(), ci, co)) {
                    available.add(r);
                }
            }

            if (available.isEmpty()) {
                return "redirect:/homestays/" + homestayId + "?error=no_available_room";
            }

            java.util.Random rnd = new java.util.Random();
            com.homestay.model.Room pick = available.get(rnd.nextInt(available.size()));
            return "redirect:/homestays/" + homestayId + "/rooms/" + pick.getId() + "/book?checkin=" + checkin + "&checkout=" + checkout;
        } catch (Exception e) {
            return "redirect:/homestays/" + homestayId + "?error=invalid_params";
        }
    }

    // Show booking form for a specific room
    @GetMapping("/homestays/{homestayId}/rooms/{roomId}/book")
    public String showBookingForm(@PathVariable int homestayId, @PathVariable int roomId, Model model, HttpSession session) {
        // Check if user is logged in
        com.homestay.model.User currentUser = (com.homestay.model.User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("roomId", roomId);
        
        // Lấy thông tin homestay
        com.homestay.model.Homestay homestay = homestayService.getHomestayById(homestayId);
        if (homestay == null) {
            model.addAttribute("error", "Không tìm thấy homestay!");
            return "redirect:/homestays";
        }
        model.addAttribute("homestay", homestay);
        
        // Lấy thông tin phòng
        com.homestay.model.Room room = roomService.getRoomById(roomId);
        if (room == null) {
            model.addAttribute("error", "Không tìm thấy phòng!");
            return "redirect:/homestays/" + homestayId;
        }
        model.addAttribute("room", room);
        
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
                                @RequestParam(value = "services", required = false) List<String> selectedServices,
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
            java.math.BigDecimal roomPrice = room != null ? room.getPrice() : java.math.BigDecimal.ZERO;
            
            // Tính tổng tiền dịch vụ đã chọn
            java.math.BigDecimal totalServiceAmount = java.math.BigDecimal.ZERO;
            if (selectedServices != null && !selectedServices.isEmpty()) {
                for (String serviceId : selectedServices) {
                    try {
                        com.homestay.model.Service service = serviceService.getServiceById(Integer.parseInt(serviceId));
                        if (service != null && service.getPrice() != null) {
                            totalServiceAmount = totalServiceAmount.add(service.getPrice());
                        }
                    } catch (NumberFormatException e) {
                        // Bỏ qua ID không hợp lệ
                    }
                }
            }
            
            // Tổng thanh toán = giá phòng + tiền dịch vụ
            java.math.BigDecimal totalAmount = roomPrice.add(totalServiceAmount);
            int paymentId = paymentService.createPayment(bookingId, totalAmount);
            // Ở lại trang chi tiết thanh toán, KHÔNG chuyển sang lịch sử
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
        model.addAttribute("bookings", bookingService.userDetailedHistory(user.getId()));
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
                                 @RequestParam(value = "homestayName", required = false) String homestayName,
                                 @RequestParam(value = "roomNumber", required = false) String roomNumber,
                                 Model model,
                                 HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) return "redirect:/login";
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        
        // Lấy tất cả booking của các homestay manager quản lý
        java.util.List<java.util.Map<String,Object>> allBookings = new java.util.ArrayList<>();
        for (Integer hid : homestayIds) {
            allBookings.addAll(bookingService.adminList(hid, null)); // Lấy tất cả status
        }
        
        // Lọc theo homestayId nếu được chỉ định
        if (homestayId != null && homestayIds.contains(homestayId)) {
            allBookings = allBookings.stream()
                .filter(booking -> homestayId.equals(booking.get("homestay_id")))
                .collect(java.util.stream.Collectors.toList());
        }
        
        // Lọc theo tên homestay
        if (homestayName != null && !homestayName.trim().isEmpty()) {
            allBookings = allBookings.stream()
                .filter(booking -> {
                    String name = (String) booking.get("homestay_name");
                    return name != null && name.toLowerCase().contains(homestayName.toLowerCase());
                })
                .collect(java.util.stream.Collectors.toList());
        }
        
        // Lọc theo số phòng
        if (roomNumber != null && !roomNumber.trim().isEmpty()) {
            allBookings = allBookings.stream()
                .filter(booking -> {
                    String roomNum = (String) booking.get("room_number");
                    return roomNum != null && roomNum.contains(roomNumber);
                })
                .collect(java.util.stream.Collectors.toList());
        }
        
        // Lọc theo trạng thái
        if (status != null && !status.trim().isEmpty()) {
            allBookings = allBookings.stream()
                .filter(booking -> {
                    String bookingStatus = (String) booking.get("booking_status");
                    return status.equals(bookingStatus);
                })
                .collect(java.util.stream.Collectors.toList());
        }
        
        // Lấy danh sách homestay của manager để hiển thị trong dropdown
        java.util.List<com.homestay.model.Homestay> managerHomestays = new java.util.ArrayList<>();
        for (Integer hid : homestayIds) {
            com.homestay.model.Homestay homestay = homestayService.getHomestayById(hid);
            if (homestay != null) {
                managerHomestays.add(homestay);
            }
        }
        
        
        model.addAttribute("bookings", allBookings);
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("status", status);
        model.addAttribute("homestayName", homestayName);
        model.addAttribute("roomNumber", roomNumber);
        model.addAttribute("managerHomestays", managerHomestays);
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
    // Update booking status
    @PostMapping("/manager/bookings/{id}/update-status")
    public String updateBookingStatus(@PathVariable int id, @RequestParam("status") String status, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"MANAGER".equals(user.getRole())) {
            return "redirect:/login";
        }
        
        // Map booking_status to actual status
        String actualStatus;
        if ("PENDING".equals(status)) {
            actualStatus = "PENDING";
        } else if ("CONFIRMED".equals(status) || "CHECKED_IN".equals(status) || "CHECKED_OUT".equals(status)) {
            actualStatus = "CONFIRMED";
        } else if ("CANCELLED".equals(status)) {
            actualStatus = "CANCELLED";
        } else {
            actualStatus = status;
        }
        
        bookingService.updateStatus(id, actualStatus);
        return "redirect:/manager/bookings";
    }
    
    // Edit booking details
    @PostMapping("/manager/bookings/{id}/edit")
    public String editBooking(@PathVariable int id, 
                             @RequestParam("checkIn") String checkIn,
                             @RequestParam("checkOut") String checkOut,
                             HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"MANAGER".equals(user.getRole())) {
            return "redirect:/login";
        }
        
        try {
            // Parse dates
            java.time.LocalDate checkInDate = java.time.LocalDate.parse(checkIn);
            java.time.LocalDate checkOutDate = java.time.LocalDate.parse(checkOut);
            
            // Update booking dates and recalculate total amount
            boolean success = bookingService.updateBookingDatesAndRecalculate(id, checkInDate, checkOutDate);
            
            if (success) {
                System.out.println("DEBUG: Successfully updated booking " + id + " dates and recalculated total amount");
            } else {
                System.out.println("DEBUG: Failed to update booking " + id + " dates");
            }
            
        } catch (Exception e) {
            System.out.println("DEBUG: Error updating booking " + id + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/manager/bookings";
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
