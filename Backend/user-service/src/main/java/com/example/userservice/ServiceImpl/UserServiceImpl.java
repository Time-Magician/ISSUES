package com.example.userservice.ServiceImpl;

import com.example.userservice.Dao.RedisDao;
import com.example.userservice.Dao.UserAuthDao;
import com.example.userservice.Entity.UserAuth;
import com.example.userservice.Service.UserService;
import com.example.userservice.Entity.User;
import com.example.userservice.Dao.UserDao;
import com.example.userservice.util.emailUtil.MailUtil;
import com.example.userservice.util.msgUtils.Msg;
import com.example.userservice.util.msgUtils.MsgCode;
import com.example.userservice.util.msgUtils.MsgUtil;
import com.example.userservice.util.msgUtils.SendSmsUtil;
import com.example.userservice.util.msgUtils.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
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
    public Msg register(String password, String tel,String verificationCode) {
        String targetVerificationCode = redisDao.getRedis(tel);
        System.out.println(targetVerificationCode);
        System.out.println(verificationCode);
        if(!targetVerificationCode.equals(verificationCode)){
            return  MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.VERIFY_ERROR_MSG);
        }

        User newUser = new User();

        newUser = User.builder()
                .name("anonymous")
                .username(MailUtil.getRandomString(9))
                .email(null)
                .tel(tel)
                .gender(null)
                .build();

        UserAuth newUserAuth = UserAuth.builder()
                .userId(newUser.getUserId())
                .email(null)
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
    public Msg verifyEmail(String email) {
        String title = "[一心ISSUES]邮箱验证";
        String verificationCode = MailUtil.getRandomString(6);
        String text = "验证码:" + verificationCode+"\n有效期：5min";
        if(MailUtil.sendMail(email, text, title)){
            redisDao.setRedis(email,verificationCode);
            return MsgUtil.makeMsg(MsgUtil.SUCCESS, MsgUtil.SUCCESS_MSG);
        }
        return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.VERIFY_TRY_AGAIN_MSG);
    }

    @Override
    public Msg modifyUsername(int userId, String username) {
        userDao.modifyUsername(userId,username);
        return MsgUtil.makeMsg(MsgUtil.SUCCESS,MsgUtil.SUCCESS_MSG);
    }

    @Override
    public Msg modifyGender(int userId, String gender) {
        userDao.modifyGender(userId,gender);
        return MsgUtil.makeMsg(MsgUtil.SUCCESS,MsgUtil.SUCCESS_MSG);

    }

    @Override
    public Msg modifyProfilePicture(int userId, MultipartFile profilePicture) throws IOException {
        try {
            userDao.modifyProfilePicture(userId, profilePicture);
        }catch (IOException e){
            return MsgUtil.makeMsg(MsgUtil.ERROR,MsgUtil.ERROR_MSG);
        }
        return MsgUtil.makeMsg(MsgUtil.SUCCESS,MsgUtil.SUCCESS_MSG);
    }

    @Override
    public boolean checkUserByIdAndPassword(int userId, String password) {
        return userAuthDao.checkUserByIdAndPassword(userId, password);
    }

    @Override
    public Msg modifyPassword(int userId, String password) {
        userAuthDao.modifyPassword(userId,password);
        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG);
    }
}
