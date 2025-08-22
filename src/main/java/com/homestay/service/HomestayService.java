package com.homestay.service;

import com.homestay.dao.HomestayDao;
import com.homestay.model.Homestay;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class HomestayService {
    @Autowired
    private HomestayDao homestayDao;

    public int createHomestay(Homestay h) {
        return homestayDao.insert(h);
    }

    public Homestay findByName(String name) {
        return homestayDao.findByName(name);
    }
}
