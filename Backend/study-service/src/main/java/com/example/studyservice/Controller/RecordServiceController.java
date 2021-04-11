package com.example.studyservice.Controller;

import com.example.studyservice.Entity.AlarmRecord;
import com.example.studyservice.Entity.StudyRecord;
import com.example.studyservice.ServiceImpl.RecordServiceImpl;
import com.example.studyservice.Utility.CommonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RestController
public class RecordServiceController {
    @Autowired
    RecordServiceImpl RecordService;

    @PutMapping("/user/{userId}/studyRecord")
    StudyRecord createStudyRecord(
            HttpServletRequest request,
            @RequestParam(name = "start_time") String startTime,
            @RequestParam(name = "end_time") String endTime,
            @RequestParam(name = "frog_id") int frogId,
            @RequestParam(name = "duration") int duration,
            @PathVariable int userId){
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if(requesterUserId != userId){
            return null;
        }
        java.sql.Date _startTime, _endTime;
        try{
            _startTime = CommonUtil.strToDate(startTime);
            _endTime = CommonUtil.strToDate(endTime);
        }catch(Exception e){
            return null;
        }
        if(_startTime.after(_endTime)){
            return null;
        }
        if(frogId < 0){
            return null;
        }
        if(duration < 0){
            return null;
        }
        return RecordService.createStudyRecord(_startTime,_endTime,frogId,userId,duration);
    }

    @PostMapping("/user/{userId}/alarmRecord")
    AlarmRecord createAlarmRecord(@RequestParam(name = "alarm_id") int alarmId,
                                  @RequestParam(name = "frog_id") int frogId,
                                  @RequestParam(name = "duration") int duration,
                                  @RequestParam(name = "mission") String mission,
                                  @PathVariable int userId,
                                  HttpServletRequest request){
        int requesterUserId = Integer.parseInt(request.getHeader("userId"));
        if(requesterUserId != userId){
            return null;
        }
        if(!CommonUtil.checkMissionValidate(mission)){
            return null;
        }
        if(frogId < 0 || alarmId < 0 || duration < 0){
            return null;
        }
        return RecordService.createAlarmRecord(alarmId,frogId,duration,mission,userId);
    }

    @GetMapping("/user/{userId}/studyRecords")
    List<StudyRecord> getStudyRecordsByUser(@PathVariable int userId){
        return RecordService.getStudyRecordsByUser(userId);
    }
}
