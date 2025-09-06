package com.homestay.controller;

import com.homestay.model.User;
import com.homestay.service.PaymentService;
import com.homestay.dao.ManagerHomestayDao;
import com.homestay.service.BookingService;
import com.homestay.service.RoomService;
import com.homestay.service.HomestayService;
import com.homestay.service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class PaymentController {
    @Autowired
    private PaymentService paymentService;
    @Autowired
    private ManagerHomestayDao managerHomestayDao;
    @Autowired
    private BookingService bookingService;
    @Autowired
    private RoomService roomService;
    @Autowired
    private HomestayService homestayService;
    @Autowired
    private ServiceService serviceService;

    // User: xem và thanh toán các booking của mình
    @GetMapping("/user/payments")
    public String userPayments(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";
        List<Map<String,Object>> payments = paymentService.getPaymentsByUser(user.getId());
        model.addAttribute("payments", payments);
        return "payment/user_payment_list";
    }

    @PostMapping("/user/payments/{id}/pay")
    public String pay(@PathVariable int id, @RequestParam(value = "method", required = false) String method, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";
        paymentService.pay(id, user.getId(), method);
        // Sau khi thanh toán thành công, chuyển về lịch sử thanh toán
        return "redirect:/user/payments";
    }

    @GetMapping("/user/payments/{id}/pay")
    public String paymentDetail(@PathVariable int id, HttpSession session, Model model,
                                @RequestParam(value = "origin", required = false) String origin) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";
        Map<String,Object> payment = paymentService.getPaymentById(id);
        if (payment == null) {
            model.addAttribute("error", "Không tìm thấy thông tin thanh toán.");
            return "redirect:/user/payments";
        }
        int bookingId = (int) payment.get("booking_id");
        com.homestay.model.Booking booking = bookingService.getBookingById(bookingId);
        com.homestay.model.Room room = null;
        com.homestay.model.Homestay homestay = null;
        if (booking != null) {
            room = roomService.getRoomById(booking.getRoomId());
            if (room != null) {
                homestay = homestayService.getHomestayById(room.getHomestayId());
            }
        }
        // Lấy dịch vụ đã chọn từ database thay vì session
        List<com.homestay.model.Service> selectedServices = serviceService.getServicesByBookingId(bookingId);
        java.math.BigDecimal totalServiceAmount = java.math.BigDecimal.ZERO;
        
        if (selectedServices != null && !selectedServices.isEmpty()) {
            for (com.homestay.model.Service service : selectedServices) {
                // Cộng tiền dịch vụ
                if (service.getPrice() != null) {
                    totalServiceAmount = totalServiceAmount.add(service.getPrice());
                }
            }
        }
        
        // Tính tổng hiển thị: nếu đến từ đặt dịch vụ thì chỉ tính tiền dịch vụ
        boolean serviceOnly = "service" != null && "service".equalsIgnoreCase(origin);
        java.math.BigDecimal roomPrice = room != null && room.getPrice() != null ? room.getPrice() : java.math.BigDecimal.ZERO;
        java.math.BigDecimal totalAmount = serviceOnly ? totalServiceAmount : roomPrice.add(totalServiceAmount);
        
        model.addAttribute("payment", payment);
        model.addAttribute("booking", booking);
        model.addAttribute("room", room);
        model.addAttribute("homestay", homestay);
        model.addAttribute("selectedServices", selectedServices);
        model.addAttribute("totalServiceAmount", totalServiceAmount);
        model.addAttribute("totalAmount", totalAmount);
        model.addAttribute("serviceOnly", serviceOnly);
        return "payment/user_payment_detail";
    }

    // Manager: xem trạng thái thanh toán các booking thuộc homestay mình quản lý
    @GetMapping("/manager/payments")
    public String managerPayments(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"MANAGER".equals(user.getRole())) return "redirect:/login";
        List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(user.getId());
        List<Map<String,Object>> payments = paymentService.getPaymentsByHomestayIds(homestayIds);
        model.addAttribute("payments", payments);
        return "payment/manager_payment_list";
    }

    // Manager: xác nhận thanh toán tiền mặt
    @PostMapping("/manager/payments/{id}/confirm")
    public String confirmCashPayment(@PathVariable int id, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"MANAGER".equals(user.getRole())) return "redirect:/login";
        
        boolean success = paymentService.confirmCashPayment(id);
        if (success) {
            // Có thể thêm thông báo thành công
        }
        return "redirect:/manager/payments";
    }
}
