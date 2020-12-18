package com.example.userservice;

import com.example.userservice.Entity.User;
import com.example.userservice.Service.UserService;
import com.example.userservice.util.msgUtils.Msg;
import com.example.userservice.util.msgUtils.MsgCode;
import com.example.userservice.util.msgUtils.MsgUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.tomcat.jni.Time;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Slf4j
@RestController
public class UserController {
    @Autowired
    UserService userService;

    @Autowired
    PasswordEncoder passwordEncoder;

    @Autowired
    RestTemplate restTemplate;

    @GetMapping("/user/{id}")
    public Msg getUserById(
            HttpServletRequest request,
            @PathVariable(value = "id") int userId){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if(!userType.equals("ADMIN") && requesterUserId != userId){
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.PERMISSION_DENIED);
        }

        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG,userService.getUserById(userId));
    }

    @GetMapping("/user/{id}/friends")
    public Msg getFriendList(
            HttpServletRequest request,
            @PathVariable(value = "id") int userId){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if(!userType.equals("ADMIN") && requesterUserId != userId){
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.PERMISSION_DENIED);
        }

        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG,userService.getFriendList(userId));
    }

    @DeleteMapping("/user/{user_id}/friends/{friend_id}")
    public Msg deleteFriend(
            HttpServletRequest request,
            @PathVariable(name = "friend_id") int friendId,
            @PathVariable(name = "user_id") int userId){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if(!userType.equals("ADMIN") && requesterUserId != userId){
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.PERMISSION_DENIED);
        }

        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG,userService.deleteFriend(userId, friendId));
    }

    @PostMapping("/user/{user_id}/friends/{friend_id}")
    public Msg addFriend(
            @PathVariable(name = "friend_id") int friendId,
            @PathVariable(name = "user_id") int userId){
        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG,userService.addFriend(userId, friendId));
    }

    @GetMapping("/user/{user_id}/messages")
    public Msg getMessages(
            HttpServletRequest request,
            @PathVariable(name = "user_id") int userId){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if(!userType.equals("ADMIN") && requesterUserId != userId){
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.PERMISSION_DENIED);
        }
        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG,userService.getMessages(userId));
    }

    @PostMapping("/user/{user_id}/messages")
    public Msg addMessage(
            HttpServletRequest request,
            @PathVariable(name = "user_id") int receiverId,
            @RequestParam(name = "sender_id") int senderId,
            @RequestParam(name = "type") String type,
            @RequestParam(name = "detail") String detail){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if(!userType.equals("ADMIN") && requesterUserId != senderId){
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.PERMISSION_DENIED);
        }
        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG,userService.addMessage(senderId, receiverId, type, detail));
    }

    @PutMapping("/user/{user_id}/messages/{message_id}")
    public Msg checkMessage(
            HttpServletRequest request,
            @PathVariable(name = "user_id") int userId,
            @PathVariable(name = "message_id") String messageId){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if(!userType.equals("ADMIN") && requesterUserId != userId){
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.PERMISSION_DENIED);
        }
        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG,userService.checkMessage(messageId));
    }

    @PostMapping("/user")
    public Msg searchUser(
            HttpServletRequest request,
            @RequestParam(name = "sender_id") int senderId,
            @RequestParam(name = "identifier") String identifier){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if(!userType.equals("ADMIN") && requesterUserId != senderId){
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.PERMISSION_DENIED);
        }
        User receiver = userService.searchUser(identifier);
        User sender = userService.getUserById(senderId);
        if(receiver == null) return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.ERROR_MSG);
        else{
            return addMessage(request, receiver.getUserId(), senderId, "好友申请", "用户 "+sender.getName()+" 希望添加您为好友。");
        }
    }

    @PostMapping("/verify/tel")
    public Msg verify(
            @RequestParam(name = "tel") String tel
    ){
        return userService.verify(tel);
    }

    @PostMapping("/verify/email")
    public Msg verifyEmail(
            @RequestParam(name = "email")String email
    ) {
        return userService.verifyEmail(email);
    }

    @PostMapping("/register")
    public Msg register(
            HttpServletRequest request,
            @RequestParam(name = "tel")String tel,
            @RequestParam(name = "password")String password,
            @RequestParam(name = "verifyCode") String verificationCode
    ){
        return userService.register(passwordEncoder.encode(password),tel,verificationCode);
    }

    @GetMapping("/login")
    public Msg login(
            @RequestParam(name = "credentials")String credentials,
            @RequestParam(name = "password")String password,
            @RequestParam(name = "client_id")String clientId,
            @RequestParam(name = "client_secret")String clientSecret
    ){
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("username",credentials);
        paramsMap.add("password",password);
        paramsMap.add("client_id",clientId);
        paramsMap.add("client_secret",clientSecret);
        paramsMap.add("grant_type","password");
        User user = userService.checkUser(credentials,password);
        if(user == null)
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.LOGIN_USER_ERROR_MSG);

        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity(paramsMap, headers);
        Object oAuth2AccessToken = restTemplate.postForObject("http://localhost:8080/oauth/token",request,Object.class);
        Msg result = MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.LOGIN_SUCCESS_MSG, user);
        result.setExtraInfo(oAuth2AccessToken);
        return result;
    }
}
