package com.homestay.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.homestay.dao.ManagerHomestayDao;
import com.homestay.model.Service;
import com.homestay.model.User;
import com.homestay.service.ServiceService;

@Controller
public class ServiceController {
    @Autowired
    private ServiceService serviceService;
    @Autowired
    private ManagerHomestayDao managerHomestayDao;

    @GetMapping("/manager/services")
    public String managerServiceList(HttpSession session, Model model,
                                     @RequestParam(value = "homestayId", required = false) Integer homestayIdParam) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        java.util.List<com.homestay.model.Homestay> options = new java.util.ArrayList<>();
        for (Integer id : homestayIds) {
            com.homestay.model.Homestay h = ((com.homestay.service.HomestayService)
                    org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext()
                            .getBean("homestayService")).getHomestayById(id);
            if (h != null) options.add(h);
        }
        int targetHomestayId = (homestayIdParam != null) ? homestayIdParam : (homestayIds.isEmpty() ? 0 : homestayIds.get(0));
        
        // Lấy dịch vụ hiện tại của homestay
        java.util.List<com.homestay.model.Service> currentServices = serviceService.getServicesByHomestayId(targetHomestayId);
        
        // Lấy tất cả dịch vụ có sẵn từ database (loại bỏ trùng lặp)
        java.util.List<com.homestay.model.Service> allAvailableServices = serviceService.getDistinctServices();
        
        model.addAttribute("services", currentServices);
        model.addAttribute("allAvailableServices", allAvailableServices);
        model.addAttribute("homestayOptions", options);
        model.addAttribute("homestayId", targetHomestayId);
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
        // homestay options
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        java.util.List<com.homestay.model.Homestay> options = new java.util.ArrayList<>();
        for (Integer id : homestayIds) {
            com.homestay.model.Homestay h = ((com.homestay.service.HomestayService)
                    org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext()
                            .getBean("homestayService")).getHomestayById(id);
            if (h != null) options.add(h);
        }
        model.addAttribute("homestayOptions", options);
        return "service/service_form";
    }

    @PostMapping("/manager/services/add")
    public String addService(@ModelAttribute("service") com.homestay.model.Service service,
                             @RequestParam(value = "homestayId", required = false) Integer formHomestayId,
                             HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        int fallback = homestayIds.isEmpty() ? 0 : homestayIds.get(0);
        int targetHomestayId = (formHomestayId != null) ? formHomestayId : fallback;
        service.setHomestayId(targetHomestayId);
        serviceService.addService(service);
        return "redirect:/manager/services?homestayId=" + targetHomestayId;
    }

    @GetMapping("/manager/services/edit/{id}")
    public String showEditServiceForm(@PathVariable("id") int id, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        com.homestay.model.Service service = serviceService.getServiceById(id);
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        if (service == null || !homestayIds.contains(service.getHomestayId())) {
            return "redirect:/manager/services";
        }
        model.addAttribute("service", service);
        // homestay options
        java.util.List<com.homestay.model.Homestay> options = new java.util.ArrayList<>();
        for (Integer hid : homestayIds) {
            com.homestay.model.Homestay h = ((com.homestay.service.HomestayService)
                    org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext()
                            .getBean("homestayService")).getHomestayById(hid);
            if (h != null) options.add(h);
        }
        model.addAttribute("homestayOptions", options);
        return "service/service_form";
    }

    @PostMapping("/manager/services/edit")
    public String editService(@ModelAttribute("service") com.homestay.model.Service service,
                              @RequestParam(value = "homestayId", required = false) Integer formHomestayId,
                              HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        int fallback = homestayIds.isEmpty() ? 0 : homestayIds.get(0);
        int targetHomestayId = (formHomestayId != null) ? formHomestayId : fallback;
        // ensure the selected homestay belongs to manager
        if (!homestayIds.contains(targetHomestayId)) {
            return "redirect:/manager/services";
        }
        service.setHomestayId(targetHomestayId);
        serviceService.updateService(service);
        return "redirect:/manager/services?homestayId=" + targetHomestayId;
    }

    @GetMapping("/manager/services/delete/{id}")
    public String deleteService(@PathVariable("id") int id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "redirect:/login";
        }
        com.homestay.model.Service service = serviceService.getServiceById(id);
        java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        int homestayId = homestayIds.isEmpty() ? 0 : homestayIds.get(0);
        if (service != null && service.getHomestayId() == homestayId) {
            serviceService.deleteService(id);
        }
        return "redirect:/manager/services";
    }

    @PostMapping("/manager/services/delete-by-name")
    @ResponseBody
    public String deleteServiceByName(@RequestParam("name") String name, 
                                    @RequestParam("homestayId") int homestayId, 
                                    HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) {
            return "error";
        }
        
        // Kiểm tra quyền truy cập homestay
        java.util.List<Integer> managerHomestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
        if (!managerHomestayIds.contains(homestayId)) {
            return "error";
        }
        
        // Tìm và xóa dịch vụ theo tên
        java.util.List<com.homestay.model.Service> services = serviceService.getServicesByHomestayId(homestayId);
        for (com.homestay.model.Service service : services) {
            if (service.getName().equals(name)) {
                serviceService.deleteService(service.getId());
                return "success";
            }
		}
        return "not_found";
    }

    @GetMapping("/homestays/{homestayId}/services/json")
    @ResponseBody
    public java.util.List<com.homestay.model.Service> getServicesJson(@PathVariable("homestayId") int homestayId) {
        return serviceService.getServicesByHomestayId(homestayId);
    }
}
