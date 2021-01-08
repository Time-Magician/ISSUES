package com.example.userservice.Entity;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Document(collection = "friends")
public class Friends {
    @Id
    private ObjectId id;
    @Field("user_id")
    private int userId;
    @Field("friends")
    private List<Integer> friends;

    public Friends(int userId, List<Integer> friends){
        this.userId = userId;
        this.friends = friends;
    }

    public ObjectId getId() { return id;}

    public void setId(ObjectId id) { this.id = id; }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public List<Integer> getFriends() {
        return friends;
    }

    public void setFriends(List<Integer> friends) {
        this.friends = friends;
    }

}
