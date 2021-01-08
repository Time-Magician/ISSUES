package com.example.userservice.ServiceImpl;

import com.example.userservice.Dao.RedisDao;
import com.example.userservice.Dao.UserAuthDao;
import com.example.userservice.Entity.Friends;
import com.example.userservice.Entity.Message;
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
import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
    public User getUserByTel(String tel) {
        return userDao.getUserByTel(tel);
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
                .name("")
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
                .userType(1)
                .build();

        userDao.addUser(newUser);
        userAuthDao.addUserAuth(newUserAuth);
        return MsgUtil.makeMsg(MsgCode.SUCCESS, MsgUtil.SIGNUP_SUCCESS_MSG);
    }

    @Override
    public Msg checkUser(String credentials, String password) {
        UserAuth userAuth = userAuthDao.findUserByTelOrEmailAndPassword(credentials,password);
        if(userAuth == null) {
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.LOGIN_USER_ERROR_MSG);
        }
        if(userAuth.getUserType() == 2)
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.FORBIDDEN_MSG);
        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG,userAuth);
    }

    @Override
    public Msg verify(String tel) {
        User user = userDao.getUserByTel(tel);
        if(user == null){
            return getMsg(tel, false);
        }
        else{
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.TEL_DUPLICATE_MSG);
        }

    }

    @Override
    public Msg verifyLogin(String tel){
        return getMsg(tel, true);
    }

    private Msg getMsg(String tel, boolean isLogin) {
        String vCode = RandomUtil.RandomNumber();
        Boolean flag =  SendSmsUtil.sendSms(tel,vCode,isLogin);
        if(flag){
            redisDao.setRedis(tel,vCode);
            return  MsgUtil.makeMsg(MsgCode.SUCCESS, MsgUtil.MSG_SENT_SUCCESS_MSG);
        }
        else{
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.VERIFY_TRY_AGAIN_MSG);
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
    public Msg modifyName(int userId, String name){
        userDao.modifyName(userId, name);
        return MsgUtil.makeMsg(MsgUtil.SUCCESS,MsgUtil.SUCCESS_MSG);
    }

    @Override
    public Msg modifyEmail(int userId, String email, String verificationCode){
        String targetVerificationCode = redisDao.getRedis(email);
        System.out.println(targetVerificationCode);
        System.out.println(verificationCode);
        if(!targetVerificationCode.equals(verificationCode)){
            return  MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.VERIFY_ERROR_MSG);
        }
        userDao.modifyEmail(userId, email);
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

    @Override
    public List<User> getAllUsers() {
        return userDao.getAllUsers();
    }


    @Override
    public Msg enableUser(int userId) {
        return userAuthDao.enableUser(userId);
    }

    @Override
    public Msg disableUser(int userId) {
        return userAuthDao.disableUser(userId);
    }
    
    @Override
    public List<User> getFriendList(int userId){
        return userDao.getFriendList(userId);
    }

    @Override
    public User deleteFriend(int userId, int friendId){
        User user = userDao.getUserById(friendId);
        userDao.deleteFriend(userId, friendId);
        userDao.deleteFriend(friendId, userId);
        return user;
    }

    @Override
    public User addFriend(int userId, int friendId) {
        User user = userDao.getUserById(friendId);
        userDao.addFriend(userId, friendId);
        userDao.addFriend(friendId, userId);
        return user;
    }

    @Override
    public List<Message> getMessages(int userId){
        return userDao.getMessages(userId);
    }

    @Override
    public Message addMessage(int senderId, int receiverId, String type, String detail){
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String time = sdf.format(date);
        return userDao.addMessage(senderId, receiverId, time, type, detail);
    }

    @Override
    public Message checkMessage(String messageId){
        return userDao.updateMessage(messageId);
    }

    @Override
    public String getRedisCache(String credential) {
        String targetVerificationCode = redisDao.getRedis(credential);
        return targetVerificationCode;
    }

    @Override
    public User searchUser(String identifier){
        User user = userDao.getUserByTel(identifier);
        if(user == null){
            user = userDao.getUserByEmail(identifier);
        }
        return user;
    }

    public String testRedisCache(String tel) {
        return redisDao.getRedis(tel);
    }
}
