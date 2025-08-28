/*package com.homestay.controller;

import com.homestay.dao.ManagerHomestayDao;
import com.homestay.model.Homestay;
import com.homestay.model.User;
import com.homestay.service.HomestayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/manager/homestays")
public class AdminController {
    @Autowired
    private HomestayService homestayService;
    @Autowired
    private ManagerHomestayDao managerHomestayDao;

    @GetMapping("")
    public String listHomestays(Model model) {
        List<Homestay> homestays = homestayService.getAllHomestays();
        model.addAttribute("homestays", homestays);
        return "homestay/homestay_list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("homestay", new Homestay());
        return "homestay/homestay_form";
    }

    @PostMapping("/add")
    public String addHomestay(@ModelAttribute Homestay homestay, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        // Nếu là manager thì gán quyền quản lý homestay mới
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            int homestayId = homestayService.createHomestay(homestay);
            if (homestayId > 0) {
                managerHomestayDao.addManagerHomestay(currentUser.getId(), homestayId);
                model.addAttribute("message", "Thêm homestay thành công!");
            } else {
                model.addAttribute("error", "Không thể thêm homestay!");
                return "homestay/homestay_form";
            }
        } else {
            // Nếu là admin thì chỉ thêm bình thường
            homestayService.addHomestay(homestay);
        }
        return "redirect:/manager/homestays";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") int id, Model model) {
        Homestay homestay = homestayService.getHomestayById(id);
        model.addAttribute("homestay", homestay);
        return "homestay/homestay_form";
    }

    @PostMapping("/edit")
    public String editHomestay(@ModelAttribute Homestay homestay) {
        homestayService.updateHomestay(homestay);
        return "redirect:/manager/homestays";
    }

    @GetMapping("/delete/{id}")
    public String deleteHomestay(@PathVariable("id") int id, Model model) {
        boolean success = homestayService.deleteHomestay(id);
        if (success) {
            System.out.println("Xóa homestay thành công với id: " + id);
        } else {
            System.err.println("Xóa homestay thất bại với id: " + id);
            model.addAttribute("error", "Không thể xóa homestay! Có thể do dữ liệu liên quan hoặc homestay không tồn tại.");
        }
        return "redirect:/manager/homestays";
    }
}*/
