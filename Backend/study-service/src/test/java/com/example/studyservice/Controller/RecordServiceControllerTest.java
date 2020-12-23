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
public class RecordServiceControllerTest {
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
    public void createStudyRecordTest()throws Exception{
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("start_time","12:00:00");
        paramsMap.add("end_time","14:00:00");
        paramsMap.add("frog_id","10");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/studyRecord")
                    .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }

    @Transactional
    @Test
    public void createAlarmRecordTest()throws Exception{
        MultiValueMap<String,String> paramsMap = new LinkedMultiValueMap<>();
        paramsMap.add("alarm_id","10");
        paramsMap.add("frog_id","10");
        paramsMap.add("duration","200");
        paramsMap.add("mission","TestMission");
        MockHttpServletResponse response = mockMvc.perform(
                MockMvcRequestBuilders.post("http://localhost/user/1/alarmRecord")
                        .params(paramsMap)
        ).andReturn().getResponse();
        Assert.assertEquals(response.getStatus(),200);
    }
}
