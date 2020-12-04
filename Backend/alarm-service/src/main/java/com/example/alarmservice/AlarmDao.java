package com.example.alarmservice;

import java.sql.Time;
import java.util.List;

public interface AlarmDao {
    void uploadAlarmList(int userId,List<Alarm> alarmList);
    List<Alarm> getAlarmList(int userId);
    String deleteAlarm(int alarmId,int userId);
    String createAlarm(int alarmId,int userId, String mission,String audio,String label,String repeat,Time time);
    String updateAlarm(int alarmId,int userId, String mission,String audio,String label,String repeat,Time time);
}
