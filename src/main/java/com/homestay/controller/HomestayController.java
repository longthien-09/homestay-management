package com.homestay.controller;

import com.homestay.dao.ManagerHomestayDao;
import com.homestay.model.Homestay;
import com.homestay.model.User;
import com.homestay.service.HomestayService;
// import removed: ServiceService unused
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
// import removed: RequestMapping unused
import org.springframework.web.multipart.MultipartFile;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.List;
import javax.servlet.http.HttpSession;

@Controller
public class HomestayController {
    @Autowired
    private HomestayService homestayService;
    @Autowired
    private ManagerHomestayDao managerHomestayDao;
    @Autowired
    private com.homestay.service.RoomService roomService;
    @Autowired
    private com.homestay.service.ServiceService serviceService;
    @Autowired
    private com.homestay.service.HomestayImageService homestayImageService;

    @GetMapping("/manager/homestays")
    public String listManagerHomestays(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        java.util.List<Homestay> homestays = new java.util.ArrayList<>();
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            java.util.List<Integer> homestayIds = managerHomestayDao.getHomestayIdsByManager(currentUser.getId());
            for (Integer id : homestayIds) {
                Homestay h = homestayService.getHomestayById(id);
                if (h != null) homestays.add(h);
            }
        }
        model.addAttribute("homestays", homestays);
        return "homestay/homestay_list";
    }

    @GetMapping("/manager/homestays/add")
    public String showAddForm(Model model) {
        model.addAttribute("homestay", new Homestay());
        return "homestay/homestay_form";
    }

    @PostMapping("/manager/homestays/add")
    public String addHomestay(@ModelAttribute Homestay homestay,
                              @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                              @RequestParam(value = "galleryFiles", required = false) MultipartFile[] galleryFiles,
                              HttpSession session, Model model) {
        // Handle image upload if provided
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                javax.servlet.ServletContext servletContext = ((org.springframework.web.context.request.ServletRequestAttributes) org.springframework.web.context.request.RequestContextHolder.currentRequestAttributes()).getRequest().getServletContext();
                String uploadsDir = "/uploads";
                String realPath = servletContext.getRealPath(uploadsDir);
                if (realPath != null) {
                    Files.createDirectories(Paths.get(realPath));
                    String filename = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                    Path target = Paths.get(realPath, filename);
                    Files.copy(imageFile.getInputStream(), target, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    homestay.setImage(servletContext.getContextPath() + uploadsDir + "/" + filename);
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
        User currentUser = (User) session.getAttribute("currentUser");
        // Nếu là manager thì gán quyền quản lý homestay mới
        if (currentUser != null && "MANAGER".equals(currentUser.getRole())) {
            int homestayId = homestayService.createHomestay(homestay);
            if (homestayId > 0) {
                managerHomestayDao.addManagerHomestay(currentUser.getId(), homestayId);
                // Lưu gallery nếu có
                if (galleryFiles != null && galleryFiles.length > 0) {
                    try {
                        javax.servlet.ServletContext servletContext = ((org.springframework.web.context.request.ServletRequestAttributes) org.springframework.web.context.request.RequestContextHolder.currentRequestAttributes()).getRequest().getServletContext();
                        String uploadsDir = "/uploads/homestays/" + homestayId;
                        String realPath = servletContext.getRealPath(uploadsDir);
                        if (realPath != null) {
                            Files.createDirectories(Paths.get(realPath));
                            int order = 1;
                            for (MultipartFile f : galleryFiles) {
                                if (f != null && !f.isEmpty()) {
                                    String filename = java.util.UUID.randomUUID().toString() + "_" + f.getOriginalFilename();
                                    Path target = Paths.get(realPath, filename);
                                    Files.copy(f.getInputStream(), target, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                                    String filePath = (uploadsDir + "/" + filename).replaceFirst("^/", "");
                                    homestayImageService.addImage(homestayId, filePath, order++);
                                }
                            }
                        }
                    } catch (IOException ex) { ex.printStackTrace(); }
                }
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

    @GetMapping("/manager/homestays/edit/{id}")
    public String showEditForm(@PathVariable("id") int id, Model model) {
        Homestay homestay = homestayService.getHomestayById(id);
        model.addAttribute("homestay", homestay);
        return "homestay/homestay_form";
    }

    @PostMapping("/manager/homestays/edit")
    public String editHomestay(@ModelAttribute Homestay homestay,
                               @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                               @RequestParam(value = "galleryFiles", required = false) MultipartFile[] galleryFiles) {
        // Handle optional new image upload
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                javax.servlet.ServletContext servletContext = ((org.springframework.web.context.request.ServletRequestAttributes) org.springframework.web.context.request.RequestContextHolder.currentRequestAttributes()).getRequest().getServletContext();
                String uploadsDir = "/uploads";
                String realPath = servletContext.getRealPath(uploadsDir);
                if (realPath != null) {
                    Files.createDirectories(Paths.get(realPath));
                    String filename = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                    Path target = Paths.get(realPath, filename);
                    Files.copy(imageFile.getInputStream(), target, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    homestay.setImage(servletContext.getContextPath() + uploadsDir + "/" + filename);
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
        homestayService.updateHomestay(homestay);
        // Lưu thêm gallery nếu upload mới
        if (galleryFiles != null && galleryFiles.length > 0) {
            try {
                javax.servlet.ServletContext servletContext = ((org.springframework.web.context.request.ServletRequestAttributes) org.springframework.web.context.request.RequestContextHolder.currentRequestAttributes()).getRequest().getServletContext();
                String uploadsDir = "/uploads/homestays/" + homestay.getId();
                String realPath = servletContext.getRealPath(uploadsDir);
                if (realPath != null) {
                    Files.createDirectories(Paths.get(realPath));
                    // sort_order tiếp nối
                    int order = homestayImageService.getImagesByHomestayId(homestay.getId()).size() + 1;
                    for (MultipartFile f : galleryFiles) {
                        if (f != null && !f.isEmpty()) {
                            String filename = java.util.UUID.randomUUID().toString() + "_" + f.getOriginalFilename();
                            Path target = Paths.get(realPath, filename);
                            Files.copy(f.getInputStream(), target, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                            String filePath = (uploadsDir + "/" + filename).replaceFirst("^/", "");
                            homestayImageService.addImage(homestay.getId(), filePath, order++);
                        }
                    }
                }
            } catch (IOException ex) { ex.printStackTrace(); }
        }
        return "redirect:/manager/homestays";
    }

    @GetMapping("/manager/homestays/delete/{id}")
    public String deleteHomestay(@PathVariable("id") int id, Model model) {
        boolean success = homestayService.deleteHomestay(id);
        if (!success) {
            model.addAttribute("error", "Không thể xóa homestay! Có thể do dữ liệu liên quan hoặc homestay không tồn tại.");
        }
        return "redirect:/manager/homestays";
    }

    @GetMapping("/homestays")
    public String publicListHomestays(Model model, 
                                    @RequestParam(value = "service", required = false) String serviceName,
                                    @RequestParam(value = "q", required = false) String keyword,
                                    @RequestParam(value = "roomType", required = false) String roomType,
                                    @RequestParam(value = "min", required = false) java.math.BigDecimal min,
                                    @RequestParam(value = "max", required = false) java.math.BigDecimal max,
                                    // Optional new params from home hero search
                                    @RequestParam(value = "checkin", required = false) String checkin,
                                    @RequestParam(value = "checkout", required = false) String checkout,
                                    @RequestParam(value = "guests", required = false) Integer guests,
                                    @RequestParam(value = "services", required = false) java.util.List<String> services,
                                    @RequestParam(value = "page", defaultValue = "1") int page,
                                    @RequestParam(value = "size", defaultValue = "6") int size) {
        // Nếu có ngày nhận/trả phòng -> ưu tiên tìm homestay còn phòng trống (DB)
        if (checkin != null && !checkin.trim().isEmpty() && checkout != null && !checkout.trim().isEmpty()) {
            try {
                java.time.LocalDate ci = java.time.LocalDate.parse(checkin);
                java.time.LocalDate co = java.time.LocalDate.parse(checkout);
                if (!co.isAfter(ci)) {
                    // Ngày không hợp lệ -> fallback sang search nhanh
                } else {
                    java.util.List<Homestay> list = homestayService.searchAvailableHomestays(keyword, roomType, ci, co, min, max);
                    model.addAttribute("homestays", list);
                    model.addAttribute("q", keyword);
                    model.addAttribute("roomType", roomType);
                    model.addAttribute("min", min);
                    model.addAttribute("max", max);
                    model.addAttribute("checkin", checkin);
                    model.addAttribute("checkout", checkout);
                    model.addAttribute("guests", guests);
                    // Giữ lại các dịch vụ đã chọn để re-check checkbox
                    model.addAttribute("selectedServices", services);
                    model.addAttribute("totalItems", list != null ? list.size() : 0);
                    model.addAttribute("totalPages", 1);
                    model.addAttribute("currentPage", 1);
                    model.addAttribute("pageSize", list != null ? list.size() : 0);
                    return "homestay/homestay_public_list";
                }
            } catch (Exception ignore) { /* fallback xuống dưới */ }
        }

        // Nếu có q/roomType/min/max → dùng search nhanh (giới hạn 30)
        if ((keyword != null && !keyword.trim().isEmpty()) ||
            (roomType != null && !roomType.trim().isEmpty()) ||
            min != null || max != null) {
            java.util.List<Homestay> list = homestayService.search(keyword, roomType, min, max);
            model.addAttribute("homestays", list);
            model.addAttribute("q", keyword);
            model.addAttribute("roomType", roomType);
            model.addAttribute("min", min);
            model.addAttribute("max", max);
            // Echo back optional params (chưa áp dụng lọc nâng cao ở đây)
            model.addAttribute("checkin", checkin);
            model.addAttribute("checkout", checkout);
            model.addAttribute("guests", guests);
            // Giữ lại các dịch vụ đã chọn để re-check checkbox
            model.addAttribute("selectedServices", services);
            model.addAttribute("totalItems", list != null ? list.size() : 0);
            model.addAttribute("totalPages", 1);
            model.addAttribute("currentPage", 1);
            model.addAttribute("pageSize", list != null ? list.size() : 0);
            return "homestay/homestay_public_list";
        }
        
        int totalItems;
        List<Homestay> homestays;
        
        if (serviceName != null && !serviceName.trim().isEmpty()) {
            // Lấy homestay có dịch vụ cụ thể với phân trang
            totalItems = homestayService.getTotalHomestaysByServiceName(serviceName);
            homestays = homestayService.getHomestaysByServiceNameWithPagination(serviceName, page, size);
            model.addAttribute("filteredByService", serviceName);
        } else {
            // Lấy tất cả homestay với phân trang
            totalItems = homestayService.getTotalHomestays();
            homestays = homestayService.getAllHomestaysWithPagination(page, size);
        }
        
        // Tính toán thông tin phân trang
        int totalPages = (int) Math.ceil((double) totalItems / size);
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        
        // Nếu chọn danh sách dịch vụ, áp dụng filter theo dịch vụ trên tập kết quả phân trang cơ bản
        if (services != null && !services.isEmpty()) {
            // Để đơn giản, bỏ qua phân trang khi có filter dịch vụ
            java.util.List<Homestay> filtered = homestayService.filterByServiceNames(services);
            model.addAttribute("homestays", filtered);
            model.addAttribute("totalItems", filtered != null ? filtered.size() : 0);
            model.addAttribute("totalPages", 1);
            model.addAttribute("currentPage", 1);
            model.addAttribute("pageSize", filtered != null ? filtered.size() : 0);
        } else {
            model.addAttribute("homestays", homestays);
            model.addAttribute("totalItems", totalItems);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("currentPage", page);
            model.addAttribute("pageSize", size);
        }
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        // Echo back optional params so UI giữ được giá trị
        model.addAttribute("q", keyword);
        model.addAttribute("roomType", roomType);
        model.addAttribute("min", min);
        model.addAttribute("max", max);
        model.addAttribute("checkin", checkin);
        model.addAttribute("checkout", checkout);
        model.addAttribute("guests", guests);
        model.addAttribute("selectedServices", services);
        
        return "homestay/homestay_public_list";
    }

    @GetMapping("/homestays/{id}")
    public String viewHomestayDetail(@PathVariable int id, Model model) {
        Homestay homestay = homestayService.getHomestayById(id);
        if (homestay != null) {
            model.addAttribute("homestay", homestay);
            
            // Lấy thông tin phòng
            List<com.homestay.model.Room> rooms = roomService.getRoomsByHomestayId(id);
            model.addAttribute("rooms", rooms);
            
            // Lấy dịch vụ của homestay
            List<com.homestay.model.Service> services = serviceService.getServicesByHomestayId(id);
            model.addAttribute("services", services);
            
            // Lấy danh sách ảnh (đường dẫn file) từ DB
            java.util.List<com.homestay.model.HomestayImage> images = homestayImageService.getImagesByHomestayId(id);
            model.addAttribute("images", images);
            
            // Tính giá từ thấp nhất
            java.math.BigDecimal minPrice = rooms.stream()
                .map(com.homestay.model.Room::getPrice)
                .filter(price -> price != null)
                .min(java.math.BigDecimal::compareTo)
                .orElse(java.math.BigDecimal.ZERO);
            model.addAttribute("minPrice", minPrice);
            
            return "homestay/homestay_detail";
        } else {
            return "redirect:/homestay-management/homestays";
        }
    }
}
