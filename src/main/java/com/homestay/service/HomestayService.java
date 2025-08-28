package com.homestay.service;

import com.homestay.dao.HomestayDao;
import com.homestay.model.Homestay;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class HomestayService {
    @Autowired
    private HomestayDao homestayDao;

    public List<Homestay> getAllHomestays() {
        return homestayDao.getAllHomestays();
    }
    public Homestay getHomestayById(int id) {
        return homestayDao.getHomestayById(id);
    }
    public void addHomestay(Homestay h) {
        homestayDao.addHomestay(h);
    }
    public void updateHomestay(Homestay h) {
        homestayDao.updateHomestay(h);
    }
    public boolean deleteHomestay(int id) {
        return homestayDao.deleteHomestay(id);
    }
    public int createHomestay(Homestay h) {
        return homestayDao.createHomestay(h);
    }
    
    public List<Homestay> getHomestaysByServiceName(String serviceName) {
        return homestayDao.getHomestaysByServiceName(serviceName);
    }
    
    public List<Homestay> getHomestaysByServiceNameWithPagination(String serviceName, int page, int size) {
        return homestayDao.getHomestaysByServiceNameWithPagination(serviceName, page, size);
    }
    
    public int getTotalHomestaysByServiceName(String serviceName) {
        return homestayDao.getTotalHomestaysByServiceName(serviceName);
    }
    
    public List<Homestay> getAllHomestaysWithPagination(int page, int size) {
        return homestayDao.getAllHomestaysWithPagination(page, size);
    }
    
    public int getTotalHomestays() {
        return homestayDao.getTotalHomestays();
    }

    public java.util.List<Homestay> getRandomHomestays(int limit) {
        return homestayDao.getRandomHomestays(limit);
    }

    public java.util.List<Homestay> search(String keyword, String roomType, java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice) {
        return homestayDao.search(keyword, roomType, minPrice, maxPrice);
    }
}
