package com.example.alarmservice;

import com.example.alarmservice.Dao.AlarmDao;
import com.example.alarmservice.Entity.Alarm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.Time;
import java.util.List;

@Repository
public class AlarmDaoImpl implements AlarmDao {
    @Autowired
    AlarmRepository alarmRepository;

    @Override
    public List<Alarm> getAlarmList(int userId) {
        return alarmRepository.getAlarmsByUserId(userId);
    }

    @Override
    public String deleteAlarm(int alarmId, int userId) {
        alarmRepository.deleteByAlarmIdAndUserId(alarmId,userId);
        return "success";
    }

    @Override
    public String createAlarm(int alarmId, int userId, String mission, String audio, String label, String repeat, Time time) {
        Alarm alarm = new Alarm();
        alarm.setUserId(userId);
        alarm.setMission(mission);
        alarm.setAudio(audio);
        alarm.setLabel(label);
        alarm.setTime(time);
        alarm.setAlarmId(alarmId);
        alarm.setRepeat(repeat);
        alarmRepository.save(alarm);
        return "success";
    }

    @Override
    public String updateAlarm(int alarmId, int userId, String mission, String audio, String label, String repeat, Time time) {
        Alarm alarm = alarmRepository.findByAlarmIdAndUserId(alarmId,userId);
        alarm.setAudio(audio);
        alarm.setUserId(userId);
        alarm.setTime(time);
        alarm.setLabel(label);
        alarm.setMission(mission);
        alarm.setRepeat(repeat);
        alarm.setAlarmId(alarmId);
        alarmRepository.save(alarm);
        return "success";
    }

    @Override
    public void uploadAlarmList(int userId, List<Alarm> alarmList) {
        alarmRepository.deleteAlarmByUserId(userId);
        for(Alarm alarm:alarmList){
            alarmRepository.save(alarm);
        }
    }
}
