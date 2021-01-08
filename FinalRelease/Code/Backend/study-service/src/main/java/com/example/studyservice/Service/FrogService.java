package com.example.studyservice.Service;

import com.example.studyservice.Entity.Frog;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface FrogService {
   Frog createFrog(String name, int level, int exp, boolean isGraduated, String graduateDate, String school,int userId);
   Frog updateFrog(String name, int level, int exp, boolean isGraduated, String graduateDate, String school,int userId);
   Frog getFrogByUser(int userId);
   List<Frog> getGraduatedFrogs(int userId);
}
