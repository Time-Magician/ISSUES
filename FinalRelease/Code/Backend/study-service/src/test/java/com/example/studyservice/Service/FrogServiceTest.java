package com.example.studyservice.Service;

import com.example.studyservice.Entity.Frog;
import com.example.studyservice.StudyServiceApplication;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.transaction.Transactional;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = StudyServiceApplication.class)
public class FrogServiceTest {

    @Autowired
    FrogService frogService;

    @Test
    @Transactional
    public void createFrogTest(){
        frogService.createFrog("陈二狗",10,10000,Boolean.FALSE,"2020.13.08","蛤交",10086);
        Frog frog = frogService.getFrogByUser(10086);
        Assert.assertEquals(frog.getName(),"陈二狗");
        Assert.assertEquals(frog.getSchool(),"蛤交");
    }

    @Test
    @Transactional
    public void updateFrogTest(){
        frogService.updateFrog("陈二狗",10,10000,Boolean.FALSE,"2020.13.08","蛤交",3);
        Frog frog = frogService.getFrogByUser(3);
        Assert.assertEquals(frog.getName(),"陈二狗");
        Assert.assertEquals(frog.getSchool(),"蛤交");
    }

    @Test
    @Transactional
    public void getFrogByUserTest(){
        Frog frog = frogService.getFrogByUser(3);
        Assert.assertEquals(frog.getSchool(),"蛙省理工");
        Assert.assertEquals(frog.getName(),"郑建强");
    }
}
