package com.example.studyservice.Controller;

import com.example.studyservice.StudyServiceApplication;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.context.WebApplicationContext;

import javax.transaction.Transactional;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = {StudyServiceApplication.class},webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class FrogControllerTest {
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
    public void createFrogTest()throws Exception{
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("name","陈二狗");
        paramsMap.add("level","10");
        paramsMap.add("exp","10");
        paramsMap.add("is_graduated","False");
        paramsMap.add("graduate_date","2020.13.32");
        paramsMap.add("school","蛤交");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/10086/frog")
                        .header("userId",10086)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }


    @Transactional
    @Test
    public void updateFrogTest()throws Exception{
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("name","陈二狗");
        paramsMap.add("level","10");
        paramsMap.add("exp","10");
        paramsMap.add("is_graduated","False");
        paramsMap.add("graduate_date","2020.13.32");
        paramsMap.add("school","蛤交");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/3/frog")
                        .header("userId",3)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }

    @Transactional
    @Test
    public void getFrogByUserTest()throws Exception{
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/3/frog")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }
}
