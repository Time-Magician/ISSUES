package com.example.alarmservice.Service;

import com.example.alarmservice.Alarm;

import java.sql.Time;
import java.util.List;

public interface AlarmService {
    List<Alarm> getAlarmList(int userId);
    String deleteAlarm(int id);
    String createAlarm(int userId, String mission, String audio, String label, Time time);
    String updateAlarm(int id,String mission,String audio,String label,Time time);
}
