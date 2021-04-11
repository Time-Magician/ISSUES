package com.example.studyservice.Entity;

import lombok.Builder;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;

@Entity
@Table(name = "frogs")
public class Frog {
    @Id
    @Column(name = "frog_id")
    @GeneratedValue(generator = "increment")
    @GenericGenerator(name = "increment", strategy = "increment")
    private int frogId;

    @Column(name = "user_id")
    private int userId;

    @Column(name = "name")
    private String name;

    @Column(name = "level")
    private int level;

    @Column(name = "exp")
    private int exp;

    @Column(name = "is_graduated")
    private  boolean Graduated;

    @Column(name = "graduate_date")
    private String graduateDate;

    @Column(name = "school")
    private String school;

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

    public void setName(String name){
        this.name = name;
    }

    public String getName(){
        return this.name;
    }

    public void setLevel(int level){
        this.level = level;
    }

    public int getLevel(){
        return this.level;
    }

    public void setExp(int exp){
        this.exp = exp;
    }

    public int getExp(){
        return this.exp;
    }

    public void setGraduated(boolean isGraduated){
        this.Graduated = isGraduated;
    }

    public boolean getGraduated(){
        return this.Graduated;
    }

    public void setGraduateDate(String graduateDate){
        this.graduateDate = graduateDate;
    }

    public String getGraduateDate(){
        return this.graduateDate;
    }

    public String getSchool(){
        return this.school;
    }

    public void setSchool(String school){
        this.school = school;
    }
}
