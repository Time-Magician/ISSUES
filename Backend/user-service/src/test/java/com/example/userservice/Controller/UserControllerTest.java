package com.example.userservice.Controller;

import com.alibaba.fastjson.JSONObject;
import com.example.UserServiceApplication;
import com.example.userservice.Entity.Message;
import com.example.userservice.Entity.User;
import com.example.userservice.Entity.UserAuth;
import com.example.userservice.Service.UserService;
import com.example.userservice.util.msgUtils.MsgCode;
import com.example.userservice.util.msgUtils.MsgUtil;
import lombok.extern.slf4j.Slf4j;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.WebApplicationContext;

import javax.transaction.Transactional;
import java.util.Map;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = {UserServiceApplication.class},webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserControllerTest {
    private MockMvc mockMvc;

    @Autowired
    private WebApplicationContext context;

    @Autowired
    @InjectMocks
    UserController userController;

    @Autowired
    PasswordEncoder passwordEncoder;

    @Mock
    UserService userService;

    @Mock
    RestTemplate restTemplate;

    @Test
    public void contextLoads(){
    }

    @Before
    public void setup(){
        MockitoAnnotations.initMocks(this);
        //mock login
        Mockito.when(userService.checkUser("12345678900","123")).thenReturn(MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.LOGIN_USER_ERROR_MSG));
        Mockito.when(userService.checkUser("12345678901","123")).thenReturn(MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.FORBIDDEN_MSG));
        Mockito.when(userService.checkUser("12345678902", "123")).thenReturn(MsgUtil.makeMsg(MsgCode.SUCCESS, MsgUtil.SUCCESS_MSG,UserAuth.builder().userId(1).build()));
        Mockito.when(userService.getUserById(1)).thenReturn(User.builder().userId(1).build());

        Mockito.when(userService.register(passwordEncoder.encode("TestPassword"),"TestTel","Test")).thenReturn(MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SIGNUP_SUCCESS_MSG));
        Mockito.when(userService.register(passwordEncoder.encode("TestPassword"),"TestTel","ErrorTest")).thenReturn(MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.VERIFY_ERROR_MSG));

        Mockito.when(userService.verify("12345678900")).thenReturn(MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.TEL_DUPLICATE_MSG));
        Mockito.when(userService.verify("TestTel")).thenReturn(MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.VERIFY_TRY_AGAIN_MSG));
        Mockito.when(userService.verify("12345678901")).thenReturn(MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.MSG_SENT_SUCCESS_MSG));

        Mockito.when(userService.verifyEmail("test@sjtu.edu.cn")).thenReturn(MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG));
        Mockito.when(userService.verifyEmail("TestEmail")).thenReturn(MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.VERIFY_TRY_AGAIN_MSG));

        Mockito.when(userService.deleteFriend(1,2)).thenReturn(new User());
        Mockito.when(userService.addFriend(1,3)).thenReturn(new User());

        Mockito.when(userService.addMessage(2,1,"TestType","TestDetail")).thenReturn(new Message());
        Mockito.when(userService.checkMessage("TestId")).thenReturn(new Message());

        Mockito.when(userService.checkUserByIdAndPassword(1,"123")).thenReturn(true);
        Mockito.when(userService.checkUserByIdAndPassword(1,"1234")).thenReturn(false);

        Mockito.when(userService.modifyPassword(1,"234")).thenReturn(MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG));

        Mockito.when(restTemplate.postForObject(Mockito.anyString(),Mockito.any(),Mockito.any())).thenReturn("Test");
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }


    @Transactional
    @Test
    public void setUserEnableTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
            MockMvcRequestBuilders.put("http://localhost/admin/user/1")
                    .param("enable", "TRUE")
                    .header("userType","ADMIN")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);

        response = mockMvc.perform(
            MockMvcRequestBuilders.put("http://localhost/admin/user/1")
                    .param("enable", "FALSE")
                    .header("userType","ADMIN")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);

        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/admin/user/1")
                        .param("enable", "FALSE")
                        .header("userType","USER")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void getFriendListTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/1/friends")
                        .header("userId","1")
                        .header("userType","USER")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);

        response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/1/friends")
                        .header("userId","2")
                        .header("userType","USER")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void loginTest() throws Exception{

        Map<String, Object> responseMap;
        MockHttpServletResponse response = mockMvc.perform
                (
                        MockMvcRequestBuilders.get("http://localhost/login")
                                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                                .param("credentials","12345678900")
                                .param("password","123")
                                .param("client_id","issuesApp")
                                .param("client_secret","sjtu")
                )
                .andReturn().getResponse();
        responseMap =  JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.ERROR);
        Assert.assertEquals(responseMap.get("msg").toString(),MsgUtil.LOGIN_USER_ERROR_MSG);

        response = mockMvc.perform
                (
                        MockMvcRequestBuilders.get("http://localhost/login")
                                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                                .param("credentials","12345678901")
                                .param("password","123")
                                .param("client_id","issuesApp")
                                .param("client_secret","sjtu")
                )
                .andReturn().getResponse();
        responseMap =  JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.ERROR);
        Assert.assertEquals(responseMap.get("msg").toString(),MsgUtil.FORBIDDEN_MSG);

        response = mockMvc.perform
                (
                        MockMvcRequestBuilders.get("http://localhost/login")
                                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                                .param("credentials","12345678902")
                                .param("password","123")
                                .param("client_id","issuesApp")
                                .param("client_secret","sjtu")
                )
                .andReturn().getResponse();
        responseMap =  JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.SUCCESS);
        Assert.assertEquals(responseMap.get("msg").toString(),MsgUtil.LOGIN_SUCCESS_MSG);
        Assert.assertEquals(JSONObject.parseObject(responseMap.get("data").toString()).get("userId"),1);
        log.info(responseMap.toString());
    }


    //to do: bcrypt每次加密都会产生不同的结果，这导致mock没有成功
    @Transactional
    @Test
    public void registerTest() throws Exception {

        Map<String, Object> responseMap;
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("tel","TestTel");
        paramsMap.add("password","TestPassword");
        paramsMap.add("verifyCode","Test");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/register")
                        .params(paramsMap)
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);


        paramsMap.set("verifyCode","ErrorTest");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/register")
                        .params(paramsMap)
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);

    }


    @Transactional
    @Test
    public void verifyTest() throws Exception {

        Map<String, Object> responseMap;

        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/verify/tel")
                        .param("tel","12345678900")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.ERROR);;
        Assert.assertEquals(responseMap.get("msg"),MsgUtil.TEL_DUPLICATE_MSG);


        response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/verify/tel")
                        .param("tel","TestTel")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.ERROR);;
        Assert.assertEquals(responseMap.get("msg"),MsgUtil.VERIFY_TRY_AGAIN_MSG);


        response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/verify/tel")
                        .param("tel","12345678901")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.SUCCESS);;
        Assert.assertEquals(responseMap.get("msg"),MsgUtil.MSG_SENT_SUCCESS_MSG);

    }

    @Transactional
    @Test
    public void verifyEmailTest() throws Exception {
        Map<String, Object> responseMap;

        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/verify/email")
                        .param("email","TestEmail")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.ERROR);;
        Assert.assertEquals(responseMap.get("msg"),MsgUtil.VERIFY_TRY_AGAIN_MSG);


        response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/verify/email")
                        .param("email","test@sjtu.edu.cn")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.SUCCESS);;
        Assert.assertEquals(responseMap.get("msg"),MsgUtil.SUCCESS_MSG);
    }


    @Transactional
    @Test
    public void deleteFriendTest() throws Exception {
        Map<String, Object> responseMap;

        MockHttpServletResponse response = mockMvc.perform(
                //pathVariable中请求的用户id与token附加header的userId不一致
                MockMvcRequestBuilders.delete(  "http://localhost/user/2/friends/2")
                        .header("userId","1")
                        .header("userType","USER")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.ERROR);
        Assert.assertEquals(responseMap.get("msg"), MsgUtil.PERMISSION_DENIED);


        response = mockMvc.perform(
                //pathVariable中请求的用户id与token附加header的userId不一致
                MockMvcRequestBuilders.delete(  "http://localhost/user/1/friends/2")
                        .header("userId","1")
                        .header("userType","USER")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.SUCCESS);
        Assert.assertEquals(responseMap.get("msg"), MsgUtil.SUCCESS_MSG);
    }

    @Transactional
    @Test
    public void addFriendTest() throws Exception {
        Map<String, Object> responseMap;

        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post(  "http://localhost/user/1/friends/3")
                        .header("userId","2")
                        .header("userType","USER")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.ERROR);
        Assert.assertEquals(responseMap.get("msg"), MsgUtil.PERMISSION_DENIED);

        response = mockMvc.perform(
                //pathVariable中请求的用户id与token附加header的userId不一致
                MockMvcRequestBuilders.post(  "http://localhost/user/1/friends/3")
                        .header("userId","1")
                        .header("userType","USER")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.SUCCESS);
        Assert.assertEquals(responseMap.get("msg"), MsgUtil.SUCCESS_MSG);
    }

    @Transactional
    @Test
    public void getMessagesTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.get(  "http://localhost/user/1/messages")
                        .header("userId","1")
                        .header("userType","USER")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);


        response = mockMvc.perform(
                MockMvcRequestBuilders.get(  "http://localhost/user/1/messages")
                        .header("userId","2")
                        .header("userType","USER")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void addMessageTest() throws Exception {
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        Map<String, Object> responseMap;

        paramsMap.add("sender_id","2");
        paramsMap.add("type","TestType");
        paramsMap.add("detail","TestDetail");
        MockHttpServletResponse response = mockMvc.perform(
                //sender_id与header中的userId不一致
                MockMvcRequestBuilders.post( "http://localhost/user/1/messages")
                        .header("userId","1")
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.ERROR);
        Assert.assertEquals(responseMap.get("msg"), MsgUtil.PERMISSION_DENIED);


        paramsMap.set("sender_id","1");
        response = mockMvc.perform(
                //sender_id与header中的userId不一致
                MockMvcRequestBuilders.post( "http://localhost/user/1/messages")
                        .header("userId","1")
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.SUCCESS);
        Assert.assertEquals(responseMap.get("msg"), MsgUtil.SUCCESS_MSG);
    }

    @Transactional
    @Test
    public void checkMessageTest() throws Exception {
        Map<String, Object> responseMap;

        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.put( "http://localhost/user/1/messages/testId")
                        //pathvariable中的user_id与header中的userId不一致
                        .header("userId","2")
                        .header("userType","USER")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.ERROR);
        Assert.assertEquals(responseMap.get("msg"), MsgUtil.PERMISSION_DENIED);


        response = mockMvc.perform(
                MockMvcRequestBuilders.put( "http://localhost/user/1/messages/testId")
                        .header("userId","1")
                        .header("userType","USER")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(), 200);
        Assert.assertEquals(responseMap.get("status"),MsgUtil.SUCCESS);
        Assert.assertEquals(responseMap.get("msg"), MsgUtil.SUCCESS_MSG);
    }

    @Transactional
    @Test
    public void modifyUsernameTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.patch( "http://localhost/user/1/username")
                        .header("userId","1")
                        .header("userType","USER")
                        .param("username","Test")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void modifyGenderTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.patch( "http://localhost/user/1/gender")
                        .header("userId","1")
                        .header("userType","USER")
                        .param("gender","Test")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }


    @Transactional
    @Test
    public void modifyPasswordTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.patch( "http://localhost/user/1/password")
                        .header("userId","1")
                        .header("userType","USER")
                        .param("oldPassword","1234")
                        .param("newPassword","2345")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);

        response = mockMvc.perform(
                MockMvcRequestBuilders.patch( "http://localhost/user/1/password")
                        .header("userId","1")
                        .header("userType","USER")
                        .param("oldPassword","123")
                        .param("newPassword","234")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }
}
