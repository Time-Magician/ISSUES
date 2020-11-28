package com.example.userservice.ServiceImpl;

import com.example.userservice.Dao.RedisDao;
import com.example.userservice.Dao.UserAuthDao;
import com.example.userservice.Entity.UserAuth;
import com.example.userservice.Service.UserService;
import com.example.userservice.Entity.User;
import com.example.userservice.Dao.UserDao;
import com.example.userservice.util.msgUtils.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Random;

@Slf4j
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    UserDao userDao;

    @Autowired
    UserAuthDao userAuthDao;

    @Autowired
    RedisDao redisDao;

    @Override
    public User getUserById(int userId) {
        return userDao.getUserById(userId);
    }

    @Override
    public Msg addUser(String name, String username, String password, String tel, String email, String gender) {
        User newUser = new User();
        newUser = userDao.checkEmailDuplicate(email);
        if(newUser != null){
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.EMAIL_DUPLICATE_MSG);
        }
        newUser = userDao.checkTelDuplicate(tel);
        if(newUser != null){
            return MsgUtil.makeMsg(MsgUtil.ERROR,MsgUtil.TEL_DUPLICATE_MSG);
        }

        newUser = User.builder()
                .name(name)
                .username(username)
                .email(email)
                .tel(tel)
                .gender(gender)
                .build();

        UserAuth newUserAuth = UserAuth.builder()
                .userId(newUser.getUserId())
                .email(email)
                .tel(tel)
                .password(password)
                .userType(0)
                .build();

        userDao.addUser(newUser);
        userAuthDao.addUserAuth(newUserAuth);
        return MsgUtil.makeMsg(MsgCode.SUCCESS, MsgUtil.SIGNUP_SUCCESS_MSG);
    }

    @Override
    public User checkUser(String credentials, String password) {
        UserAuth userAuth = userAuthDao.findUserByTelOrEmailAndPassword(credentials,password);
        if(userAuth == null) {
            return null;
        }
        return userDao.getUserById(userAuth.getUserId());
    }

    @Override
    public Msg verify(String tel) {
        User user = userDao.getUserByTel(tel);
        if(user == null){
            String verificationCode = RandomUtil.RandomNumber();
            Boolean flag =  SendSmsUtil.sendSms(tel,verificationCode);
            if(flag){
               redisDao.setRedis(tel,verificationCode);
               return  MsgUtil.makeMsg(MsgCode.SUCCESS, MsgUtil.MSG_SENT_SUCCESS_MSG);
            }
            else{
                return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.VERIFY_TRY_AGAIN_MSG);
            }
        }
        else{
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.TEL_DUPLICATE_MSG);
        }

    }

    @Override
    public String testRedisCache(String tel) {
        return redisDao.getRedis(tel);
    }
}
