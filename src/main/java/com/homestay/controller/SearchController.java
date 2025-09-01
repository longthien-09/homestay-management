package com.homestay.controller;

import com.homestay.model.Homestay;
import com.homestay.service.HomestayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.List;

@Controller
public class SearchController {
    
    @Autowired
    private HomestayService homestayService;
    
    @GetMapping("/search")
    public String search(@RequestParam(value = "location", required = false) String location,
                        @RequestParam(value = "checkin", required = false) String checkin,
                        @RequestParam(value = "checkout", required = false) String checkout,
                        @RequestParam(value = "guests", required = false) String guests,
                        @RequestParam(value = "propertyType", required = false) String propertyType,
                        @RequestParam(value = "amenities", required = false) List<String> amenities,
                        @RequestParam(value = "rating", required = false) List<String> rating,
                        @RequestParam(value = "guestRating", required = false) List<String> guestRating,
                        @RequestParam(value = "cancellation", required = false) String cancellation,
                        @RequestParam(value = "minPrice", required = false) Double minPrice,
                        @RequestParam(value = "maxPrice", required = false) Double maxPrice,
                        @RequestParam(value = "sort", required = false, defaultValue = "popular") String sort,
                        Model model) {
        
        // Add search parameters to model for display
        model.addAttribute("location", location);
        model.addAttribute("checkin", checkin);
        model.addAttribute("checkout", checkout);
        model.addAttribute("guests", guests);
        
        // Get search results based on parameters
        List<Homestay> searchResults;
        if (location != null && !location.trim().isEmpty()) {
            // Use existing search method with location as keyword
            searchResults = homestayService.search(location, null, null, null);
        } else {
            // If no location specified, get all homestays
            searchResults = homestayService.getAllHomestays();
        }
        
        // Lấy services và giá phòng cho mỗi homestay để hiển thị
        for (Homestay homestay : searchResults) {
            List<String> services = homestayService.getServiceNamesByHomestayId(homestay.getId());
            if (!services.isEmpty()) {
                // Cập nhật description để bao gồm services
                String currentDesc = homestay.getDescription() != null ? homestay.getDescription() : "";
                homestay.setDescription(currentDesc + " | Dịch vụ: " + String.join(", ", services));
            }
            
            // Lấy thông tin giá phòng
            java.util.Map<String, Object> priceInfo = homestayService.getRoomPriceInfoByHomestayId(homestay.getId());
            if (priceInfo.containsKey("minPrice")) {
                homestay.setDescription(homestay.getDescription() + " | Giá: " + priceInfo.get("minPrice") + " - " + priceInfo.get("maxPrice"));
            }
        }
        
        // Add search results to model
        model.addAttribute("searchResults", searchResults);
        
        // Add search criteria for filters
        model.addAttribute("propertyType", propertyType);
        model.addAttribute("amenities", amenities);
        model.addAttribute("rating", rating);
        model.addAttribute("guestRating", guestRating);
        model.addAttribute("cancellation", cancellation);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sort", sort);
        
        return "search-results";
    }
}
