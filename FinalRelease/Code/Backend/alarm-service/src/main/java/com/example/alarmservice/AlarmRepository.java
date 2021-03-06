package com.example.alarmservice;

import com.example.alarmservice.Entity.Alarm;
import org.springframework.data.jpa.repository.JpaRepository;

import javax.transaction.Transactional;
import java.util.List;

public interface AlarmRepository extends JpaRepository<Alarm,Integer> {
    List<Alarm> getAlarmsByUserId(int userId);
    @Transactional
    void deleteByAlarmIdAndUserId(int alarmId,int userId);
    @Transactional
    void deleteAlarmByUserId(int userId);
    Alarm findByAlarmIdAndUserId(int alarmId, int userId);
}

