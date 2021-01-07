package com.example.studyservice.DaoImpl;

import com.example.studyservice.Dao.FrogDao;
import com.example.studyservice.Entity.Frog;
import com.example.studyservice.Repository.FrogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FrogDaoImpl implements FrogDao {
    @Autowired
    FrogRepository frogRepository;

    @Override
    public Frog createFrog(String name, int level, int exp, boolean isGraduated, String graduateDate, String school, int userId) {
        Frog frog = new Frog();
        frog.setName(name);
        frog.setLevel(level);
        frog.setExp(exp);
        frog.setGraduated(isGraduated);
        frog.setGraduateDate(graduateDate);
        frog.setSchool(school);
        frog.setUserId(userId);

        frogRepository.save(frog);

        return frog;
    }

    @Override
    public Frog updateFrog(String name, int level, int exp, boolean isGraduated, String graduateDate, String school, int userId) {
        List<Frog> frogList = frogRepository.findByUserIdAndGraduated(userId,false);
        Frog frog = frogList.get(0);
        frog.setName(name);
        frog.setLevel(level);
        frog.setExp(exp);
        frog.setGraduated(isGraduated);
        frog.setGraduateDate(graduateDate);
        frog.setSchool(school);

        frogRepository.save(frog);

        return frog;
    }

    @Override
    public Frog getFrogByUser(int userId) {
        List<Frog> frogList = frogRepository.findByUserIdAndGraduated(userId,false);
        if(frogList.isEmpty())
        {
            return null;
        }
        return frogList.get(0);
    }

    @Override
    public List<Frog> getGraduatedFrogs(int userId){
        return frogRepository.findByUserIdAndGraduated(userId,true);
    }
}
