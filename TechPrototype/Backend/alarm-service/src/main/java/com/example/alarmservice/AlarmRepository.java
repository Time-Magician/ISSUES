package com.example.alarmservice;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AlarmRepository extends JpaRepository<Alarm,Integer> {
    List<Alarm> getAlarmsByUserId(int userId);
}
