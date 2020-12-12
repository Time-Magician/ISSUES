package com.example.userservice.Entity;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.GenericGenerator;
import javax.persistence.*;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "users")
@JsonIgnoreProperties(value = {"handler","hibernateLazyInitializer","fieldHandler"})
@JsonIdentityInfo(
        generator = ObjectIdGenerators.PropertyGenerator.class,
        property = "userId")
public class User {

    private int userId;
    private String name;
    private String username;
    private String gender;
    private String email;
    private String tel;
    private Byte[] profilePicture;
    private List<User> friends;

    @Id
    @Column(name = "user_id")
    @GeneratedValue(generator = "increment")
    @GenericGenerator(name = "increment", strategy = "increment")
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }


    @Basic
    @Column(name = "username")
    public String getUsername(){return username;}
    public void setUsername(String username) {
        this.username = username;
    }

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

    @Basic
    @Column(name = "tel")
    public String getTel() {return tel;}
    public void setTel(String tel) {
        this.tel = tel;
    }

    @Lob
    @Column(name = "profile_picture")
    public void setProfilePicture(Byte[] profilePicture) {
        this.profilePicture = profilePicture;
    }
    public Byte[] getProfilePicture() {
        return profilePicture;
    }

    @JsonIgnore
    @Transient
    public List<User> getFriends() { return friends;}
    public void setFriends(List<User> friends) { this.friends = friends;}
}
