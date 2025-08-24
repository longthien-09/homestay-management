package com.homestay.controller;

import com.homestay.model.Service;
import com.homestay.model.User;
import com.homestay.service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class ServiceController {
    @Autowired
    private ServiceService serviceService;

    @GetMapping("/manager/services")
    public String managerServiceList(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        int homestayId = currentUser.getHomestayId() != null ? currentUser.getHomestayId() : 0;
        List<Service> services = serviceService.getServicesByHomestayId(homestayId);
        model.addAttribute("services", services);
        return "service/service_list";
    }

    @GetMapping("/manager/services/add")
    public String showAddServiceForm(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        Service service = new Service();
        model.addAttribute("service", service);
        return "service/service_form";
    }

    @PostMapping("/manager/services/add")
    public String addService(@ModelAttribute("service") Service service, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        service.setHomestayId(currentUser.getHomestayId());
        serviceService.addService(service);
        return "redirect:/manager/services";
    }

    @GetMapping("/manager/services/edit/{id}")
    public String showEditServiceForm(@PathVariable("id") int id, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        Service service = serviceService.getServiceById(id);
        if (service == null || service.getHomestayId() != currentUser.getHomestayId()) {
            return "redirect:/manager/services";
        }
        model.addAttribute("service", service);
        return "service/service_form";
    }

    @PostMapping("/manager/services/edit")
    public String editService(@ModelAttribute("service") Service service, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        service.setHomestayId(currentUser.getHomestayId());
        serviceService.updateService(service);
        return "redirect:/manager/services";
    }

    @GetMapping("/manager/services/delete/{id}")
    public String deleteService(@PathVariable("id") int id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        Service service = serviceService.getServiceById(id);
        if (service != null && service.getHomestayId() == currentUser.getHomestayId()) {
            serviceService.deleteService(id);
        }
        return "redirect:/manager/services";
    }

    @GetMapping("/homestays/{homestayId}/services/json")
    @ResponseBody
    public java.util.List<com.homestay.model.Service> getServicesJson(@PathVariable("homestayId") int homestayId) {
        return serviceService.getServicesByHomestayId(homestayId);
    }
}
