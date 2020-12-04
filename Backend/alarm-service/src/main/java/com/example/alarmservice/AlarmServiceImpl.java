package com.example.alarmservice;

import com.example.alarmservice.Service.AlarmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Time;
import java.util.List;

@Service
public class AlarmServiceImpl implements AlarmService {
    @Autowired
    AlarmDao alarmDao;
    @Override
    public List<Alarm> getAlarmList(int userId) {
        return alarmDao.getAlarmList(userId);
    }

    @Override
    public String deleteAlarm(int alarmId, int userId) {
        return alarmDao.deleteAlarm(alarmId,userId);
    }

    @Override
    public String createAlarm(int alarmId, int userId, String mission, String audio, String label, String repeat, Time time) {
        return alarmDao.createAlarm(alarmId,userId,mission,audio,label,repeat,time);
    }

    @Override
    public String updateAlarm(int alarmId, int userId, String mission, String audio, String label, String repeat, Time time) {
        return alarmDao.updateAlarm(alarmId,userId,mission,audio,label,repeat,time);
    }

    @Override
    public void uploadAlarmList(int userId, List<Alarm> alarmList) {
        alarmDao.uploadAlarmList(userId,alarmList);
    }
}
