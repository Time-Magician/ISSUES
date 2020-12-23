package com.example.userservice.Controller;

import com.example.UserServiceApplication;
import com.example.userservice.Entity.Message;
import com.example.userservice.Entity.User;
import com.example.userservice.Service.UserService;
import com.example.userservice.UserController;
import com.example.userservice.util.msgUtils.MsgCode;
import com.example.userservice.util.msgUtils.MsgUtil;
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
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;

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
        Mockito.when(userService.checkUser("18818223608","123")).thenReturn(MsgUtil.makeMsg(MsgCode.ERROR,MsgUtil.ERROR_MSG));
        Mockito.when(userService.deleteFriend(1,2)).thenReturn(new User());
        Mockito.when(userService.addFriend(1,3)).thenReturn(new User());
        Mockito.when(userService.addMessage(2,1,"TestType","TestDetail")).thenReturn(new Message());
        Mockito.when(userService.checkMessage("TestId")).thenReturn(new Message());
        Mockito.when(userService.verify("TestTel")).thenReturn(MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG));
        Mockito.when(userService.verifyEmail("TestEmail")).thenReturn(MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG));
        Mockito.when(userService.register(passwordEncoder.encode("TestPassword"),"TestTel","Test")).thenReturn(MsgUtil.makeMsg(MsgCode.SUCCESS,MsgUtil.SUCCESS_MSG));
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
    }

    @Transactional
    @Test
    public void getAllUsersTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/admin/users")
                        .header("userType","ADMIN")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void getUserByIdTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/1")
                        .header("userType","ADMIN")
                        .header("userId","2")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);

        response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/1")
                        .header("userType","USER")
                        .header("userId","1")
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
    }

    @Transactional
    @Test
    public void deleteFriendTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.delete(  "http://localhost/user/1/friends/2")
                        .header("userId","1")
                        .header("userType","USER")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void addFriendTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post(  "http://localhost/user/1/friends/3")
                        .header("userId","1")
                        .header("userType","USER")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
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
    }

    @Transactional
    @Test
    public void addMessageTest() throws Exception {
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("sender_id","2");
        paramsMap.add("type","TestType");
        paramsMap.add("detail","TestDetail");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/user/1/messages")
                        .header("userId","1")
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void checkMessageTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.put( "http://localhost/user/1/messages/testId")
                        .header("userId","1")
                        .header("userType","USER")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }


    @Transactional
    @Test
    public void searchUserTest() throws Exception {
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("sender_id","1");
        paramsMap.add("identifier","TestType");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/user")
                        .header("userId","1")
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void verifyTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/verify/tel")
                    .param("tel","TestTel")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void verifyEmailTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/verify/email")
                    .param("email","TestEmail")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void registerTest() throws Exception {
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("tel","TestTel");
        paramsMap.add("password","TestPassword");
        paramsMap.add("verifyCode","Test");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post( "http://localhost/register")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }

    @Transactional
    @Test
    public void loginTest() throws Exception{
        MockHttpServletResponse response = mockMvc.perform
                (
                        MockMvcRequestBuilders.get("http://localhost/login")
                                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                                .param("credentials","18818223608")
                                .param("password","123")
                                .param("client_id","issuesApp")
                                .param("client_secret","sjtu")
                )
                .andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
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

//    @Transactional
//    @Test
//    public void modifyProfilePictureTest() throws Exception {
//        MockMultipartFile file = new MockMultipartFile("profilePicture", "filename.txt", "text/plain", "some xml".getBytes());
//        MockHttpServletResponse response = mockMvc.perform(
//                MockMvcRequestBuilders.patch( "http://localhost/user/1/profilePicture")
//                        .header("userId","1")
//                        .header("userType","USER")
//        ).andReturn().getResponse();
//        Assert.assertEquals(response.getStatus(), 200);
//    }

    @Transactional
    @Test
    public void modifyPasswordTest() throws Exception {
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.patch( "http://localhost/user/1/password")
                        .header("userId","1")
                        .header("userType","USER")
                        .param("oldPassword","Test")
                        .param("newPassword","Test")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(), 200);
    }
}
