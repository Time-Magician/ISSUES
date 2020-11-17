package com.example.alarmservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestMapping;

import java.sql.Time;
import java.util.List;

@Repository
public class AlarmDaoImpl implements AlarmDao{
    @Autowired
    AlarmRepository alarmRepository;

    @Override
    public List<Alarm> getAlarmList(int userId) {
        return alarmRepository.getAlarmsByUserId(userId);
    }

    @Override
    public String deleteAlarm(int id) {
        alarmRepository.deleteById(id);
        return "success";
    }

    @Override
    public String createAlarm(int userId, String mission, String audio, String label, Time time) {
        Alarm alarm = new Alarm();
        alarm.setUserId(userId);
        alarm.setMission(mission);
        alarm.setAudio(audio);
        alarm.setLabel(label);
        alarm.setTime(time);
        alarmRepository.save(alarm);
        return "success";
    }

    @Override
    public String updateAlarm(int id, String mission, String audio, String label, Time time) {
        Alarm alarm = alarmRepository.getOne(id);
        alarm.setAudio(audio);
        alarm.setTime(time);
        alarm.setLabel(label);
        alarm.setMission(mission);
        alarmRepository.save(alarm);
        return "success";
    }
}
