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
    String createAlarm(@RequestParam(name = "userId")int userId,
                       @RequestParam(name = "label")String label,
                       @RequestParam(name = "mission")String mission,
                       @RequestParam(name = "audio") String audio,
                       @RequestParam(name = "time") String time){

        return alarmService.createAlarm(userId,mission,audio,label,CommonUtil.strToTime(time));
    }

    @DeleteMapping("/deleteAlarm/{id}")
    String deleteAlarm(@PathVariable int id){
        return alarmService.deleteAlarm(id);
    }

    @PutMapping("/updateAlarm")
    String updateAlarm(@RequestParam(name = "id")int id,
                       @RequestParam(name = "label")String label,
                       @RequestParam(name = "mission")String mission,
                       @RequestParam(name = "audio") String audio,
                       @RequestParam(name = "time") String time){
        return alarmService.updateAlarm(id,mission,audio,label,CommonUtil.strToTime(time));
    }
}
