package com.homestay.controller;

import com.homestay.service.RoomService;
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

@Controller
public class RoomController {
    @Autowired
    private RoomService roomService;

    @GetMapping("/rooms")
    public String listRooms(Model model) {
        List<Room> rooms = roomService.getAllRooms();
        model.addAttribute("rooms", rooms);
        return "room/list";
    }

    @GetMapping("/homestays/{homestayId}/rooms")
    public String listRoomsByHomestay(@PathVariable int homestayId, Model model) {
        List<Room> rooms = roomService.getRoomsByHomestayId(homestayId);
        model.addAttribute("rooms", rooms);
        model.addAttribute("homestayId", homestayId);
        return "room/user_list";
    }

    // Hiển thị danh sách phòng cho admin theo homestay
    @GetMapping("/admin/homestays/{homestayId}/rooms")
    public String adminListRooms(@PathVariable int homestayId, Model model) {
        List<Room> rooms = roomService.getRoomsByHomestayId(homestayId);
        model.addAttribute("rooms", rooms);
        model.addAttribute("homestayId", homestayId);
        return "room/list";
    }

    // Hiển thị form thêm phòng
    @GetMapping("/admin/homestays/{homestayId}/rooms/add")
    public String showAddRoomForm(@PathVariable int homestayId, Model model) {
        Room room = new Room();
        room.setHomestayId(homestayId);
        model.addAttribute("room", room);
        model.addAttribute("homestayId", homestayId);
        return "room/room_form";
    }

    // Xử lý thêm phòng
    @PostMapping("/admin/homestays/{homestayId}/rooms/add")
    public String addRoom(@PathVariable int homestayId, @ModelAttribute Room room, @RequestParam("homestayId") int homestayIdParam) {
        room.setHomestayId(homestayIdParam);
        roomService.addRoom(room);
        return "redirect:/admin/homestays/" + homestayIdParam + "/rooms";
    }

    // Hiển thị form sửa phòng
    @GetMapping("/admin/homestays/{homestayId}/rooms/edit/{roomId}")
    public String showEditRoomForm(@PathVariable int homestayId, @PathVariable int roomId, Model model) {
        List<Room> rooms = roomService.getRoomsByHomestayId(homestayId);
        Room room = rooms.stream().filter(r -> r.getId() == roomId).findFirst().orElse(null);
        model.addAttribute("room", room);
        model.addAttribute("homestayId", homestayId);
        return "room/room_form";
    }

    // Xử lý sửa phòng
    @PostMapping("/admin/homestays/{homestayId}/rooms/edit")
    public String editRoom(@PathVariable int homestayId, @ModelAttribute Room room, @RequestParam("homestayId") int homestayIdParam) {
        room.setHomestayId(homestayIdParam);
        roomService.updateRoom(room);
        return "redirect:/admin/homestays/" + homestayIdParam + "/rooms";
    }

    // Xử lý xóa phòng
    @GetMapping("/admin/homestays/{homestayId}/rooms/delete/{roomId}")
    public String deleteRoom(@PathVariable int homestayId, @PathVariable int roomId) {
        roomService.deleteRoom(roomId);
        return "redirect:/admin/homestays/" + homestayId + "/rooms";
    }

    @GetMapping("/homestays/{homestayId}/rooms/{roomId}")
    public String viewRoomDetail(@PathVariable int homestayId, @PathVariable int roomId, Model model) {
        List<Room> rooms = roomService.getRoomsByHomestayId(homestayId);
        Room room = rooms.stream().filter(r -> r.getId() == roomId).findFirst().orElse(null);
        if (room != null) {
            model.addAttribute("room", room);
            model.addAttribute("homestayId", homestayId);
            return "room/room_detail";
        } else {
            return "redirect:/homestay-management/homestays/" + homestayId + "/rooms";
        }
    }
}
