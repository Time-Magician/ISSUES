package com.example.studyservice.ServiceImpl;

import com.example.studyservice.Dao.AlarmRecordDao;
import com.example.studyservice.Dao.StudyRecordDao;
import com.example.studyservice.Entity.AlarmRecord;
import com.example.studyservice.Entity.StudyRecord;
import com.example.studyservice.Service.RecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

@Service
public class RecordServiceImpl implements RecordService {
    @Autowired
    StudyRecordDao studyRecordDao;

    @Autowired
    AlarmRecordDao alarmRecordDao;

    @Override
    public StudyRecord createStudyRecord(Date startTime, Date endTime, Integer frogId, Integer userId, Integer duration) {
        return studyRecordDao.createStudyRecord(startTime,endTime,frogId,userId,duration);
    }

    @Override
    public AlarmRecord createAlarmRecord(Integer alarmId, Integer frogId, Integer duration, String mission, Integer userId) {
        return alarmRecordDao.createAlarmRecord(alarmId,frogId,duration,mission,userId);
    }

    @Override
    public List<StudyRecord> getStudyRecordsByUser(int userId) {
        return studyRecordDao.getStudyRecordsByUser(userId);
    }


}
