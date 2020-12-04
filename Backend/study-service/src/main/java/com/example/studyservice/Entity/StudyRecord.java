package com.example.studyservice.Entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
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
    private Time startTime;

    @Basic
    @Column(name = "end_time")
    private Time endTime;

    @Basic
    @Column(name = "frog_id")
    private int frogId;

    @Basic
    @Column(name = "user_id")
    private int userId;
}
