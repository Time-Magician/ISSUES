package com.example.userservice.Dao;

import com.example.userservice.Entity.User;

public interface UserDao {
    User getUserById(int userId);
    User addUser(User user);
    User checkTelDuplicate(String tel);
    User checkEmailDuplicate(String email);
}
