package com.example.userservice.Service;
import com.example.userservice.Entity.User;
import com.example.userservice.util.msgUtils.Msg;

public interface UserService {
    User getUserById(int userId);
    Msg addUser(String name, String username, String password, String tel, String email, String gender);
    User checkUser(String credentials,String password);
    Msg verify(String tel);

    String testRedisCache(String tel);
}
