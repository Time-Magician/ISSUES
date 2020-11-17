package com.example.userservice;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.GenericGenerator;
import javax.persistence.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "users")
public class User {

    private int userId;
    private String name;
    private String gender;
    private String email;

    @Id
    @Column(name = "user_id")
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    @Basic
    @Column(name = "name")
    public String getName() {return  name;}
    public void setName(String name) {
        this.name = name;
    }

    @Basic
    @Column(name = "email")
    public String getEmail() {return email;}
    public void setEmail(String email) {
        this.email = email;
    }

    @Basic
    @Column(name = "gender")
    public String getGender() {return gender;}
    public void setGender(String gender) {
        this.gender = gender;
    }
}
