package com.example.studyservice.Dao;

import com.example.studyservice.Entity.StudyRecord;

import java.sql.Time;

public interface StudyRecordDao {
    StudyRecord createStudyRecord(Time startTime, Time endTime, Integer frogId, Integer userId);
}
