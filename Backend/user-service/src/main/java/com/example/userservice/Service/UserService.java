package com.example.userservice.Service;
import com.example.userservice.Entity.User;
import com.example.userservice.util.msgUtils.Msg;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface UserService {
    User getUserById(int userId);
    Msg register(String password, String tel,String verificationCode);
    User checkUser(String credentials,String password);
    boolean checkUserByIdAndPassword(int userId,String password);
    Msg verify(String tel);
    Msg verifyEmail(String email);
    Msg modifyUsername(int userId,String username);
    Msg modifyGender(int userId,String gender);
    Msg modifyProfilePicture(int userId, MultipartFile profilePicture) throws IOException;
    Msg modifyPassword(int userId,String password);
}
