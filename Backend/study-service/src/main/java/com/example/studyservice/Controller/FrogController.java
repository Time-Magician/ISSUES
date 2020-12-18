package com.example.studyservice.Controller;

import com.example.studyservice.Entity.Frog;
import com.example.studyservice.Service.FrogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("/user/{userId}/frog")
    Frog getFrogByUser(@PathVariable int userId){
        if(frogService.getFrogByUser(userId) == null){
            return null;
        }
        else{
            return frogService.getFrogByUser(userId);
        }
    }

    @PutMapping("/user/{userId}/frog")
    Frog updateFrog(@RequestParam(name = "name") String name,
                    @RequestParam(name = "level") int level,
                    @RequestParam(name = "exp") int exp,
                    @RequestParam(name = "is_graduated") boolean isGraduated,
                    @RequestParam(name = "graduate_date") String graduateDate,
                    @RequestParam(name = "school") String school,
                    @PathVariable int userId){
            return frogService.updateFrog(name,level,exp,isGraduated,graduateDate,school,userId);
    }

}
