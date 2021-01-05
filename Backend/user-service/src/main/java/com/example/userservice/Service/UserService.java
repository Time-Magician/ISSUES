package com.example.userservice.Service;
import com.example.userservice.Entity.Message;
import com.example.userservice.Entity.User;
import com.example.userservice.util.msgUtils.Msg;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

import java.util.List;

public interface UserService {
    User getUserById(int userId);
    List<User> getAllUsers();
    Msg register(String password, String tel,String verificationCode);
    Msg checkUser(String credentials,String password);
    boolean checkUserByIdAndPassword(int userId,String password);
    Msg verify(String tel);
    Msg verifyEmail(String email);
    Msg modifyUsername(int userId,String username);
    Msg modifyGender(int userId,String gender);
    Msg modifyName(int userId,String name);
    Msg modifyEmail(int userId,String email, String verificationCode);
    Msg modifyProfilePicture(int userId, MultipartFile profilePicture) throws IOException;
    Msg modifyPassword(int userId,String password);
    Msg enableUser(int userId);
    Msg disableUser(int userId);
    List<User> getFriendList(int userId);
    String testRedisCache(String tel);
    User deleteFriend(int userId, int friendId);
    User addFriend(int userId, int friendId);
    List<Message> getMessages(int userId);
    Message addMessage(int senderId, int receiverId, String type, String detail);
    User searchUser(String identifier);
    Message checkMessage(String messageId);
}
