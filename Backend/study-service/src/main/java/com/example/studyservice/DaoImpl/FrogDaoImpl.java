package com.example.studyservice.DaoImpl;

import com.example.studyservice.Dao.FrogDao;
import com.example.studyservice.Entity.Frog;
import com.example.studyservice.Repository.FrogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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
;
        return frog;
    }
}
