package com.example.studyservice.Dao;

import com.example.studyservice.Entity.Frog;

public interface FrogDao {
    Frog createFrog(String name, int level, int exp, boolean isGraduated, String graduateDate, String school, int userId);
    Frog updateFrog(String name, int level, int exp, boolean isGraduated, String graduateDate, String school, int userId);
    Frog getFrogByUser(int userId);
}
