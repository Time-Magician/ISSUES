package com.example.userservice.Dao;

import com.example.userservice.Entity.Message;
import com.example.userservice.Entity.User;
import com.example.userservice.util.msgUtils.Msg;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileNotFoundException;
import java.io.IOException;
import org.bson.types.ObjectId;

import java.util.List;

public interface UserDao {
    User getUserById(int userId);
    User addUser(User user);
    List<User> getAllUsers();
    User checkTelDuplicate(String tel);
    User checkEmailDuplicate(String email);
    User getUserByTel(String tel);
    void modifyUsername(int userId, String username);
    void modifyGender(int userId,String gender);
    void modifyProfilePicture(int userId, MultipartFile profilePicture) throws IOException;
    User getUserByEmail(String email);
    List<User> getFriendList(int userId);
    User deleteFriend(int userId, int friendId);
    User addFriend(int userId, int friendId);
    List<Message> getMessages(int userId);
    Message addMessage(int senderId, int receiverId, String time, String type, String detail);
    Message updateMessage(String messageId);
}
