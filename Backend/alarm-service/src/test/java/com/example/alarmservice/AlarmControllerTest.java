package com.example.alarmservice;

import com.alibaba.fastjson.JSONObject;
import com.example.alarmservice.Controller.AlarmController;
import com.example.alarmservice.Entity.Alarm;
import com.example.alarmservice.Service.AlarmService;
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

    @Autowired
    @InjectMocks
    AlarmController alarmController;

    @Mock
    AlarmService alarmService;

    @Test
    public void contextLoads(){
    }

    List<Alarm> alarms = new ArrayList<>();

    @Before
    public void setup(){
        MockitoAnnotations.initMocks(this);
        //mock Alarms
        for (int i = 0; i < 4; i++) {
            Alarm alarm = new Alarm();
            alarm.setUserId(1);
            alarm.setTime(Time.valueOf("12:00:00"));
            alarm.setLabel("Test");
            alarm.setAudio("TestAudio");
            alarm.setMission("TestMission");
            alarm.setAlarmId(1000+i);
        }
        Mockito.when(alarmService.getAlarmList(1)).thenReturn(alarms);

//        Alarm mockAlarm4Create = new Alarm(),
//                mockAlarm4Update = new Alarm(),
//                mockAlarm4Delete = new Alarm();
        Mockito.when(alarmService.createAlarm(1,1,"随机任务","TestAudio","TestLabel","周一 周二 周四",Time.valueOf("12:00:00"))).thenReturn("success");

        Mockito.when(alarmService.updateAlarm(1,1,"随机任务","TestAudio","TestLabel","周一 周二 周四",Time.valueOf("12:00:00"))).thenReturn("success");

        Mockito.when(alarmService.deleteAlarm(1,1)).thenReturn("success");

        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Transactional
    @Test
    public void getAlarmListTest()throws Exception{
        /*
        *   合法等价类：获取成功
        */
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/1/alarms")
                        .header("userId",1)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),JSONObject.toJSONString(alarms));

        /*
         *   非法等价类：权限不足
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.get("http://localhost/user/1/alarms")
                        //header中userId与pathVariable中userId不一致
                        .header("userId",2)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");
    }

    @Transactional
    @Test
    public void uploadAlarmListTest()throws Exception{
        /*
         *   合法等价类：上传成功
         *  无法mock, 因为uploardAlarm内部调用不返回任何信息
         */
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/alarms")
                        .header("userId",1)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(JSONObject.toJSONString(alarms))
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"success\"");

        /*
         *   非法等价类：权限不足
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/alarms")
                        //header中userId与pathVariable中userId不一致
                        .header("userId",2)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(JSONObject.toJSONString(alarms))
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Permission Denied!\"");
    }

    @Transactional
    @Test
    public void createAlarmTest()throws Exception{
        /*
         *   合法等价类：创建成功
         *
         */
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("label","TestLabel");
        paramsMap.add("mission","随机任务");
        paramsMap.add("audio","TestAudio");
        paramsMap.add("time","12:00:00");
        paramsMap.add("repeat","周一 周二 周四");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarm/1")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"success\"");

        /*
         *   无效等价类：权限不足
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarm/1")
                        .header("userId",2)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Permission Denied!\"");

        /*
         *   无效等价类：repeat字段无效
         */
        paramsMap.set("repeat","周八");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarm/1")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Repeat Invalid!\"");

        /*
         *   无效等价类：time字段无效
         */
        paramsMap.set("repeat","周一 周二 周四");
        paramsMap.set("time", "25:00:00");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarm/1")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Time Invalid!\"");

        /*
         *   无效等价类：mission字段无效
         */
        paramsMap.set("time", "12:00:00");
        paramsMap.set("mission","TestMission");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarm/1")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Mission Invalid!\"");

        /*
         *   无效等价类：alarmId字段无效
         */
        paramsMap.set("mission","随机任务");
        response = mockMvc.perform(
                //alarmId在url的请求路径中
                MockMvcRequestBuilders.post("http://localhost/user/1/alarm/-100")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:AlarmID Invalid!\"");
    }

    @Transactional
    @Test
    public void updateAlarmTest()throws Exception{
        /*
         *   合法等价类：更新成功
         *
         */
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("label","TestLabel");
        paramsMap.add("mission","随机任务");
        paramsMap.add("audio","TestAudio");
        paramsMap.add("time","12:00:00");
        paramsMap.add("repeat","周一 周二 周四");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/alarm/1")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"success\"");

        /*
         *   无效等价类：权限不足
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/alarm/1")
                        .header("userId",2)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Permission Denied!\"");

        /*
         *   无效等价类：repeat字段无效
         */
        paramsMap.set("repeat","周八");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/alarm/1")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Repeat Invalid!\"");

        /*
         *   无效等价类：time字段无效
         */
        paramsMap.set("repeat","周一 周二 周四");
        paramsMap.set("time", "25:00:00");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/alarm/1")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Time Invalid!\"");

        /*
         *   无效等价类：mission字段无效
         */
        paramsMap.set("time", "12:00:00");
        paramsMap.set("mission","TestMission");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/alarm/1")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Mission Invalid!\"");

        /*
         *   无效等价类：alarmId字段无效
         */
        paramsMap.set("mission","随机任务");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/alarm/-100")
                        //alarmId在url的请求路径中
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:AlarmID Invalid!\"");
    }

    @Transactional
    @Test
    public void deleteAlarmTest()throws Exception{
        /*
         *   合法等价类：删除成功
         *
         */
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.delete("http://localhost/user/1/alarm/1")
                        .header("userId",1)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"success\"");


        /*
         *   无效等价类：权限不足
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.delete("http://localhost/user/1/alarm/1")
                        .header("userId",2)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:Permission Denied!\"");

        /*
         *   无效等价类：alarmId字段无效
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.delete("http://localhost/user/1/alarm/-100")
                        //alarmId在url的请求路径中
                        .header("userId",1)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"\"Error:AlarmID Invalid!\"");
    }
}
