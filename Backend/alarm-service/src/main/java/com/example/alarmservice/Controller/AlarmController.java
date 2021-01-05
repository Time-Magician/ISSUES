package com.example.alarmservice.Controller;

import com.example.alarmservice.Entity.Alarm;
import com.example.alarmservice.Service.AlarmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.example.alarmservice.utility.CommonUtil;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RestController
public class AlarmController {
    @Autowired
    AlarmService alarmService;

    @GetMapping("/user/{userId}/alarms")
    List<Alarm> getAlarmList(
            @PathVariable int userId,
            HttpServletRequest httpRequest
    ){
        userId = Integer.parseInt(httpRequest.getHeader("userId"));
        return alarmService.getAlarmList(userId);
    }

    @PutMapping("/user/{userId}/alarms")
    String uploadAlarmList(
            HttpServletRequest httpRequest,
            @PathVariable int userId,
            @RequestBody List<Alarm> alarmList
    ){
        userId = Integer.parseInt(httpRequest.getHeader("userId"));
        alarmService.uploadAlarmList(userId,alarmList);
        return "success";
    }

    @PostMapping("/user/{user_id}/alarm/{alarm_id}")
    String createAlarm(
            HttpServletRequest httpRequest,
            @PathVariable(name = "alarm_id")int alarmId,
            @PathVariable(name = "user_id")int userId,
            @RequestParam(name = "label")String label,
            @RequestParam(name = "mission")String mission,
            @RequestParam(name = "audio") String audio,
            @RequestParam(name = "time")String time,
            @RequestParam(name = "repeat")String repeat
    ){
        userId = Integer.parseInt(httpRequest.getHeader("userId"));
        return alarmService.createAlarm(alarmId,userId,mission,audio,label,repeat,CommonUtil.strToTime(time));
    }

    @DeleteMapping("/user/{user_id}/alarm/{alarm_id}")
    String deleteAlarm(
            HttpServletRequest httpRequest,
            @PathVariable(name = "alarm_id") int alarmId,
            @PathVariable(name = "user_id") int userId
    ){
        userId = Integer.parseInt(httpRequest.getHeader("userId"));
        return alarmService.deleteAlarm(alarmId,userId);
    }



    @PutMapping("/user/{user_id}/alarm/{alarm_id}")
    String updateAlarm(
            HttpServletRequest httpRequest,
            @PathVariable(name = "alarm_id")int alarmId,
            @PathVariable(name = "user_id")int userId,
            @RequestParam(name = "label")String label,
            @RequestParam(name = "mission")String mission,
            @RequestParam(name = "audio") String audio,
            @RequestParam(name = "time")String time,
            @RequestParam(name = "repeat")String repeat
    ){
        userId = Integer.parseInt(httpRequest.getHeader("userId"));
        return alarmService.updateAlarm(alarmId,userId,mission,audio,label,repeat,CommonUtil.strToTime(time));
    }
}
