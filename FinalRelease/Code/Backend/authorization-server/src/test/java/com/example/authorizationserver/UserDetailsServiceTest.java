package com.example.authorizationserver;

import com.example.authorizationserver.UserAuth.UserAuth;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import javax.transaction.Transactional;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = AuthorizationServerApplication.class)
public class UserDetailsServiceTest {
    @Resource
    UserDetailsService userDetailsServiceImpl;

    @Test
    @Transactional
    public void loadUserByUsernameTest(){
        UserDetails userDetails =  userDetailsServiceImpl.loadUserByUsername("18818223608");
        Assert.assertNotNull(userDetails);
    }
}
