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
}
