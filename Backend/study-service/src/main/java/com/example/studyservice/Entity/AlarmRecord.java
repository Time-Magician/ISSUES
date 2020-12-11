package com.example.studyservice.Entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "alarm_records")
public class AlarmRecord {
    @Id
    @Column(name = "id")
    private int id;

    @Column(name = "user_id")
    private int userId;

    @Column(name = "alarm_id")
    private int alarmId;

    @Column(name = "frog_id")
    private int frogId;

    @Column(name = "duration")
    private int  duration;

    @Column(name =  "mission")
    private String mission;

    public int getId(){
        return this.id;
    }

    public void setId(int id){
        this.id = id;
    }

    public int getUserId(){
        return this.userId;
    }

    public void setUserId(int userId){
        this.userId = userId;
    }

    public int getAlarmId(){
        return  this.alarmId;
    }

    public  void  setAlarmId(int alarmId){
        this.alarmId = alarmId;
    }

    public int getFrogId(){
        return this.frogId;
    }

    public void setFrogId(int frogId){
        this.frogId = frogId;
    }

    public int getDuration(){
        return this.duration;
    }

    public void setDuration(int duration){
        this.duration = duration;
    }

    public String getMission(){
        return this.mission;
    }

    public  void  setMission(String mission){
        this.mission = mission;
    }
}
