package com.homestay.controller;

import com.homestay.model.User;
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
@RequestMapping("")
public class AuthController {
    @Autowired
    private UserService userService;

    @GetMapping("/")
    public String root() {
        return "redirect:/home";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam("username") String username, @RequestParam("password") String password, Model model, HttpSession session) {
        User user = userService.login(username, password);
        if (user != null) {
            User fullUser = userService.getUserById(user.getId());
            session.setAttribute("currentUser", fullUser);
            if ("ADMIN".equals(fullUser.getRole())) {
                return "redirect:/user/list"; // hoặc trang dashboard admin nếu có
            } else if ("MANAGER".equals(fullUser.getRole())) {
                return "redirect:/manager/dashboard";
            } else {
                return "redirect:/home";
            }
        } else {
            model.addAttribute("error", "Sai tài khoản hoặc mật khẩu hoặc tài khoản bị khóa!");
            return "login";
        }
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(User user, Model model) {
        boolean success = userService.register(user);
        if (success) {
            model.addAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "login";
        } else {
            model.addAttribute("error", "Tên đăng nhập đã tồn tại!");
            return "register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/home")
    public String home(Model model) {
        // Lấy 3 homestay ngẫu nhiên hiển thị nổi bật
        com.homestay.service.HomestayService homestayService = 
                (com.homestay.service.HomestayService) 
                org.springframework.web.context.ContextLoader
                  .getCurrentWebApplicationContext()
                  .getBean("homestayService");
        
        java.util.List<com.homestay.model.Homestay> featured = homestayService.getRandomHomestays(3);
        
        // Lấy services và giá phòng cho mỗi homestay nổi bật
        for (com.homestay.model.Homestay homestay : featured) {
            java.util.List<String> services = homestayService.getServiceNamesByHomestayId(homestay.getId());
            if (!services.isEmpty()) {
                String currentDesc = homestay.getDescription() != null ? homestay.getDescription() : "";
                homestay.setDescription(currentDesc + " | Dịch vụ: " + String.join(", ", services));
            }
            
            // Lấy thông tin giá phòng
            java.util.Map<String, Object> priceInfo = homestayService.getRoomPriceInfoByHomestayId(homestay.getId());
            if (priceInfo.containsKey("minPrice")) {
                homestay.setDescription(homestay.getDescription() + " | Giá: " + priceInfo.get("minPrice") + " - " + priceInfo.get("maxPrice"));
            }
        }
        
        model.addAttribute("featuredHomestays", featured);
        return "home";
    }
}
