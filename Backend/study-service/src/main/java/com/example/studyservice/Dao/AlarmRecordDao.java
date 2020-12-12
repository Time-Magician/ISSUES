package com.example.studyservice.Dao;

import com.example.studyservice.Entity.AlarmRecord;
import com.example.studyservice.Entity.StudyRecord;

public interface AlarmRecordDao {
    AlarmRecord createAlarmRecord(Integer alarmId,Integer frogId,Integer duration,String mission,Integer userId);
}
