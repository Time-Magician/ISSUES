package com.example.userservice.DaoImpl;

import com.example.userservice.Dao.UserAuthDao;
import com.example.userservice.Entity.User;
import com.example.userservice.Entity.UserAuth;
import com.example.userservice.Repository.UserAuthRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Repository;

@Slf4j
@Repository
public class UserAuthDaoImpl implements UserAuthDao {
    @Autowired
    UserAuthRepository userAuthRepository;

    @Autowired
    PasswordEncoder passwordEncoder;

    @Override
    public UserAuth addUserAuth(UserAuth userAuth) {
        userAuthRepository.save(userAuth);
        return userAuth;
    }

    @Override
    public UserAuth findUserByTelOrEmailAndPassword(String credentials, String password) {
        UserAuth userAuth;
        if(credentials.contains("@")){
            userAuth = userAuthRepository.findUserAuthByEmailEquals(credentials);
        }else{
            userAuth = userAuthRepository.findUserAuthByTelEquals(credentials);
        }

        if(userAuth == null||!passwordEncoder.matches(password,userAuth.getPassword())) {
            return null;
        }
        return userAuth;
    }
}
