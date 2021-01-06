package com.example.studyservice.Service;

import com.example.studyservice.Entity.AlarmRecord;
import com.example.studyservice.Entity.StudyRecord;
import com.example.studyservice.Repository.AlarmRecordRepository;
import com.example.studyservice.Repository.StudyRecordRepository;
import com.example.studyservice.StudyServiceApplication;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.transaction.Transactional;
import java.sql.Date;
import java.sql.Time;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = StudyServiceApplication.class)
public class RecordServiceTest {
    @Autowired
    RecordService recordService;

    @Autowired
    AlarmRecordRepository alarmRecordRepository;

    @Autowired
    StudyRecordRepository studyRecordRepository;

    @Test
    @Transactional
    public void createStudyRecordTest(){
        recordService.createStudyRecord(Date.valueOf("2021-1-1"),Date.valueOf("2020-1-1"),1,2,60);
    }

    @Test
    @Transactional
    public void createAlarmRecordTest(){
        recordService.createAlarmRecord(1,1,200,"TestMission",1);
    }
}
