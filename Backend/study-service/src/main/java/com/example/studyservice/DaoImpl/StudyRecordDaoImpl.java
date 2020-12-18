package com.example.studyservice.DaoImpl;

import com.example.studyservice.Dao.StudyRecordDao;
import com.example.studyservice.Entity.StudyRecord;
import com.example.studyservice.Repository.StudyRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

@Repository
public class StudyRecordDaoImpl implements StudyRecordDao {
    @Autowired
    StudyRecordRepository studyRecordRepository;

    @Override
    public StudyRecord createStudyRecord(Date startTime, Date endTime, Integer frogId, Integer userId, Integer duration) {
        StudyRecord studyRecord = studyRecordRepository.getStudyRecordByUserAndStartTime(userId,startTime);
        if(studyRecord == null){
            studyRecord = new StudyRecord();
            studyRecord.setStartTime(startTime);
            studyRecord.setFrogId(frogId);
            studyRecord.setEndTime(endTime);
            studyRecord.setUserId(userId);
            studyRecord.setDuration(duration);
            studyRecordRepository.save(studyRecord);
        }
        else{
            int _duration = studyRecord.getDuration();
            _duration += duration;
            studyRecord.setDuration(_duration);
            studyRecordRepository.save(studyRecord);
        }
        return studyRecord;
    }

    @Override
    public List<StudyRecord> getStudyRecordsByUser(int userId) {
        return studyRecordRepository.getStudyRecordsByUser(userId);
    }
}

