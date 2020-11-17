package com.example.userservice;

import com.example.userservice.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/user")
public class UserController {
    @Autowired
    UserService userService;

    @GetMapping("/getUser/{id}")
    public User getUserById(@PathVariable(value = "id") int userId){
        return userService.getUserById(userId);
    }
}
