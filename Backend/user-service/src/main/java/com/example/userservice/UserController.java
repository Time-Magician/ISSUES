package com.example.userservice;

import com.example.userservice.Entity.User;
import com.example.userservice.Service.UserService;
import com.example.userservice.util.msgUtils.Msg;
import com.example.userservice.util.msgUtils.MsgCode;
import com.example.userservice.util.msgUtils.MsgUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import javax.servlet.http.HttpServletRequest;
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

    @GetMapping("/getUser/{id}")
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

    @PostMapping("/verify")
    public Msg verify(
            @RequestParam(name = "tel") String tel
    ){
        return userService.verify(tel);
    }

    @PostMapping("/verify/email")
    public Msg verifyEmail(
            @RequestParam(name = "email")String email
    ){
        return userService.verifyEmail(email);
    @PostMapping("/testRedisCache")
    public String testRedisCache(
            @RequestParam(name = "tel") String tel
    ){
        return userService.testRedisCache(tel);
    }
    @PostMapping("/register")
    public Msg register(
            HttpServletRequest request,
            @RequestParam(name = "name")String name,
            @RequestParam(name = "username")String username,
            @RequestParam(name = "password")String password,
            @RequestParam(name = "tel")String tel,
            @RequestParam(name = "email")String email,
            @RequestParam(name = "gender")String gender
    ){
        return userService.addUser(name,username,passwordEncoder.encode(password),tel,email,gender);
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
