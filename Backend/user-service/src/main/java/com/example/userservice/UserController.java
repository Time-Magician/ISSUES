package com.example.userservice;

import com.example.userservice.Entity.User;
import com.example.userservice.Entity.UserAuth;
import com.example.userservice.Service.UserService;
import com.example.userservice.utils.msgUtils.Msg;
import com.example.userservice.utils.msgUtils.MsgCode;
import com.example.userservice.utils.msgUtils.MsgUtil;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Import;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;

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
    public User getUserById(@PathVariable(value = "id") int userId){
        return userService.getUserById(userId);
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
        HashMap<String,String> paramMap = new HashMap<>();
        paramMap.put("username",credentials);
        paramMap.put("password",password);
        paramMap.put("client_id",clientId);
        paramMap.put("client_secret",clientSecret);
        User user = userService.checkUser(credentials,password);
        if(user == null)
            return MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.LOGIN_USER_ERROR_MSG);
//        log.info("hear");
//        String oAuth2AccessToken = restTemplate.postForObject("http://user-auth/oauth/token",null,String.class,paramMap);
//        log.info(oAuth2AccessToken.toString());
        return MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.LOGIN_SUCCESS_MSG, user);
    }
}
