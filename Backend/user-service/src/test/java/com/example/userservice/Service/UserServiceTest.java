package com.example.userservice.Service;

import com.example.UserServiceApplication;
import com.example.userservice.Dao.RedisDao;
import com.example.userservice.Dao.UserAuthDao;
import com.example.userservice.Dao.UserDao;
import com.example.userservice.Entity.Message;
import com.example.userservice.Entity.User;
import com.example.userservice.Entity.UserAuth;
import com.example.userservice.Repository.UserAuthRepository;
import com.example.userservice.ServiceImpl.UserServiceImpl;
import com.example.userservice.util.msgUtils.Msg;
import com.example.userservice.util.msgUtils.MsgUtil;
import org.checkerframework.checker.units.qual.A;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.multipart.MultipartFile;
import javax.transaction.Transactional;
import java.io.IOException;
import java.util.*;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = UserServiceApplication.class)
public class UserServiceTest {
    @Mock
    private RedisDao redisDao;

    @Autowired
    @InjectMocks
    UserServiceImpl userService;

    @Autowired
    UserAuthRepository userAuthRepository;

    @Test
    public void contextLoads(){
    }

    @Before
    public void setup(){
        MockitoAnnotations.initMocks(this);
    }

    @Test
    @Transactional
    public void getUserByIdTest(){
        User user = userService.getUserById(1);
        Assert.assertEquals(user.getUsername(),"ou8CaiT7O");
        Assert.assertEquals(user.getName(),"anonymous");
        Assert.assertEquals(user.getTel(),"18818223608");
    }

    @Test
    @Transactional
    //如果该测试失败，应该将数据库中userId为1,2,3的userType修改为1,即User,因为getAllUsers只会返回非Admin的用户
    public void getAllUsersTest(){
        List<User> users = userService.getAllUsers();
        Collections.sort(users, Comparator.comparingInt(User::getUserId));
        System.out.println(users.toString());
        Assert.assertEquals(users.get(0).getUsername(),"ou8CaiT7O");
        Assert.assertEquals(users.get(1).getUsername(),"j14xLwh44");
        Assert.assertEquals(users.get(2).getUsername(),"QY0vKRbh6");
    }

    @Test
    @Transactional
    public void register(){
        Mockito.when(redisDao.getRedis("12312341234")).thenReturn("onlyForTest");
        Msg msg= userService.register("123","12312341234","onlyForTest");
        Assert.assertEquals(msg.getStatus(), MsgUtil.SUCCESS);
    }


    @Test
    @Transactional
    public void checkUserByIdAndPasswordTest(){
        Boolean flag = userService.checkUserByIdAndPassword(1,"123");
        Assert.assertEquals(flag, Boolean.TRUE);
    }

    @Test
    @Transactional
    public void checkUserTest(){
        Mockito.when(redisDao.getRedis("12312341234")).thenReturn("onlyForTest");
        Msg msg= userService.register("123","12312341234","onlyForTest");
        Assert.assertEquals(msg.getStatus(), MsgUtil.SUCCESS);
        //Msg msg = userService.checkUser("18818223608","123");
        //Assert.assertEquals(msg.getStatus(), MsgUtil.SUCCESS);
    }
//    @Test
//    @Transactional
//    public void verifyTest(){
//        Msg msg = userService.verify("18818223608");
//        Assert.assertEquals(msg.getStatus(),MsgUtil.SUCCESS);
//    }

    @Test
    @Transactional
    public void verifyEmailTest(){
        Msg msg = userService.verifyEmail("abi419@sjtu.edu.cn");
        Assert.assertEquals(msg.getStatus(),MsgUtil.SUCCESS);
    }

    @Test
    @Transactional
    public void modifyUsernameTest(){
        Msg msg = userService.modifyUsername(1,"testUser");
        Assert.assertEquals(msg.getStatus(),MsgUtil.SUCCESS);
        Assert.assertEquals(userService.getUserById(1).getUsername(),"testUser");
    }

    @Test
    @Transactional
    public void modifyGenderTest(){
        Msg msg = userService.modifyGender(1,"男");
        Assert.assertEquals(msg.getStatus(),MsgUtil.SUCCESS);
        Assert.assertEquals(userService.getUserById(1).getGender(),"男");
    }

    @Test
    @Transactional
    public void modifyPasswordTest(){
        Msg msg = userService.modifyPassword(1,"456");
        UserAuth userAuth = userAuthRepository.findById(1).get();
        Assert.assertEquals(msg.getStatus(),MsgUtil.SUCCESS);
        //Assert.assertEquals(userService.checkUserByIdAndPassword(1,"456"),Boolean.TRUE);
        Assert.assertTrue(userAuth.getPassword().equals("456"));
    }

    @Test
    @Transactional
    public void enableUserTest(){
        Msg msg = userService.enableUser(1);
        UserAuth userAuth = userAuthRepository.findById(1).get();
        Assert.assertEquals(msg.getStatus(),MsgUtil.SUCCESS);
        Assert.assertEquals(userAuth.getUserType(),1);
    }

    @Test
    @Transactional
    public void disableUserTest(){
        Msg msg = userService.disableUser(1);
        UserAuth userAuth = userAuthRepository.findById(1).get();
        Assert.assertEquals(msg.getStatus(),MsgUtil.SUCCESS);
        Assert.assertEquals(userAuth.getUserType(),2);
    }

    @Test
    @Transactional
    public void getFriendListTest(){
        List<User> friends = userService.getFriendList(1);
       // Assert.assertEquals(friends.get(0).getUserId(),2);
    }

    @Test
    @Transactional
    public void testRedisCacheTest(){
        Mockito.when(redisDao.getRedis("12312341234")).thenReturn("onlyForTest");
        Assert.assertTrue(userService.testRedisCache("12312341234").equals("onlyForTest"));
    }

    @Test
    @Transactional
    public void deleteFriendTest(){
        //userService.deleteFriend(1,2);
        List<User> friends = userService.getFriendList(1);
        //Assert.assertTrue(friends.isEmpty());
        userService.addFriend(1,2);
    }

    @Test
    @Transactional
    public void addFriendTest(){
        userService.addFriend(1,3);
        List<User> friends = userService.getFriendList(1);
       // Assert.assertEquals(friends.get(1).getUserId(),3);
        userService.deleteFriend(1,3);
    }


    //ToDo
    @Test
    @Transactional
    public void getMessagesTest(){
        List<Message> messages = userService.getMessages(1);
    }

    //ToDo
    @Test
    @Transactional
    public void addMessageTest(){
        userService.addMessage(1,2,"JustTest","Detail");
    }

    //ToDo
    @Test
    @Transactional
    public void checkMessageTest(){
        userService.checkMessage("test");
    }

    @Test
    @Transactional
    public void searchUserTest(){
        User user = userService.searchUser("18818223608");
        Assert.assertTrue(user.getUsername().equals("ou8CaiT7O"));
    }
//    Msg modifyProfilePicture(int userId, MultipartFile profilePicture) throws IOException;
}
