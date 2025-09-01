package com.homestay.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.homestay.model.Homestay;
import com.homestay.model.Room;
import com.homestay.service.HomestayService;
import com.homestay.service.RoomService;

@Controller
@RequestMapping("/room")
public class RoomController {

    @Autowired
    private HomestayService homestayService;

    @Autowired
    private RoomService roomService;

    @GetMapping("/{roomId}")
    public String getRoomDetail(@PathVariable int roomId, Model model) {
        try {
            // Lấy thông tin phòng
            Room room = roomService.getRoomById(roomId);
            if (room == null) {
                // Nếu không tìm thấy phòng, tạo dữ liệu mẫu
                room = createSampleRoom();
            }

            // Lấy thông tin homestay
            Homestay homestay = null;
            if (room.getHomestayId() > 0) {
                homestay = homestayService.getHomestayById(room.getHomestayId());
            }
            
            if (homestay == null) {
                // Nếu không tìm thấy homestay, tạo dữ liệu mẫu
                homestay = createSampleHomestay();
            }

            // Thêm vào model
            model.addAttribute("room", room);
            model.addAttribute("homestay", homestay);

            return "room-detail";
        } catch (Exception e) {
            // Xử lý lỗi và trả về dữ liệu mẫu
            model.addAttribute("room", createSampleRoom());
            model.addAttribute("homestay", createSampleHomestay());
            return "room-detail";
        }
    }

    // Tạo dữ liệu mẫu cho phòng
    private Room createSampleRoom() {
        Room room = new Room();
        room.setId(1);
        room.setRoomNumber("DLX001");
        room.setType("Deluxe View Biển");
        room.setPrice(new java.math.BigDecimal("1500000"));
        room.setStatus("Available");
        room.setDescription("Phòng Deluxe View Biển với thiết kế hiện đại, rộng rãi 45m², view biển tuyệt đẹp.");
        room.setHomestayId(1);
        room.setImage("https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80");
        return room;
    }

    // Tạo dữ liệu mẫu cho homestay
    private Homestay createSampleHomestay() {
        Homestay homestay = new Homestay();
        homestay.setId(1);
        homestay.setName("Homestay Biển Quy Nhơn Premium");
        homestay.setAddress("Quy Nhơn, Bình Định");
        homestay.setDescription("Homestay cao cấp với view biển tuyệt đẹp, tiện nghi hiện đại và dịch vụ 5 sao. Nằm ở vị trí đắc địa, cách biển chỉ 50m, Homestay Biển Quy Nhơn Premium mang đến cho bạn trải nghiệm nghỉ dưỡng hoàn hảo với không gian thoáng đãng, thiết kế hiện đại và dịch vụ chuyên nghiệp.");
        return homestay;
    }
}
