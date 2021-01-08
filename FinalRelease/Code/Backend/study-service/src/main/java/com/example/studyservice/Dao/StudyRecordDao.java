package com.example.studyservice.Dao;

import com.example.studyservice.Entity.StudyRecord;

import java.sql.Date;
import java.util.List;

public interface StudyRecordDao {
    StudyRecord createStudyRecord(Date startTime, Date endTime, Integer frogId, Integer userId, Integer duration);
    List<StudyRecord> getStudyRecordsByUser(int userId);
}
