package com.homestay.controller;

import com.homestay.model.Homestay;
import com.homestay.model.User;
import com.homestay.service.HomestayService;
import com.homestay.service.UserService;
import com.homestay.service.RoomService;
import com.homestay.service.StatisticsService;
import com.homestay.dao.ManagerHomestayDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class ManagerAuthController {
    @Autowired
    private UserService userService;
    @Autowired
    private HomestayService homestayService;
    @Autowired
    private RoomService roomService;
    @Autowired
    private ManagerHomestayDao managerHomestayDao;
    @Autowired
    private StatisticsService statisticsService;

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
        // 1. Tạo user manager trước
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole("MANAGER");
        user.setActive(true);
        boolean userOk = userService.register(user);
        if (!userOk) {
            model.addAttribute("error", "Không tạo được tài khoản quản lý");
            return "manager/register";
        }
        // Lấy lại userId vừa tạo
        User createdUser = userService.getAllUsers().stream()
            .filter(u -> u.getUsername().equals(username))
            .findFirst().orElse(null);
        if (createdUser == null) {
            model.addAttribute("error", "Không lấy được user vừa tạo");
            return "manager/register";
        }
        // 2. Tạo homestay mới
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
        // 3. Gán quyền quản lý (thêm vào bảng manager_homestays)
        managerHomestayDao.addManagerHomestay(createdUser.getId(), homestayId);
        model.addAttribute("message", "Đăng ký quản lý thành công. Vui lòng đăng nhập.");
        return "redirect:/login";
    }

    @GetMapping("/manager/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        // Lấy danh sách homestayId manager quản lý
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        java.util.List<com.homestay.model.Homestay> homestays = new java.util.ArrayList<>();
        java.util.Map<Integer, java.util.List<com.homestay.model.Room>> roomsByHomestay = new java.util.HashMap<>();
        for (Integer id : homestayIds) {
            com.homestay.model.Homestay h = homestayService.getHomestayById(id);
            if (h != null) {
                homestays.add(h);
                roomsByHomestay.put(id, roomService.getRoomsByHomestayId(id));
            }
        }
        model.addAttribute("homestays", homestays);
        model.addAttribute("roomsByHomestay", roomsByHomestay);
        return "manager/dashboard";
    }

    // @GetMapping("/manager/homestays")
    // public String managerHomestayList(HttpSession session, Model model) {
    //     User currentUser = (User) session.getAttribute("currentUser");
    //     if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
    //         return "redirect:/login";
    //     }
    //     java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
    //     java.util.List<com.homestay.model.Homestay> homestays = new java.util.ArrayList<>();
    //     java.util.Map<Integer, java.util.List<com.homestay.model.Room>> roomsByHomestay = new java.util.HashMap<>();
    //     for (Integer id : homestayIds) {
    //         com.homestay.model.Homestay h = homestayService.getHomestayById(id);
    //         if (h != null) {
    //             homestays.add(h);
    //             roomsByHomestay.put(id, roomService.getRoomsByHomestayId(id));
    //         }
    //     }
    //     model.addAttribute("homestays", homestays);
    //     model.addAttribute("roomsByHomestay", roomsByHomestay);
    //     return "homestay/homestay_list";
    // }

    @GetMapping("/manager/statistics")
    public String statistics(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        // Truyền dữ liệu thống kê thực
        model.addAttribute("overviewStats", statisticsService.getOverviewStatistics(currentUser.getId()));
        model.addAttribute("monthlyRevenue", statisticsService.getMonthlyRevenue(currentUser.getId()));
        model.addAttribute("monthlyBookings", statisticsService.getMonthlyBookings(currentUser.getId()));
        model.addAttribute("serviceStats", statisticsService.getServiceStatistics(currentUser.getId()));
        return "manager/statistics";
    }
}
