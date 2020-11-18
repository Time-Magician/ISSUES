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
    public String deleteAlarm(int id) {
        return alarmDao.deleteAlarm(id);
    }

    @Override
    public String createAlarm(int userId, String mission, String audio, String label, Time time) {
        return alarmDao.createAlarm(userId,mission,audio,label,time);
    }

    @Override
    public String updateAlarm(int id, String mission, String audio, String label, Time time) {
        return alarmDao.updateAlarm(id,mission,audio,label,time);
    }
}
