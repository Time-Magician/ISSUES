package com.example.alarmservice.Entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Time;

@Entity
@Table(name = "alarms")
@Data
public class Alarm {
    @Id
    @Column(name = "id")
    @GeneratedValue(generator = "increment")
    @GenericGenerator(name = "increment", strategy = "increment")
    private int id;

    @Basic
    @Column(name = "alarm_id")
    private int alarmId;

    @Basic
    @Column(name = "user_id")
    private int userId;

    @Basic
    @Column(name = "time")
    private Time time;
    @Basic
    @Column(name = "label")
    private String label;
    @Basic
    @Column(name = "mission")
    private String mission;
    @Basic
    @Column(name = "audio")
    private String audio;
    @Basic
    @Column(name = "duplicate")
    private  String repeat;



    public void setAlarmId(int alarmId){
        this.alarmId=alarmId;
    }

    public void setUserId(int userId) {
        this.userId=userId;
    }

    public void setMission(String mission) {
        this.mission=mission;
    }

    public void setAudio(String audio) {
        this.audio=audio;
    }

    public void setLabel(String label) {
        this.label=label;
    }

//    public void setTime(Time time) {
//        this.time=time;
//    }

    public void setRepeat(String repeat) {
        this.repeat=repeat;
    }

    public void setTime(Time time) {
        this.time=time;
        System.out.println(time);
    }
}
