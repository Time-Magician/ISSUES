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
        int requestUserId = Integer.parseInt(httpRequest.getHeader("userId"));
        if(requestUserId != userId){
            return null;
        }
        return alarmService.getAlarmList(userId);
    }

    @PutMapping("/user/{userId}/alarms")
    String uploadAlarmList(
            HttpServletRequest httpRequest,
            @PathVariable int userId,
            @RequestBody List<Alarm> alarmList
    ){
        int requestUserId = Integer.parseInt(httpRequest.getHeader("userId"));
        if(requestUserId != userId){
            return "Error:Permission Denied!";
        }
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
        int requestUserId = Integer.parseInt(httpRequest.getHeader("userId"));
        if(requestUserId != userId){
            return "Error:Permission Denied!";
        }
        if(!CommonUtil.checkRepeatValidate(repeat)){
            return "Error:Repeat Invalid!";
        }
        if(!CommonUtil.checkMissionValidate(mission)){
            return "Error:Mission Invalid!";
        }
        if(alarmId < 0){
            return "Error:AlarmID Invalid!";
        }
        java.sql.Time _time;
        try {
            _time = CommonUtil.strToTime(time);
        }catch (Exception  e){
            return "Error:Time Invalid!";
        }
        return alarmService.createAlarm(alarmId,userId,mission,audio,label,repeat,_time);
    }

    @DeleteMapping("/user/{user_id}/alarm/{alarm_id}")
    String deleteAlarm(
            HttpServletRequest httpRequest,
            @PathVariable(name = "alarm_id") int alarmId,
            @PathVariable(name = "user_id") int userId
    ){
        int requestUserId = Integer.parseInt(httpRequest.getHeader("userId"));
        if(requestUserId != userId){
            return "Error:Permission Denied!";
        }
        if(alarmId < 0){
            return "Error:AlarmID Invalid!";
        }
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
        int requestUserId = Integer.parseInt(httpRequest.getHeader("userId"));
        if(requestUserId != userId){
            return "Error:Permission Denied!";
        }
        if(!CommonUtil.checkRepeatValidate(repeat)){
            return "Error:Repeat Invalid!";
        }
        if(!CommonUtil.checkMissionValidate(mission)){
            return "Error:Mission Invalid!";
        }
        if(alarmId < 0){
            return "Error:AlarmID Invalid!";
        }
        java.sql.Time _time;
        try {
            _time = CommonUtil.strToTime(time);
        }catch (Exception  e){
            return "Error:Time Invalid!";
        }
        return alarmService.updateAlarm(alarmId,userId,mission,audio,label,repeat,_time);
    }
}
