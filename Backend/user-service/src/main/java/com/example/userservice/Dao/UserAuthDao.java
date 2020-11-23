package com.example.userservice.Dao;

import com.example.userservice.Entity.User;
import com.example.userservice.Entity.UserAuth;

public interface UserAuthDao {
    UserAuth addUserAuth(UserAuth userAuth);
    UserAuth findUserByTelOrEmailAndPassword(String credentials,String password);
}
