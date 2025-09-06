package com.homestay.controller;

import com.homestay.model.User;
import com.homestay.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";
        // Sử dụng user từ session thay vì query lại từ DB
        model.addAttribute("user", user);
        return "user/profile";
    }

    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute("user") User user, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) return "redirect:/login";
        user.setId(currentUser.getId());
        user.setUsername(currentUser.getUsername());
        user.setRole(currentUser.getRole());
        user.setActive(currentUser.isActive());
        userService.updateUser(user);
        session.setAttribute("currentUser", userService.getUserById(user.getId()));
        model.addAttribute("user", userService.getUserById(user.getId()));
        model.addAttribute("message", "Cập nhật thành công!");
        return "user/profile";
    }

}
