package com.example.alarmservice;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.sql.Time;

@Entity
@Table(name = "alarm")
@Data
public class Alarm {
    private int id;
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
    @Column(name = "user_id")
    private int userId;


    @Id
    @Column(name = "id")
    @GeneratedValue(generator = "increment")
    @GenericGenerator(name = "increment", strategy = "increment")
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
