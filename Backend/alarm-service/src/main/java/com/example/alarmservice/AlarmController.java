package com.example.alarmservice;

import com.example.alarmservice.Service.AlarmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.example.alarmservice.utility.CommonUtil;
import java.sql.Time;
import java.util.List;

@RestController
public class AlarmController {
    @Autowired
    AlarmService alarmService;

    @GetMapping("/user/{userId}/alarms")
    List<Alarm> getAlarmList(@PathVariable int userId){
        return alarmService.getAlarmList(userId);
    }

    @PutMapping("/user/{userId}/alarms")
    String uploadAlarmList(@PathVariable int userId,@RequestBody List<Alarm> alarmList){
        alarmService.uploadAlarmList(userId,alarmList);
        return "success";
    }

    @PostMapping("/user/{user_id}/alarm/{alarm_id}")
    String createAlarm(@PathVariable(name = "alarm_id")int alarmId,
                       @PathVariable(name = "user_id")int userId,
                       @RequestParam(name = "label")String label,
                       @RequestParam(name = "mission")String mission,
                       @RequestParam(name = "audio") String audio,
                       @RequestParam(name = "time")String time,
                       @RequestParam(name = "repeat")String repeat ){
        return alarmService.createAlarm(alarmId,userId,mission,audio,label,repeat,CommonUtil.strToTime(time));
    }

    @DeleteMapping("/user/{user_id}/alarm/{alarm_id}")
    String deleteAlarm(@PathVariable(name = "alarm_id") int alarmId,
                       @PathVariable(name = "user_id") int userId){
        return alarmService.deleteAlarm(alarmId,userId);
    }



    @PutMapping("/user/{user_id}/alarm/{alarm_id}")
    String updateAlarm(@PathVariable(name = "alarm_id")int alarmId,
                       @PathVariable(name = "user_id")int userId,
                       @RequestParam(name = "label")String label,
                       @RequestParam(name = "mission")String mission,
                       @RequestParam(name = "audio") String audio,
                       @RequestParam(name = "time")String time,
                       @RequestParam(name = "repeat")String repeat){
        return alarmService.updateAlarm(alarmId,userId,mission,audio,label,repeat,CommonUtil.strToTime(time));
    }
}
