package com.homestay.controller;

import com.homestay.service.RoomService;
import com.homestay.service.HomestayService;
import com.homestay.dao.ManagerHomestayDao;
import com.homestay.model.Room;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.List;
// removed duplicate import
import javax.servlet.http.HttpSession;

@Controller
public class RoomController {
    @Autowired
    private RoomService roomService;
    @Autowired
    private HomestayService homestayService;
    @Autowired
    private ManagerHomestayDao managerHomestayDao;

    @GetMapping("/rooms")
    public String listRooms(Model model) {
        List<Room> rooms = roomService.getAllRooms();
        model.addAttribute("rooms", rooms);
        return "room/list";
    }


    // Hiển thị danh sách phòng cho manager theo homestay
    @GetMapping("/manager/homestays/{homestayId}/rooms")
    public String managerListRooms(@PathVariable("homestayId") int homestayId, Model model, HttpSession session) {
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("rooms", roomService.getRoomsByHomestayId(homestayId));
        
        // Thêm tên homestay để hiển thị trong header
        com.homestay.model.Homestay hs = ((com.homestay.service.HomestayService)
                org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext()
                .getBean("homestayService")).getHomestayById(homestayId);
        if (hs != null) model.addAttribute("homestayName", hs.getName());
        
        return "room/list";
    }
    @GetMapping("/manager/homestays/{homestayId}/rooms/add")
    public String managerAddRoomForm(@PathVariable("homestayId") int homestayId, Model model, HttpSession session) {
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("room", new com.homestay.model.Room());
        model.addAttribute("isEdit", false);
        // Nếu manager có nhiều homestay, cung cấp danh sách để chọn
        com.homestay.model.User currentUser = (com.homestay.model.User) session.getAttribute("currentUser");
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            java.util.List<Integer> ids = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
            java.util.List<com.homestay.model.Homestay> options = new java.util.ArrayList<>();
            for (Integer id : ids) {
                com.homestay.model.Homestay hs = homestayService.getHomestayById(id);
                if (hs != null) options.add(hs);
            }
            model.addAttribute("homestayOptions", options);
        }
        return "room/room_form";
    }
    @PostMapping("/manager/homestays/{homestayId}/rooms/add")
    public String managerAddRoom(@PathVariable("homestayId") int homestayId,
                                 @ModelAttribute com.homestay.model.Room room,
                                 @RequestParam(value = "homestayId", required = false) Integer formHomestayId) {
        int targetHomestayId = (formHomestayId != null) ? formHomestayId : homestayId;
        room.setHomestayId(targetHomestayId);
        roomService.addRoom(room);
        return "redirect:/manager/homestays/" + targetHomestayId + "/rooms";
    }
    @GetMapping("/manager/homestays/{homestayId}/rooms/edit/{roomId}")
    public String managerEditRoomForm(@PathVariable("homestayId") int homestayId, @PathVariable("roomId") int roomId, Model model, HttpSession session) {
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("room", roomService.getRoomById(roomId));
        model.addAttribute("isEdit", true);
        com.homestay.model.User currentUser = (com.homestay.model.User) session.getAttribute("currentUser");
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            java.util.List<Integer> ids = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
            java.util.List<com.homestay.model.Homestay> options = new java.util.ArrayList<>();
            for (Integer id : ids) {
                com.homestay.model.Homestay hs = homestayService.getHomestayById(id);
                if (hs != null) options.add(hs);
            }
            model.addAttribute("homestayOptions", options);
        }
        return "room/room_form";
    }
    @PostMapping("/manager/homestays/{homestayId}/rooms/edit")
    public String managerEditRoom(@PathVariable("homestayId") int homestayId,
                                  @ModelAttribute com.homestay.model.Room room,
                                  @RequestParam(value = "homestayId", required = false) Integer formHomestayId) {
        int targetHomestayId = (formHomestayId != null) ? formHomestayId : homestayId;
        room.setHomestayId(targetHomestayId);
        roomService.updateRoom(room);
        return "redirect:/manager/homestays/" + targetHomestayId + "/rooms";
    }
    @GetMapping("/manager/homestays/{homestayId}/rooms/delete/{roomId}")
    public String managerDeleteRoom(@PathVariable("homestayId") int homestayId, @PathVariable("roomId") int roomId) {
        roomService.deleteRoom(roomId);
        return "redirect:/manager/homestays/" + homestayId + "/rooms";
    }


    // Endpoint tìm kiếm phòng trống từ dashboard
    @GetMapping("/manager/search-rooms")
    public String searchAvailableRooms(@RequestParam("homestayId") int homestayId,
                                      @RequestParam("checkInDate") String checkInDate,
                                      @RequestParam("checkOutDate") String checkOutDate,
                                      @RequestParam(value = "roomType", required = false) String roomType,
                                      @RequestParam(value = "maxPrice", required = false) String maxPrice,
                                      Model model, HttpSession session) {
        
        // Kiểm tra quyền truy cập
        com.homestay.model.User currentUser = (com.homestay.model.User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        
        // Kiểm tra xem manager có quản lý homestay này không
        java.util.List<Integer> managedHomestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        if (!managedHomestayIds.contains(homestayId)) {
            return "redirect:/manager/dashboard";
        }
        
        try {
            java.time.LocalDate checkIn = java.time.LocalDate.parse(checkInDate);
            java.time.LocalDate checkOut = java.time.LocalDate.parse(checkOutDate);
            
            // Lấy danh sách phòng cơ bản
            List<Room> allRooms = roomService.getRoomsByHomestayId(homestayId);
            List<Room> availableRooms = new java.util.ArrayList<>();
            
            // Lấy danh sách phòng đã được đặt trong khoảng thời gian
            List<Integer> bookedRoomIds = getBookedRoomIdsInDateRange(homestayId, checkIn, checkOut);
            
            // Lọc phòng trống và áp dụng các filter khác
            for (Room room : allRooms) {
                // Chỉ lấy phòng trống (không có trong danh sách đã đặt)
                if (!bookedRoomIds.contains(room.getId())) {
                    // Lọc theo loại phòng
                    if (roomType != null && !roomType.trim().isEmpty() && !roomType.equals(room.getType())) {
                        continue;
                    }
                    
                    // Lọc theo giá tối đa
                    if (maxPrice != null && !maxPrice.trim().isEmpty()) {
                        try {
                            java.math.BigDecimal maxPriceBD = new java.math.BigDecimal(maxPrice);
                            if (room.getPrice() == null || room.getPrice().compareTo(maxPriceBD) > 0) {
                                continue;
                            }
                        } catch (NumberFormatException e) {
                            // Bỏ qua filter giá nếu không hợp lệ
                        }
                    }
                    
                    availableRooms.add(room);
                }
            }
            
            // Thêm thông tin vào model
            model.addAttribute("homestayId", homestayId);
            model.addAttribute("rooms", availableRooms);
            model.addAttribute("checkInDate", checkInDate);
            model.addAttribute("checkOutDate", checkOutDate);
            model.addAttribute("roomType", roomType);
            model.addAttribute("maxPrice", maxPrice);
            
            // Thêm tên homestay
            com.homestay.model.Homestay hs = homestayService.getHomestayById(homestayId);
            if (hs != null) {
                model.addAttribute("homestayName", hs.getName());
            }
            
            return "room/search_results";
            
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/manager/dashboard";
        }
    }
    
    // Helper method để lấy danh sách ID phòng đã được đặt trong khoảng thời gian
    private List<Integer> getBookedRoomIdsInDateRange(int homestayId, java.time.LocalDate checkIn, java.time.LocalDate checkOut) {
        List<Integer> bookedRoomIds = new java.util.ArrayList<>();
        try {
            // Query để lấy các phòng đã được đặt trong khoảng thời gian
            String sql = "SELECT DISTINCT r.id FROM rooms r " +
                        "INNER JOIN bookings b ON r.id = b.room_id " +
                        "WHERE r.homestay_id = ? " +
                        "AND b.status IN ('PENDING', 'CONFIRMED') " +
                        "AND NOT (b.check_out <= ? OR b.check_in >= ?)";
            
            javax.sql.DataSource dataSource = (javax.sql.DataSource) org.springframework.web.context.ContextLoader
                    .getCurrentWebApplicationContext()
                    .getBean("dataSource");
            
            try (java.sql.Connection conn = dataSource.getConnection();
                 java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, homestayId);
                ps.setDate(2, java.sql.Date.valueOf(checkIn));
                ps.setDate(3, java.sql.Date.valueOf(checkOut));
                
                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        bookedRoomIds.add(rs.getInt("id"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookedRoomIds;
    }
}
