package com.example.alarmservice;

import com.alibaba.fastjson.JSONObject;
import com.example.alarmservice.Entity.Alarm;
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
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.context.WebApplicationContext;

import javax.transaction.Transactional;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = {AlarmServiceApplication.class},webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class AlarmControllerTest {
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
    public void getAlarmListTest()throws Exception{
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/4/alarms")
                        .header("userId",4)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }

    @Transactional
    @Test
    public void uploadAlarmListTest()throws Exception{
        List<Alarm> alarms = new ArrayList<>();
        for (int i = 0; i < 4; i++) {
            Alarm alarm = new Alarm();
            alarm.setUserId(4);
            alarm.setTime(Time.valueOf("12:00:00"));
            alarm.setLabel("Test");
            alarm.setAudio("TestAudio");
            alarm.setMission("TestMission");
            alarm.setAlarmId(1000+i);
        }
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/4/alarms")
                        .header("userId",4)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(JSONObject.toJSONString(alarms))
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }

    @Transactional
    @Test
    public void createAlarmTest()throws Exception{
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("label","TestLabel");
        paramsMap.add("mission","TestMission");
        paramsMap.add("audio","TestAudio");
        paramsMap.add("time","12:00:00");
        paramsMap.add("repeat","周一");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/4/alarm/5")
                        .header("userId",4)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }

    @Transactional
    @Test
    public void updateAlarmTest()throws Exception{
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("label","TestLabel");
        paramsMap.add("mission","TestMission");
        paramsMap.add("audio","TestAudio");
        paramsMap.add("time","12:00:00");
        paramsMap.add("repeat","周一");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/4/alarm/1")
                        .header("userId",4)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }

    @Transactional
    @Test
    public void deleteAlarmTest()throws Exception{
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.delete("http://localhost/user/4/alarm/1")
                        .header("userId",1)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }
}
