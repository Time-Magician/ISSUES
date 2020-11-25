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
import org.springframework.http.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
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
