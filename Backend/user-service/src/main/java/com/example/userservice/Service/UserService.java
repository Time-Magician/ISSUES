package com.example.userservice.Service;
import com.example.userservice.Entity.User;
import com.example.userservice.util.msgUtils.Msg;

public interface UserService {
    User getUserById(int userId);
    Msg register(String password, String tel,String verificationCode);
    User checkUser(String credentials,String password);
    Msg verify(String tel);
    Msg verifyEmail(String email);

    String testRedisCache(String tel);
}
