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
}
