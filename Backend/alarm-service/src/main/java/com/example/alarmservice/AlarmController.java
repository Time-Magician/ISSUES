package com.example.alarmservice;

import com.example.alarmservice.Service.AlarmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.example.alarmservice.utility.CommonUtil;
import java.sql.Time;
import java.util.List;

@RestController
@RequestMapping("/alarm")
public class AlarmController {
    @Autowired
    AlarmService alarmService;

    @GetMapping("/getAlarmList/{userId}")
    List<Alarm> getAlarmList(@PathVariable int userId){
        return alarmService.getAlarmList(userId);
    }

    @PostMapping("/createAlarm")
    String createAlarm(@RequestParam(name="alarm_id")int alarmId,
                       @RequestParam(name = "user_id")int userId,
                       @RequestParam(name = "label")String label,
                       @RequestParam(name = "mission")String mission,
                       @RequestParam(name = "audio") String audio,
                       @RequestParam(name = "time")String time,
                       @RequestParam(name = "repeat")String repeat ){
        return alarmService.createAlarm(alarmId,userId,mission,audio,label,repeat,CommonUtil.strToTime(time));
    }

    @DeleteMapping("/deleteAlarm")
    String deleteAlarm(@RequestParam(name="alarm_id") int alarmId,
                       @RequestParam(name="user_id") int userId){
        return alarmService.deleteAlarm(alarmId,userId);
    }

    @PutMapping("/updateAlarm")
    String updateAlarm(@RequestParam(name="alarm_id")int alarmId,
                       @RequestParam(name = "user_id")int userId,
                       @RequestParam(name = "label")String label,
                       @RequestParam(name = "mission")String mission,
                       @RequestParam(name = "audio") String audio,
                       @RequestParam(name = "time")String time,
                       @RequestParam(name = "repeat")String repeat){
        return alarmService.updateAlarm(alarmId,userId,mission,audio,label,repeat,CommonUtil.strToTime(time));
    }
}
