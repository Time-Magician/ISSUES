package com.example.userservice.DaoImpl;

import com.example.userservice.Dao.UserDao;
import com.example.userservice.Entity.User;
import com.example.userservice.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDaoImpl implements UserDao {
    @Autowired
    UserRepository userRepository;

    @Override
    public User getUserById(int userId) {
        User result = userRepository.getOne(userId);
        return result;
    }

    @Override
    public User addUser(User user) {
        userRepository.save(user);
        return user;
    }

    @Override
    public User checkTelDuplicate(String tel) {
        return userRepository.getUserByTelEquals(tel);
    }

    @Override
    public User checkEmailDuplicate(String email) {
        return userRepository.getUserByEmailEquals(email);
    }

    @Override
    public User getUserByTel(String tel) {
        User newUser = userRepository.getUserByTelEquals(tel);
        return newUser;
    }
}
