package com.example.studyservice.Service;

import com.example.studyservice.Entity.AlarmRecord;
import com.example.studyservice.Entity.StudyRecord;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

public interface RecordService {
   StudyRecord createStudyRecord(Date startTime, Date endTime, Integer frogId, Integer userId, Integer duration);
   AlarmRecord createAlarmRecord(Integer alarmId,Integer frogId,Integer duration,String mission,Integer userId);
   List<StudyRecord> getStudyRecordsByUser(int userId);
}
