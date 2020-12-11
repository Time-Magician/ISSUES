package com.example.userservice.DaoImpl;

import com.example.userservice.Dao.UserDao;
import com.example.userservice.Entity.User;
import com.example.userservice.Entity.UserAuth;
import com.example.userservice.Repository.UserAuthRepository;
import com.example.userservice.Repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

@Repository
@Slf4j
public class UserDaoImpl implements UserDao {
    @Autowired
    UserRepository userRepository;
    @Autowired
    UserAuthRepository userAuthRepository;

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

    @Override
    public void modifyUsername(int userId, String username) {
        User user = userRepository.findById(userId).get();
        user.setUsername(username);
        userRepository.save(user);
    }

    @Override
    public void modifyGender(int userId, String gender) {
        User user = userRepository.findById(userId).get();
        user.setUsername(gender);
        userRepository.save(user);
    }

    @Override
    public void modifyProfilePicture(int userId, MultipartFile profilePicture) throws IOException {
        User user = userRepository.findById(userId).get();
        Base64.Encoder pictureEncoder  = Base64.getEncoder();
        user.setProfilePicture(pictureEncoder.encodeToString(profilePicture.getBytes()));
        userRepository.save(user);
    }

    @Override
    public List<User> getAllUsers() {
        List<UserAuth> users = userAuthRepository.getUserAuthByUserTypeEquals(0);
        List<Integer> userIdSet = new ArrayList<>();
        for(UserAuth user:users){
            userIdSet.add(user.getUserId());
        }
        log.info(userIdSet.toString());
        return userRepository.getUserByUserIdIsNotIn(userIdSet);
    }
}
