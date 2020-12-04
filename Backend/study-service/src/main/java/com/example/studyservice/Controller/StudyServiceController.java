package com.example.studyservice.Controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class StudyServiceController {

    @GetMapping("/hello")
    String hello(){
        return "hello";
    }

}
