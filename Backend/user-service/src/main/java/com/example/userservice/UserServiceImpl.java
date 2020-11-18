package com.example.userservice;

import com.example.userservice.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    UserDao userDao;
    @Override
    public User getUserById(int userId) {
        return userDao.getUserById(userId);
    }
}
