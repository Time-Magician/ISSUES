package com.example.authorizationserver;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import javax.transaction.Transactional;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = {AuthorizationServerApplication.class},webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class PublicKeyControllerTest {
    private MockMvc mockMvc;

    @Autowired
    private WebApplicationContext context;

    @Test
    public void contextLoads(){
    }

    @Before
    public void setup(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Transactional
    @Test
    public void getKeyTest() throws Exception{
        MockHttpServletResponse response = mockMvc.perform
                (
                        MockMvcRequestBuilders.get("http://localhost/rsa/publicKey")
                )
                .andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }
}
