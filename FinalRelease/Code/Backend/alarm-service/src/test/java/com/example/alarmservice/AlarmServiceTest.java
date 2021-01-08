package com.example.alarmservice;

import com.example.alarmservice.Entity.Alarm;
import com.example.alarmservice.Service.AlarmService;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.transaction.Transactional;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = AlarmServiceApplication.class)
public class AlarmServiceTest {

    @Autowired
    AlarmService alarmService;

    @Test
    @Transactional
    public void getAlarmListTest(){
        List<Alarm> alarms = alarmService.getAlarmList(4);
        Alarm alarm1 = alarms.get(0);
        Alarm alarm2 = alarms.get(1);
        Alarm alarm3 = alarms.get(2);
        Assert.assertEquals(alarm1.getAlarmId(),1);
        Assert.assertEquals(alarm1.getLabel(),"起床");
        Assert.assertEquals(alarm2.getAlarmId(),2);
        Assert.assertEquals(alarm2.getLabel(),"高数考试");
        Assert.assertEquals(alarm3.getAlarmId(),3);
        Assert.assertEquals(alarm3.getLabel(),"小组会议");
    }

    @Test
    @Transactional
    public void uploadAlarmListTest(){
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
        alarmService.uploadAlarmList(4,alarms);
        List<Alarm> newAlarms = alarmService.getAlarmList(4);
        Assert.assertTrue(newAlarms.containsAll(alarms));
    }

    @Test
    @Transactional
    public void deleteAlarmTest(){
        Alarm toDeleteAlarm = alarmService.getAlarmList(4).stream().filter(alarm -> alarm.getAlarmId()==1).findFirst().get();
        alarmService.deleteAlarm(1,4);
        List<Alarm> newAlarms = alarmService.getAlarmList(4);
        Assert.assertFalse(newAlarms.contains(toDeleteAlarm));

    }

    @Test
    @Transactional
    public void createAlarmTest(){
        alarmService.createAlarm(1000,4,"TestMission","TestAudio","TestLable","NOT",Time.valueOf("12:00:00"));
        Alarm alarm = alarmService.getAlarmList(4).stream().filter(tmp -> (tmp.getAlarmId()==1000)).findFirst().get();
        Assert.assertNotNull(alarm);
    }


    @Test
    @Transactional
    public void updateAlarmTest(){
        alarmService.updateAlarm(1,4,"TestMission","TestAudio","TestLable","NOT",Time.valueOf("12:00:00"));
        Alarm alarm = alarmService.getAlarmList(4).stream().filter(tmp -> (tmp.getAlarmId()==1)).findFirst().get();
        Assert.assertEquals(alarm.getMission(),"TestMission");
        Assert.assertEquals(alarm.getAudio(),"TestAudio");
    }
}
