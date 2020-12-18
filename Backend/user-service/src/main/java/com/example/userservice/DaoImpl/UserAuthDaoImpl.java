package com.example.userservice.DaoImpl;

import com.example.userservice.Dao.UserAuthDao;
import com.example.userservice.Entity.User;
import com.example.userservice.Entity.UserAuth;
import com.example.userservice.Repository.UserAuthRepository;
import com.example.userservice.util.msgUtils.Msg;
import com.example.userservice.util.msgUtils.MsgCode;
import com.example.userservice.util.msgUtils.MsgUtil;
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

    @Override
    public boolean checkUserByIdAndPassword(int userId, String password) {
        UserAuth userAuth = userAuthRepository.findById(userId).get();
        if(!passwordEncoder.matches(password,userAuth.getPassword())) {
            return false;
        }
        return true;
    }

    @Override
    public void modifyPassword(int userId, String password) {
        UserAuth userAuth = userAuthRepository.findById(userId).get();
        userAuth.setPassword(password);
        userAuthRepository.save(userAuth);
    }

    @Override
    public Msg disableUser(int userId) {
        UserAuth userAuth = userAuthRepository.findById(userId).get();
        if(userAuth == null)
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.USER_NOT_FOUND);
        userAuth.setUserType(2);
        userAuthRepository.save(userAuth);
        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG);
    }

    @Override
    public Msg enableUser(int userId) {
        UserAuth userAuth = userAuthRepository.findById(userId).get();
        if(userAuth == null)
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.USER_NOT_FOUND);
        userAuth.setUserType(1);
        userAuthRepository.save(userAuth);
        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG);
    }
}
