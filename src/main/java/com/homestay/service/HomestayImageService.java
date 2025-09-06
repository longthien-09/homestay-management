package com.homestay.service;

import com.homestay.dao.HomestayImageDao;
import com.homestay.model.HomestayImage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HomestayImageService {
    @Autowired
    private HomestayImageDao homestayImageDao;

    public List<HomestayImage> getImagesByHomestayId(int homestayId) {
        return homestayImageDao.getImagesByHomestayId(homestayId);
    }

    public boolean addImage(int homestayId, String filePath, Integer sortOrder) {
        return homestayImageDao.addImage(homestayId, filePath, sortOrder);
    }
}


