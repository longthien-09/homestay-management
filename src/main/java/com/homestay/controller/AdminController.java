package com.homestay.controller;

import com.homestay.model.Homestay;
import com.homestay.service.HomestayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/admin/homestays")
public class AdminController {
    @Autowired
    private HomestayService homestayService;

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
    public String addHomestay(@ModelAttribute Homestay homestay) {
        homestayService.addHomestay(homestay);
        return "redirect:/admin/homestays";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable int id, Model model) {
        Homestay homestay = homestayService.getHomestayById(id);
        model.addAttribute("homestay", homestay);
        return "homestay/homestay_form";
    }

    @PostMapping("/edit")
    public String editHomestay(@ModelAttribute Homestay homestay) {
        homestayService.updateHomestay(homestay);
        return "redirect:/admin/homestays";
    }

    @GetMapping("/delete/{id}")
    public String deleteHomestay(@PathVariable int id, Model model) {
        boolean success = homestayService.deleteHomestay(id);
        if (success) {
            System.out.println("Xóa homestay thành công với id: " + id);
        } else {
            System.err.println("Xóa homestay thất bại với id: " + id);
            model.addAttribute("error", "Không thể xóa homestay! Có thể do dữ liệu liên quan hoặc homestay không tồn tại.");
        }
        return "redirect:/admin/homestays";
    }
}
