package com.example.studyservice.DaoImpl;

import com.example.studyservice.Dao.StudyRecordDao;
import com.example.studyservice.Entity.StudyRecord;
import com.example.studyservice.Repository.StudyRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.Time;

@Repository
public class StudyRecordDaoImpl implements StudyRecordDao {
    @Autowired
    StudyRecordRepository studyRecordRepository;

    @Override
    public StudyRecord createStudyRecord(Time startTime, Time endTime, Integer frogId, Integer userId) {
        StudyRecord studyRecord = new StudyRecord();
        studyRecord.setStartTime(startTime);
        studyRecord.setFrogId(frogId);
        studyRecord.setEndTime(endTime);
        studyRecord.setUserId(userId);
        studyRecordRepository.save(studyRecord);

        return studyRecord;
    }
}

