package com.homestay.controller;

import com.homestay.model.Homestay;
import com.homestay.model.User;
import com.homestay.service.HomestayService;
import com.homestay.service.UserService;
import com.homestay.service.ServiceService;
import com.homestay.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class ManagerAuthController {
    @Autowired
    private UserService userService;
    @Autowired
    private HomestayService homestayService;
    @Autowired
    private ServiceService serviceService;
    @Autowired
    private RoomService roomService;

    // Đã gộp login vào AuthController, không cần loginPage và login method ở đây nữa

    @GetMapping("/manager/register")
    public String registerPage() { return "manager/register"; }

    @PostMapping("/manager/register")
    public String register(@RequestParam("username") String username,
                           @RequestParam("password") String password,
                           @RequestParam("fullName") String fullName,
                           @RequestParam("email") String email,
                           @RequestParam("phone") String phone,
                           @RequestParam("homestayName") String homestayName,
                           @RequestParam(value = "address", required = false) String address,
                           @RequestParam(value = "hsEmail", required = false) String hsEmail,
                           @RequestParam(value = "hsPhone", required = false) String hsPhone,
                           Model model) {
        // Check username exists
        if (userService.getAllUsers().stream().anyMatch(u -> u.getUsername().equals(username))) {
            model.addAttribute("error", "Tên đăng nhập đã tồn tại");
            return "manager/register";
        }
        
        // Create homestay first
        Homestay h = new Homestay();
        h.setName(homestayName);
        h.setAddress(address);
        h.setEmail(hsEmail);
        h.setPhone(hsPhone);
        int homestayId = homestayService.createHomestay(h);
        if (homestayId <= 0) {
            model.addAttribute("error", "Không tạo được homestay");
            return "manager/register";
        }
        
        // Create manager user
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole("MANAGER");
        user.setHomestayId(homestayId);
        user.setActive(true);
        
        boolean ok = userService.register(user);
        if (!ok) {
            model.addAttribute("error", "Không tạo được tài khoản quản lý");
            return "manager/register";
        }
        
        model.addAttribute("message", "Đăng ký quản lý thành công. Vui lòng đăng nhập.");
        return "redirect:/login";
    }

    @GetMapping("/manager/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        Homestay homestay = null;
        int roomCount = 0;
        int bookingCount = 0;
        if (currentUser.getHomestayId() != null) {
            homestay = homestayService.getHomestayById(currentUser.getHomestayId());
            roomCount = roomService.getRoomsByHomestayId(currentUser.getHomestayId()).size();
            // bookingCount: cần bổ sung hàm đếm booking theo homestay nếu có, tạm để 0
        }
        int totalHomestay = homestayService.getAllHomestays().size();
        model.addAttribute("homestay", homestay);
        model.addAttribute("roomCount", roomCount);
        model.addAttribute("bookingCount", bookingCount);
        model.addAttribute("totalHomestay", totalHomestay);
        return "manager/dashboard";
    }

}
