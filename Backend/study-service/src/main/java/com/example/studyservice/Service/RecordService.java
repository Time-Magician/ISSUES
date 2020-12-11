package com.example.studyservice.Service;

import com.example.studyservice.Entity.AlarmRecord;
import com.example.studyservice.Entity.StudyRecord;

import java.sql.Time;

public interface RecordService {
   StudyRecord createStudyRecord(Time startTime, Time endTime, Integer frogId, Integer userId);
   AlarmRecord createAlarmRecord(Integer alarmId,Integer frogId,Integer duration,String mission,Integer userId);
}
