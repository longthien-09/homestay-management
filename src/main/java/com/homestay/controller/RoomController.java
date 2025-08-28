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
import org.springframework.web.multipart.MultipartFile;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
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

    @GetMapping("/homestays/{homestayId}/rooms")
    public String listRoomsByHomestay(@PathVariable("homestayId") int homestayId, Model model) {
        List<Room> rooms = roomService.getRoomsByHomestayId(homestayId);
        model.addAttribute("rooms", rooms);
        model.addAttribute("homestayId", homestayId);
        return "room/user_list";
    }

    // Hiển thị danh sách phòng cho manager theo homestay
    @GetMapping("/manager/homestays/{homestayId}/rooms")
    public String managerListRooms(@PathVariable("homestayId") int homestayId, Model model, HttpSession session) {
        model.addAttribute("homestayId", homestayId);
        model.addAttribute("rooms", roomService.getRoomsByHomestayId(homestayId));
        // Thêm tên homestay để hiển thị trong danh sách
        com.homestay.model.Homestay hs = ((com.homestay.service.HomestayService)
                org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext()
                .getBean("homestayService")).getHomestayById(homestayId);
        if (hs != null) model.addAttribute("homestayName", hs.getName());
        // Thêm dropdown các homestay mà manager quản lý
        com.homestay.model.User currentUser = (com.homestay.model.User) session.getAttribute("currentUser");
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            java.util.List<Integer> ids = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
            java.util.List<com.homestay.model.Homestay> options = new java.util.ArrayList<>();
            for (Integer id : ids) {
                com.homestay.model.Homestay hso = homestayService.getHomestayById(id);
                if (hso != null) options.add(hso);
            }
            model.addAttribute("homestayOptions", options);
        }
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
                                 @RequestParam(value = "homestayId", required = false) Integer formHomestayId,
                                 @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                 javax.servlet.http.HttpServletRequest request) {
        int targetHomestayId = (formHomestayId != null) ? formHomestayId : homestayId;
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                javax.servlet.ServletContext servletContext = request.getServletContext();
                String uploadsDir = "/uploads";
                String realPath = servletContext.getRealPath(uploadsDir);
                if (realPath != null) {
                    Files.createDirectories(Paths.get(realPath));
                    String filename = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                    Path target = Paths.get(realPath, filename);
                    Files.copy(imageFile.getInputStream(), target, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    room.setImage(servletContext.getContextPath() + uploadsDir + "/" + filename);
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
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
                                  @RequestParam(value = "homestayId", required = false) Integer formHomestayId,
                                  @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                  javax.servlet.http.HttpServletRequest request) {
        int targetHomestayId = (formHomestayId != null) ? formHomestayId : homestayId;
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                javax.servlet.ServletContext servletContext = request.getServletContext();
                String uploadsDir = "/uploads";
                String realPath = servletContext.getRealPath(uploadsDir);
                if (realPath != null) {
                    Files.createDirectories(Paths.get(realPath));
                    String filename = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                    Path target = Paths.get(realPath, filename);
                    Files.copy(imageFile.getInputStream(), target, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    room.setImage(servletContext.getContextPath() + uploadsDir + "/" + filename);
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
        room.setHomestayId(targetHomestayId);
        roomService.updateRoom(room);
        return "redirect:/manager/homestays/" + targetHomestayId + "/rooms";
    }
    @GetMapping("/manager/homestays/{homestayId}/rooms/delete/{roomId}")
    public String managerDeleteRoom(@PathVariable("homestayId") int homestayId, @PathVariable("roomId") int roomId) {
        roomService.deleteRoom(roomId);
        return "redirect:/manager/homestays/" + homestayId + "/rooms";
    }

    @GetMapping("/homestays/{homestayId}/rooms/{roomId}")
    public String viewRoomDetail(@PathVariable("homestayId") int homestayId, @PathVariable("roomId") int roomId, Model model) {
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
