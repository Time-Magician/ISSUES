package com.example.userservice.Service;
import com.example.userservice.Entity.Message;
import com.example.userservice.Entity.User;
import com.example.userservice.util.msgUtils.Msg;

import java.util.List;

public interface UserService {
    User getUserById(int userId);
    Msg register(String password, String tel,String verificationCode);
    User checkUser(String credentials,String password);
    Msg verify(String tel);
    Msg verifyEmail(String email);
    List<User> getFriendList(int userId);
    String testRedisCache(String tel);
    User deleteFriend(int userId, int friendId);
    User addFriend(int userId, int friendId);
    List<Message> getMessages(int userId);
    Message addMessage(int senderId, int receiverId, String type, String detail);
    User searchUser(String identifier);
    Message checkMessage(String messageId);
}
