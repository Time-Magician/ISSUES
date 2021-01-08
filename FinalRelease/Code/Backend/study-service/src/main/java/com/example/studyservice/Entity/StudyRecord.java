package com.example.studyservice.Entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.sql.Date;
import java.sql.Time;

@Entity
@Table(name = "study_records")
public class StudyRecord {
    @Id
    @Column(name = "id")
    @GeneratedValue(generator = "increment")
    @GenericGenerator(name = "increment", strategy = "increment")
    private int id;

    @Basic
    @Column(name = "start_time")
    private Date startTime;

    @Basic
    @Column(name = "end_time")
    private Date endTime;

    @Basic
    @Column(name = "frog_id")
    private int frogId;

    @Basic
    @Column(name = "user_id")
    private int userId;

    @Basic
    @Column(name = "duration")
    private int duration;

    public void setId(int id){
        this.id = id;
    }

    public int getId(){
        return this.id;
    }

    public void setStartTime(Date startTime){
        this.startTime = startTime;
    }

    public Date getStartTime(){
        return this.startTime;
    }

    public void setEndTime(Date endTime){
        this.endTime = endTime;
    }

    public Date getEndTime(){
        return this.endTime;
    }

    public void setFrogId(int frogId){
        this.frogId = frogId;
    }

    public int getFrogId(){
        return this.frogId;
    }

    public void setUserId(int userId){
        this.userId = userId;
    }

    public int getUserId(){
        return this.userId;
    }

    public int getDuration(){
        return this.duration;
    }

    public void setDuration(int duration){
        this.duration = duration;
    }

}
