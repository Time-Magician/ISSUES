package com.example.alarmservice.Service;

import com.example.alarmservice.Alarm;

import java.sql.Time;
import java.util.List;

public interface AlarmService {
    List<Alarm> getAlarmList(int userId);
    void uploadAlarmList(int userId,List<Alarm> alarmList);
    String deleteAlarm(int alarmId,int userId);
    String createAlarm(int alarmId,int userId, String mission,String audio,String label,String repeat,Time time);
    String updateAlarm(int alarmId,int userId, String mission,String audio,String label,String repeat,Time time);
}
