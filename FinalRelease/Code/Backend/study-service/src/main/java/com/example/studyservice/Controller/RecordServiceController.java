package com.example.studyservice.Controller;

import com.example.studyservice.Entity.AlarmRecord;
import com.example.studyservice.Entity.Frog;
import com.example.studyservice.Entity.StudyRecord;
import com.example.studyservice.ServiceImpl.RecordServiceImpl;
import com.example.studyservice.Utility.CommonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class RecordServiceController {
    @Autowired
    RecordServiceImpl RecordService;

    @PutMapping("/user/{userId}/studyRecord")
    StudyRecord createStudyRecord(@RequestParam(name = "start_time") String startTime,
                                  @RequestParam(name = "end_time") String endTime,
                                  @RequestParam(name = "frog_id") int frogId,
                                  @RequestParam(name = "duration") int duration,
                                  @PathVariable int userId){
        return RecordService.createStudyRecord(CommonUtil.strToDate(startTime),CommonUtil.strToDate(endTime),frogId,userId,duration);
    }

    @PostMapping("/user/{userId}/alarmRecord")
    AlarmRecord createAlarmRecord(@RequestParam(name = "alarm_id") int alarmId,
                                  @RequestParam(name = "frog_id") int frogId,
                                  @RequestParam(name = "duration") int duration,
                                  @RequestParam(name = "mission") String mission,
                                  @PathVariable int userId){
        return RecordService.createAlarmRecord(alarmId,frogId,duration,mission,userId);
    }

    @GetMapping("/user/{userId}/studyRecords")
    List<StudyRecord> getStudyRecordsByUser(@PathVariable int userId){
        return RecordService.getStudyRecordsByUser(userId);
    }
}
