package com.homestay.service;

import com.homestay.dao.StatisticsDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.math.BigDecimal;

@Service
public class StatisticsService {
    
    @Autowired
    private StatisticsDao statisticsDao;
    
    public Map<String, Object> getOverviewStatistics(int managerId) {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            // Tổng doanh thu
            BigDecimal totalRevenue = statisticsDao.getTotalRevenue(managerId);
            stats.put("totalRevenue", totalRevenue != null ? totalRevenue : BigDecimal.ZERO);
            
            // Tổng lượt đặt phòng
            Integer totalBookings = statisticsDao.getTotalBookings(managerId);
            stats.put("totalBookings", totalBookings != null ? totalBookings : 0);
            
            // Tổng dịch vụ đã bán
            Integer totalServices = statisticsDao.getTotalServicesSold(managerId);
            stats.put("totalServices", totalServices != null ? totalServices : 0);
            
            // Số homestay quản lý
            Integer totalHomestays = statisticsDao.getTotalHomestays(managerId);
            stats.put("totalHomestays", totalHomestays != null ? totalHomestays : 0);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Trả về giá trị mặc định nếu có lỗi
            stats.put("totalRevenue", BigDecimal.ZERO);
            stats.put("totalBookings", 0);
            stats.put("totalServices", 0);
            stats.put("totalHomestays", 0);
        }
        
        return stats;
    }
    
    public List<Map<String, Object>> getMonthlyRevenue(int managerId) {
        try {
            return statisticsDao.getMonthlyRevenue(managerId);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of(); // Trả về list rỗng nếu có lỗi
        }
    }
    
    public List<Map<String, Object>> getMonthlyBookings(int managerId) {
        try {
            return statisticsDao.getMonthlyBookings(managerId);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of(); // Trả về list rỗng nếu có lỗi
        }
    }
    
    public List<Map<String, Object>> getServiceStatistics(int managerId) {
        try {
            return statisticsDao.getServiceStatistics(managerId);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of(); // Trả về list rỗng nếu có lỗi
        }
    }

    public java.math.BigDecimal getTotalRevenueByHomestayId(int homestayId) {
        try {
            return statisticsDao.getTotalRevenueByHomestayId(homestayId);
        } catch (Exception e) {
            e.printStackTrace();
            return java.math.BigDecimal.ZERO;
        }
    }
}
