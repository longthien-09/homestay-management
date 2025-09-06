package com.homestay.service;

import com.homestay.dao.CategoryDao;
import com.homestay.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CategoryService {
    @Autowired
    private CategoryDao categoryDao;

    public java.util.List<Category> getAll() { return categoryDao.getAll(); }
}


