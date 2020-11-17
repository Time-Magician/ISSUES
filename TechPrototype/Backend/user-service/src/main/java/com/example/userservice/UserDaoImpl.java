package com.example.userservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDaoImpl implements UserDao {
    @Autowired
    UserRepository userRepository;

    @Override
    public User getUserById(int userId) {
        User result = userRepository.getOne(userId);
        System.out.println(result.getEmail());
        return result;
    }
}
