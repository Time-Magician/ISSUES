package com.example.studyservice.Controller;

import com.alibaba.fastjson.JSONObject;
import com.example.studyservice.Entity.Frog;
import com.example.studyservice.Service.FrogService;
import com.example.studyservice.StudyServiceApplication;
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
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.context.WebApplicationContext;

import javax.transaction.Transactional;
import java.util.Map;


@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = {StudyServiceApplication.class},webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class FrogControllerTest {
    private MockMvc mockMvc;

    @Autowired
    @InjectMocks
    FrogController frogController;

    @Mock
    FrogService frogService;

    @Autowired
    private WebApplicationContext context;

    @Test
    public void contextLoads(){
    }
    @Before
    public void setup(){
        MockitoAnnotations.initMocks(this);
        //mock createFrog
        Frog mockFrog4Create = new Frog(),
                mockFrog4Update = new Frog(),
                mockFrog4Get = new Frog();
        mockFrog4Create.setFrogId(12);
        Mockito.when(frogService.createFrog("EGOCHEN",10,10,false,"2020-1-1","SJTU",1)).thenReturn(mockFrog4Create);

        mockFrog4Update.setFrogId(23);
        Mockito.when(frogService.updateFrog("EGOCHEN",10,10,false,"2020-1-1","SJTU",1)).thenReturn(mockFrog4Update);

        mockFrog4Get.setFrogId(34);
        Mockito.when(frogService.getFrogByUser(1)).thenReturn(mockFrog4Get);
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Transactional
    @Test
    public void createFrogTest()throws Exception{
        /*
        *   合法等价类：创建成功
        *
        */
        Map<String, Object> responseMap;
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("name","EGOCHEN");
        paramsMap.add("level","10");
        paramsMap.add("exp","10");
        paramsMap.add("is_graduated","False");
        paramsMap.add("graduate_date","2020-1-1");
        paramsMap.add("school","SJTU");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/frogs")
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        log.info(response.getContentAsString());
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(responseMap.get("frogId"),12);

        /*
         *   无效等价类：权限不符
         *
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",2)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类：level无效值(level > 17)
         *
         */
        paramsMap.set("level","100");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类：level无效值(level < 0)
         *
         */
        paramsMap.set("level","-20");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");


        /*
         *   无效等价类：exp无效值(exp < 0)
         *
         */
        paramsMap.set("level","10");
        paramsMap.set("exp","-100");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");


        /*
         *   无效等价类：exp无效值(exp > 100)
         *
         */
        paramsMap.set("exp","200");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类：graduate_date无效值
         *
         */
        paramsMap.set("graduate_date","2020-13-51");
        paramsMap.set("exp","10");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");
    }


    @Transactional
    @Test
    public void updateFrogTest()throws Exception{
        Map<String, Object> responseMap;
        /*
         *   合法等价类：更新成功
         *
         */
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("name","EGOCHEN");
        paramsMap.add("level","10");
        paramsMap.add("exp","10");
        paramsMap.add("is_graduated","False");
        paramsMap.add("graduate_date","2020-1-1");
        paramsMap.add("school","SJTU");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/frogs")
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(),200);
        log.info(responseMap.toString());
        Assert.assertEquals(responseMap.get("frogId"),23);

        /*
         *   无效等价类：权限不符
         *
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",2)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类：level无效值
         *
         */
        paramsMap.set("level","100");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类：exp无效值
         *
         */
        paramsMap.set("level","10");
        paramsMap.set("exp","-100");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类：graduate_date无效值
         *
         */
        paramsMap.set("graduate_date","2020-17-51");
        paramsMap.set("exp","10");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/frogs")
                        //pathVariable中的userId与header中不符
                        .header("userId",1)
                        .header("userType","USER")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");
    }

    @Transactional
    @Test
    public void getFrogByUserTest()throws Exception{
        Map<String, Object> responseMap;
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/1/frogs/candidate")
                        .header("userId",1)
                        .header("userType","USER")
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(responseMap.get("frogId"),34);

        /*
         *   非法等价类：权限不符
         *
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/1/frogs/candidate")
                        //pathVariable中的userId与header中不符
                        .header("userId",2)
                        .header("userType","USER")
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");
    }
}
