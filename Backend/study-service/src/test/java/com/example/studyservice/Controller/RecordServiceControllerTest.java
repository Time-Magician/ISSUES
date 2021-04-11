package com.example.studyservice.Controller;

import com.alibaba.fastjson.JSONObject;
import com.example.studyservice.Entity.AlarmRecord;
import com.example.studyservice.Entity.StudyRecord;
import com.example.studyservice.Service.RecordService;
import com.example.studyservice.StudyServiceApplication;
import com.example.studyservice.Utility.CommonUtil;
import lombok.extern.slf4j.Slf4j;
import org.checkerframework.checker.units.qual.A;
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
import java.sql.Date;
import java.util.Map;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = {StudyServiceApplication.class},webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class RecordServiceControllerTest {
    private MockMvc mockMvc;

    @Autowired
    private WebApplicationContext context;

    @Autowired
    @InjectMocks
    RecordServiceController recordServiceController;

    @Mock
    RecordService recordService;

    @Test
    public void contextLoads(){
    }

    @Before
    public void setup(){
        MockitoAnnotations.initMocks(this);

        StudyRecord mockStudyRecord = new StudyRecord();
        mockStudyRecord.setId(2);
        Mockito.when(recordService.createStudyRecord(Date.valueOf("2021-04-10"),Date.valueOf("2021-04-10"),1,1,120)).thenReturn(mockStudyRecord);

        AlarmRecord mockAlarmRecord = new AlarmRecord();
        mockAlarmRecord.setAlarmId(23);
        Mockito.when(recordService.createAlarmRecord(23,1,120,"随机任务",1)).thenReturn(mockAlarmRecord);

        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Transactional
    @Test
    public void createStudyRecordTest()throws Exception{
        Map<String, Object> responseMap;
        /*
        *   合法等价类：创建成功
        */
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("start_time","2021-4-10");
        paramsMap.add("end_time","2021-4-10");
        paramsMap.add("frog_id","1");
        paramsMap.add("duration","120");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/studyRecord")
                        .header("userId",1)
                    .params(paramsMap)
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        log.info("tag1234"+responseMap.toString());
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(responseMap.get("id"),2);

        /*
        *   无效等价类： 权限不足
        */
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/studyRecord")
                        .header("userId",2)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类： 起始时间 > 结束时间
         */
        paramsMap.set("start_time","2021-04-11");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/studyRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类： 起始时间或结束时间Invalid
         */
        paramsMap.set("start_time","2021-13-21");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/studyRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类： 起始时间或结束时间Invalid
         */
        paramsMap.set("end_time","2021-13-21");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/studyRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类： duration无效值
         */
        paramsMap.set("start_time","2021-4-11");
        paramsMap.set("end_time","2021-4-11");
        paramsMap.set("duration","-100");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/studyRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类： frog_id无效值
         */
        paramsMap.set("frog_id","-20");
        paramsMap.set("duration","120");
        response = mockMvc.perform(
                MockMvcRequestBuilders.put("http://localhost/user/1/studyRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");
    }

    @Transactional
    @Test
    public void createAlarmRecordTest()throws Exception{
        Map<String, Object> responseMap;
        /*
         *   合法等价类：创建成功
         */
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("alarm_id","23");
        paramsMap.add("frog_id","1");
        paramsMap.add("duration","120");
        paramsMap.add("mission","随机任务");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarmRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        responseMap = JSONObject.parseObject(response.getContentAsString());
        Assert.assertEquals(response.getStatus(),200);
        log.info("tag1234"+responseMap.toString());
        Assert.assertEquals(responseMap.get("alarmId"),23);

        /*
         *   无效等价类: 权限不足
         */
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarmRecord")
                        .header("userId",2)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类: mission字段无效
         */
        paramsMap.set("mission","TestMission");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarmRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类: frog_id字段无效
         */
        paramsMap.set("mission","随机任务");
        paramsMap.set("frog_id","-10");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarmRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类: alarm_id字段无效
         */
        paramsMap.set("alarm_id","-23");
        paramsMap.set("frog_id","1");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarmRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");

        /*
         *   无效等价类: duration字段无效
         */
        paramsMap.set("alarm_id","1");
        paramsMap.set("duration","-100");
        response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarmRecord")
                        .header("userId",1)
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
        Assert.assertEquals(response.getContentAsString(),"");
    }
}
