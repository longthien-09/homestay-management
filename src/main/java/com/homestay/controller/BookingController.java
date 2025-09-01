package com.homestay.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.homestay.model.Homestay;
import com.homestay.model.Room;

@Controller
@RequestMapping("/booking")
public class BookingController {

    @GetMapping("/details")
    public String showBookingDetails(
            @RequestParam(required = false) String checkin,
            @RequestParam(required = false) String checkout,
            @RequestParam(required = false) String guests,
            Model model) {
        
        // Tạo dữ liệu mẫu cho homestay và room
        Homestay homestay = createSampleHomestay();
        Room room = createSampleRoom();
        
        // Thêm dữ liệu vào model
        model.addAttribute("homestay", homestay);
        model.addAttribute("room", room);
        model.addAttribute("checkin", checkin);
        model.addAttribute("checkout", checkout);
        model.addAttribute("guests", guests);
        
        return "booking-details";
    }
    
    @GetMapping("/final")
    public String showFinalBooking(Model model) {
        // Trang cuối cùng của quy trình đặt phòng
        return "booking-final";
    }
    
    private Homestay createSampleHomestay() {
        Homestay homestay = new Homestay();
        homestay.setId(1);
        homestay.setName("TMS Luxury Codotel Quy Nhơn - Ban Công Trực Diện Biển, Có Bếp");
        homestay.setAddress("28 Nguyễn Huệ, Quy Nhơn, Việt Nam");
        homestay.setDescription("Homestay cao cấp với view biển tuyệt đẹp, tiện nghi hiện đại và dịch vụ 5 sao. Nằm ở vị trí đắc địa, cách biển chỉ 50m, Homestay Biển Quy Nhơn Premium mang đến cho bạn trải nghiệm nghỉ dưỡng hoàn hảo với không gian thoáng đãng, thiết kế hiện đại và dịch vụ chuyên nghiệp.");
        return homestay;
    }
    
    private Room createSampleRoom() {
        Room room = new Room();
        room.setId(1);
        room.setRoomNumber("DLX001");
        room.setType("Phòng 4 Người Nhìn Ra Biển");
        room.setPrice(new java.math.BigDecimal("1500000"));
        room.setStatus("Available");
        room.setDescription("Phòng Deluxe View Biển với thiết kế hiện đại, rộng rãi 45m², view biển tuyệt đẹp.");
        room.setHomestayId(1);
        room.setImage("https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80");
        return room;
    }
}
