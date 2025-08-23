package com.homestay.controller;

import com.homestay.model.Homestay;
import com.homestay.service.HomestayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import java.util.List;

@Controller
public class HomestayController {
    @Autowired
    private HomestayService homestayService;

    @GetMapping("/homestays")
    public String listHomestays(Model model) {
        List<Homestay> homestays = homestayService.getAllHomestays();
        model.addAttribute("homestays", homestays);
        return "homestay/homestay_public_list";
    }

    @GetMapping("/homestays/{id}")
    public String viewHomestayDetail(@PathVariable int id, Model model) {
        Homestay homestay = homestayService.getHomestayById(id);
        if (homestay != null) {
            model.addAttribute("homestay", homestay);
            return "homestay/homestay_detail";
        } else {
            return "redirect:/homestay-management/homestays";
        }
    }
}
