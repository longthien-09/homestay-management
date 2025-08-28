package com.homestay.controller;

import com.homestay.service.StatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;
import java.util.List;
import javax.servlet.http.HttpSession;
import com.homestay.model.User;

@Controller
@RequestMapping("/manager")
public class StatisticsController {
    
    @Autowired
    private StatisticsService statisticsService;
    
    // NOTE: Trang /manager/statistics đã được map trong ManagerAuthController.
    // Controller này chỉ cung cấp các API JSON phục vụ thống kê để tránh trùng mapping.
    
    @GetMapping("/statistics/api/overview")
    @ResponseBody
    public Map<String, Object> getOverviewStats(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            return statisticsService.getOverviewStatistics(currentUser.getId());
        }
        return null;
    }
    
    @GetMapping("/statistics/api/monthly-revenue")
    @ResponseBody
    public List<Map<String, Object>> getMonthlyRevenue(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            return statisticsService.getMonthlyRevenue(currentUser.getId());
        }
        return null;
    }
    
    @GetMapping("/statistics/api/monthly-bookings")
    @ResponseBody
    public List<Map<String, Object>> getMonthlyBookings(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            return statisticsService.getMonthlyBookings(currentUser.getId());
        }
        return null;
    }
    
    @GetMapping("/statistics/api/services")
    @ResponseBody
    public List<Map<String, Object>> getServiceStats(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            return statisticsService.getServiceStatistics(currentUser.getId());
        }
        return null;
    }
}
