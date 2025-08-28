package com.homestay.controller;

import com.homestay.model.Service;
import com.homestay.model.User;
import com.homestay.service.ServiceService;
import com.homestay.dao.ManagerHomestayDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class ServiceController {
    @Autowired
    private ServiceService serviceService;
    @Autowired
    private ManagerHomestayDao managerHomestayDao;

    @GetMapping("/manager/services")
    public String managerServiceList(HttpSession session, Model model,
                                     @RequestParam(value = "homestayId", required = false) Integer homestayIdParam) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        java.util.List<com.homestay.model.Homestay> options = new java.util.ArrayList<>();
        for (Integer id : homestayIds) {
            com.homestay.model.Homestay h = ((com.homestay.service.HomestayService)
                    org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext()
                            .getBean("homestayService")).getHomestayById(id);
            if (h != null) options.add(h);
        }
        int targetHomestayId = (homestayIdParam != null) ? homestayIdParam : (homestayIds.isEmpty() ? 0 : homestayIds.get(0));
        java.util.List<com.homestay.model.Service> services = serviceService.getServicesByHomestayId(targetHomestayId);
        model.addAttribute("services", services);
        model.addAttribute("homestayOptions", options);
        model.addAttribute("homestayId", targetHomestayId);
        return "service/service_list";
    }

    @GetMapping("/manager/services/add")
    public String showAddServiceForm(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        Service service = new Service();
        model.addAttribute("service", service);
        // homestay options
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        java.util.List<com.homestay.model.Homestay> options = new java.util.ArrayList<>();
        for (Integer id : homestayIds) {
            com.homestay.model.Homestay h = ((com.homestay.service.HomestayService)
                    org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext()
                            .getBean("homestayService")).getHomestayById(id);
            if (h != null) options.add(h);
        }
        model.addAttribute("homestayOptions", options);
        return "service/service_form";
    }

    @PostMapping("/manager/services/add")
    public String addService(@ModelAttribute("service") com.homestay.model.Service service,
                             @RequestParam(value = "homestayId", required = false) Integer formHomestayId,
                             HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        int fallback = homestayIds.isEmpty() ? 0 : homestayIds.get(0);
        int targetHomestayId = (formHomestayId != null) ? formHomestayId : fallback;
        service.setHomestayId(targetHomestayId);
        serviceService.addService(service);
        return "redirect:/manager/services?homestayId=" + targetHomestayId;
    }

    @GetMapping("/manager/services/edit/{id}")
    public String showEditServiceForm(@PathVariable("id") int id, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        com.homestay.model.Service service = serviceService.getServiceById(id);
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        if (service == null || !homestayIds.contains(service.getHomestayId())) {
            return "redirect:/manager/services";
        }
        model.addAttribute("service", service);
        // homestay options
        java.util.List<com.homestay.model.Homestay> options = new java.util.ArrayList<>();
        for (Integer hid : homestayIds) {
            com.homestay.model.Homestay h = ((com.homestay.service.HomestayService)
                    org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext()
                            .getBean("homestayService")).getHomestayById(hid);
            if (h != null) options.add(h);
        }
        model.addAttribute("homestayOptions", options);
        return "service/service_form";
    }

    @PostMapping("/manager/services/edit")
    public String editService(@ModelAttribute("service") com.homestay.model.Service service,
                              @RequestParam(value = "homestayId", required = false) Integer formHomestayId,
                              HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        int fallback = homestayIds.isEmpty() ? 0 : homestayIds.get(0);
        int targetHomestayId = (formHomestayId != null) ? formHomestayId : fallback;
        // ensure the selected homestay belongs to manager
        if (!homestayIds.contains(targetHomestayId)) {
            return "redirect:/manager/services";
        }
        service.setHomestayId(targetHomestayId);
        serviceService.updateService(service);
        return "redirect:/manager/services?homestayId=" + targetHomestayId;
    }

    @GetMapping("/manager/services/delete/{id}")
    public String deleteService(@PathVariable("id") int id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        com.homestay.model.Service service = serviceService.getServiceById(id);
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        int homestayId = homestayIds.isEmpty() ? 0 : homestayIds.get(0);
        if (service != null && service.getHomestayId() == homestayId) {
            serviceService.deleteService(id);
        }
        return "redirect:/manager/services";
    }

    @GetMapping("/services")
    public String publicServiceSlider(Model model) {
        java.util.List<com.homestay.model.Service> services = serviceService.getAllServices();
        model.addAttribute("services", services);
        return "service/service_slider";
    }

    // User chọn dịch vụ cho booking của mình
    @GetMapping("/user/services/book")
    public String showServiceBookingForm(Model model, javax.servlet.http.HttpSession session,
                                         @org.springframework.web.bind.annotation.RequestParam(value = "bookingId", required = false) Integer bookingId,
                                         @org.springframework.web.bind.annotation.RequestParam(value = "homestayId", required = false) Integer homestayId) {
        com.homestay.model.User currentUser = (com.homestay.model.User) session.getAttribute("currentUser");
        if (currentUser == null) return "redirect:/login";
        // Lấy danh sách booking hợp lệ của user
        java.util.List<java.util.Map<String,Object>> bookings = ((com.homestay.service.BookingService)
                org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext().getBean("bookingService"))
                .getActiveBookingsByUser(currentUser.getId());
        if (bookings == null || bookings.isEmpty()) {
            model.addAttribute("error", "Bạn cần có đặt phòng trước khi chọn dịch vụ.");
            return "booking/history";
        }
        // Xác định homestayId mục tiêu
        Integer targetHomestayId = homestayId;
        if (targetHomestayId == null && bookingId != null) {
            for (java.util.Map<String,Object> b : bookings) {
                if (((Integer)b.get("booking_id")).equals(bookingId)) { targetHomestayId = (Integer) b.get("homestay_id"); break; }
            }
        }
        // Nếu chưa xác định, lấy từ booking đầu tiên
        if (targetHomestayId == null) targetHomestayId = (Integer) bookings.get(0).get("homestay_id");
        // Dịch vụ theo homestay
        java.util.List<com.homestay.model.Service> services = serviceService.getServicesByHomestayId(targetHomestayId);
        model.addAttribute("bookings", bookings);
        model.addAttribute("services", services);
        model.addAttribute("selectedBookingId", bookingId != null ? bookingId : (Integer) bookings.get(0).get("booking_id"));
        return "service/service_booking_form";
    }

    @org.springframework.web.bind.annotation.PostMapping("/user/services/book")
    public String submitServiceBooking(javax.servlet.http.HttpServletRequest request,
                                       javax.servlet.http.HttpSession session,
                                       Model model,
                                       @org.springframework.web.bind.annotation.RequestParam("bookingId") int bookingId,
                                       @org.springframework.web.bind.annotation.RequestParam(value = "serviceIds", required = false) java.util.List<Integer> serviceIds) {
        com.homestay.model.User currentUser = (com.homestay.model.User) session.getAttribute("currentUser");
        if (currentUser == null) return "redirect:/login";
        if (serviceIds != null && !serviceIds.isEmpty()) {
            ((com.homestay.service.BookingService) org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext().getBean("bookingService"))
                .saveSelectedServices(bookingId, serviceIds);
            // Lưu vào session để trang thanh toán hiển thị danh sách và tính tổng dịch vụ
            java.util.List<String> idsAsString = new java.util.ArrayList<>();
            for (Integer id : serviceIds) idsAsString.add(String.valueOf(id));
            session.setAttribute("selectedServices_" + bookingId, idsAsString);
        }
        // Điều hướng sang trang thanh toán của booking này
        com.homestay.service.PaymentService paymentService = (com.homestay.service.PaymentService)
                org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext().getBean("paymentService");
        java.util.Map<String,Object> payment = paymentService.getLatestPaymentByBooking(bookingId);
        if (payment != null) {
            return "redirect:/user/payments/" + payment.get("id") + "/pay?origin=service";
        }
        // Nếu chưa có payment, tạo mới với số tiền 0 và chuyển tới
        int newPaymentId = paymentService.createPayment(bookingId, java.math.BigDecimal.ZERO);
        return "redirect:/user/payments/" + newPaymentId + "/pay?origin=service";
    }

    @GetMapping("/homestays/{homestayId}/services/json")
    @ResponseBody
    public java.util.List<com.homestay.model.Service> getServicesJson(@PathVariable("homestayId") int homestayId) {
        return serviceService.getServicesByHomestayId(homestayId);
    }
}
