package com.example.studyservice.Controller;

import com.example.studyservice.Entity.Frog;
import com.example.studyservice.Service.FrogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RestController
public class FrogController {
    @Autowired
    FrogService frogService;

    @PostMapping("/user/{userId}/frogs")
    Frog createFrog(HttpServletRequest request,
                    @RequestParam(name = "name") String name,
                    @RequestParam(name = "level") int level,
                    @RequestParam(name = "exp") int exp,
                    @RequestParam(name = "is_graduated") boolean isGraduated,
                    @RequestParam(name = "graduate_date") String graduateDate,
                    @RequestParam(name = "school") String school,
                    @PathVariable int userId){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if (!userType.equals("ADMIN") && requesterUserId != userId) {
            return null;
        }

        return frogService.createFrog(name,level,exp,isGraduated,graduateDate,school,userId);
    }
    

    @PutMapping("/user/{userId}/frogs")
    Frog updateFrog(HttpServletRequest request,
                    @RequestParam(name = "name") String name,
                    @RequestParam(name = "level") int level,
                    @RequestParam(name = "exp") int exp,
                    @RequestParam(name = "is_graduated") boolean isGraduated,
                    @RequestParam(name = "graduate_date") String graduateDate,
                    @RequestParam(name = "school") String school,
                    @PathVariable int userId){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if (!userType.equals("ADMIN") && requesterUserId != userId) {
            return null;
        }

        return frogService.updateFrog(name,level,exp,isGraduated,graduateDate,school,userId);
    }

    @GetMapping("/user/{userId}/frogs/graduated")
    List<Frog> getGraduatedFrogs(HttpServletRequest request,
                                 @PathVariable(name = "userId") int userId) {
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if (!userType.equals("ADMIN") && requesterUserId != userId) {
            return null;
        }

        return frogService.getGraduatedFrogs(userId);
    }

    @GetMapping("/user/{userId}/frogs/candidate")
    Frog getFrogByUser(HttpServletRequest request,
                       @PathVariable(name = "userId") int userId){
        String userType = request.getHeader("userType");
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if (!userType.equals("ADMIN") && requesterUserId != userId) {
            return null;
        }

        return frogService.getFrogByUser(userId);
    }
}
