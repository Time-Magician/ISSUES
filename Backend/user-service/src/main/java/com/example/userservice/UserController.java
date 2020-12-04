package com.example.userservice;

import com.example.userservice.Entity.User;
import com.example.userservice.Service.UserService;
import com.example.userservice.util.msgUtils.Msg;
import com.example.userservice.util.msgUtils.MsgCode;
import com.example.userservice.util.msgUtils.MsgUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Arrays;

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
        if(userType != "ADMIN" && requesterUserId != userId){
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.PERMISSION_DENIED);
        }

        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG,userService.getUserById(userId));
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


    @PatchMapping("/user/{userId}/username")
    public Msg modifyUsername(
            HttpServletRequest request,
            @PathVariable(value = "userId")int userId,
            @RequestParam(name = "username") String newUsername
    ){
        userId = Integer.parseInt(request.getHeader("userId"));
        return userService.modifyUsername(userId,newUsername);
    }

    @PatchMapping("/user/{userId}/gender")
    public Msg modifyGender(
            HttpServletRequest request,
            @PathVariable(value = "userId")int userId,
            @RequestParam(name = "gender") String newGender
    ){
        userId = Integer.parseInt(request.getHeader("userId"));
        return userService.modifyGender(userId,newGender);
    }

    @PatchMapping("/user/{userId}/profilePicture")
    public Msg modifyProfilePicture(
            HttpServletRequest request,
            @PathVariable(value = "userId")int userId,
            @RequestParam(name = "profilePicture")MultipartFile newProfilePicture
    ) throws IOException {
        userId = Integer.parseInt(request.getHeader("userId"));
        return userService.modifyProfilePicture(userId,newProfilePicture);
    }

    @PatchMapping("user/{userId}/password")
    public Msg modifyPassword(
            HttpServletRequest request,
            @PathVariable(value = "userId")int userId,
            @RequestParam(name = "oldPassword") String oldPwd,
            @RequestParam(name = "newPassword") String newPwd
    ){
        userId = Integer.parseInt(request.getHeader("userId"));
        if(!userService.checkUserByIdAndPassword(userId,oldPwd))
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.PASSWORD_ERROR);
        return userService.modifyPassword(userId,passwordEncoder.encode(newPwd));

    }
}
