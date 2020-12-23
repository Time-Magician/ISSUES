package com.example.studyservice.ServiceImpl;

import com.example.studyservice.Dao.FrogDao;
import com.example.studyservice.Entity.Frog;
import com.example.studyservice.Service.FrogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FrogServiceImpl implements FrogService {
    @Autowired
    FrogDao frogDao;

    @Override
    public Frog createFrog(String name, int level, int exp, boolean isGraduated, String graduateDate, String school, int userId) {
        return frogDao.createFrog(name,level,exp,isGraduated,graduateDate,school,userId);
    }

    @Override
    public Frog updateFrog(String name, int level, int exp, boolean isGraduated, String graduateDate, String school, int userId) {
        return frogDao.updateFrog(name,level,exp,isGraduated,graduateDate,school,userId);
    }

    @Override
    public Frog getFrogByUser(int userId) {
        return frogDao.getFrogByUser(userId);
    }

    @Override
    public List<Frog> getGraduatedFrogs(int userId){
        return frogDao.getGraduatedFrogs(userId);
    };
}