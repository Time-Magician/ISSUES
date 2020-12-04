package com.example.studyservice.Controller;

import com.example.studyservice.Entity.Frog;
import com.example.studyservice.Service.FrogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FrogController {
    @Autowired
    FrogService frogService;

    @PostMapping("/user/{userId}/frog")
    Frog createFrog(@RequestParam(name = "name") String name,
                    @RequestParam(name = "level") int level,
                    @RequestParam(name = "exp") int exp,
                    @RequestParam(name = "is_graduated") boolean isGraduated,
                    @RequestParam(name = "graduate_date") String graduateDate,
                    @RequestParam(name = "school") String school,
                    @PathVariable int userId){
        return frogService.createFrog(name,level,exp,isGraduated,graduateDate,school,userId);
    }
}
