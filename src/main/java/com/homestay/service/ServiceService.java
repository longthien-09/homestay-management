package com.homestay.service;

import com.homestay.dao.ServiceDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ServiceService {
    @Autowired
    private ServiceDao serviceDao;

    public java.util.List<com.homestay.model.Service> getServicesByHomestayId(int homestayId) {
        return serviceDao.getServicesByHomestayId(homestayId);
    }

    public java.util.List<com.homestay.model.Service> getServicesByBookingId(int bookingId) {
        return serviceDao.getServicesByBookingId(bookingId);
    }

    public boolean addService(com.homestay.model.Service service) {
        return serviceDao.addService(service);
    }

    public com.homestay.model.Service getServiceById(int id) {
        return serviceDao.getServiceById(id);
    }
    public boolean updateService(com.homestay.model.Service service) {
        return serviceDao.updateService(service);
    }
    public boolean deleteService(int id) {
        return serviceDao.deleteService(id);
    }

    public java.util.List<com.homestay.model.Service> getAllServices() {
        return serviceDao.getAllServices();
    }

    public java.util.List<com.homestay.model.Service> getDistinctServices() {
        return serviceDao.getDistinctServices();
    }

    public java.util.Map<Integer, java.util.List<com.homestay.model.Service>> groupServicesByCategory() {
        java.util.List<com.homestay.model.Service> all = getAllServices();
        java.util.Map<Integer, java.util.List<com.homestay.model.Service>> map = new java.util.HashMap<>();
        if (all != null) {
            for (com.homestay.model.Service s : all) {
                Integer catId = s.getCategoryId();
                if (catId == null) catId = -1; // nhóm "Khác"
                map.computeIfAbsent(catId, k -> new java.util.ArrayList<>()).add(s);
            }
        }
        return map;
    }
}
