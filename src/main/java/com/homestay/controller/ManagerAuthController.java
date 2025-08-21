package com.homestay.controller;

import com.homestay.model.Homestay;
import com.homestay.model.User;
import com.homestay.service.HomestayService;
import com.homestay.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/homestay-manager")
public class ManagerAuthController {
    @Autowired
    private UserService userService;
    @Autowired
    private HomestayService homestayService;

    @GetMapping("/login")
    public String loginPage() { return "manager/login"; }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        Model model,
                        HttpSession session) {
        User u = userService.login(username, password);
        if (u != null && "MANAGER".equals(u.getRole())) {
            session.setAttribute("currentUser", u);
            return "redirect:/home";
        }
        model.addAttribute("error", "Sai tài khoản/mật khẩu hoặc không phải MANAGER");
        return "manager/login";
    }

    @GetMapping("/register")
    public String registerPage() { return "manager/register"; }

    @PostMapping("/register")
    public String register(@RequestParam String username,
                           @RequestParam String password,
                           @RequestParam String fullName,
                           @RequestParam String email,
                           @RequestParam String phone,
                           @RequestParam String homestayName,
                           @RequestParam(required = false) String address,
                           @RequestParam(required = false) String hsEmail,
                           @RequestParam(required = false) String hsPhone,
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
        return "manager/login";
    }
}
