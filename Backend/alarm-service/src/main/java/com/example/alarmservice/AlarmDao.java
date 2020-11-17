package com.example.alarmservice;

import java.sql.Time;
import java.util.List;

public interface AlarmDao {
    List<Alarm> getAlarmList(int userId);
    String deleteAlarm(int id);
    String createAlarm(int userId, String mission, String audio, String label, Time time);
    String updateAlarm(int id,String mission,String audio,String label,Time time);
}
