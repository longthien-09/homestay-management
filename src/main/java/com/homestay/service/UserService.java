package com.homestay.service;

import com.homestay.dao.UserDao;
import com.homestay.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {
    @Autowired
    private UserDao userDao;

    public boolean register(User user) {
        if (userDao.findByUsername(user.getUsername()) != null) {
            return false; // Username đã tồn tại
        }
        // Nếu role chưa được set, mặc định là USER
        if (user.getRole() == null || user.getRole().isEmpty()) {
            user.setRole("USER");
        }
        user.setActive(true);
        return userDao.register(user) > 0;
    }

    public User login(String username, String password) {
        return userDao.login(username, password);
    }

    public User getUserById(int id) {
        return userDao.findById(id);
    }

    public boolean updateUser(User user) {
        return userDao.updateUser(user) > 0;
    }

    public boolean updatePassword(int id, String password) {
        return userDao.updatePassword(id, password) > 0;
    }

    public boolean setActive(int id, boolean active) {
        return userDao.setActive(id, active) > 0;
    }

    public List<User> getAllUsers() {
        return userDao.findAll();
    }
}
