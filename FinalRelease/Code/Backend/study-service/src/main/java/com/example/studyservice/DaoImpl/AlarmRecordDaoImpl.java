package com.example.studyservice.DaoImpl;

import com.example.studyservice.Dao.AlarmRecordDao;
import com.example.studyservice.Entity.AlarmRecord;
import com.example.studyservice.Repository.AlarmRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AlarmRecordDaoImpl implements AlarmRecordDao {
    @Autowired
    AlarmRecordRepository alarmRecordRepository;

    @Override
    public AlarmRecord createAlarmRecord(Integer alarmId, Integer frogId, Integer duration, String mission, Integer userId) {
        AlarmRecord alarmRecord = new AlarmRecord();
        alarmRecord.setAlarmId(alarmId);
        alarmRecord.setDuration(duration);
        alarmRecord.setUserId(userId);
        alarmRecord.setFrogId(frogId);
        alarmRecord.setMission(mission);

        alarmRecordRepository.save(alarmRecord);

        return alarmRecord;
    }
}
