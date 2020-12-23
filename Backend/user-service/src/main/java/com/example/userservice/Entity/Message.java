package com.example.userservice.Entity;

import com.alibaba.fastjson.annotation.JSONField;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.Date;

@Document(collection = "messages")
public class Message {
    @Id
    private String id;
    @Field("sender_id")
    private int senderId;
    @Field("receiver_id")
    private int receiverId;
    @Field("time")
    private String time;
    @Field("type")
    private String type;
    @Field("status")
    private int status;
    @Field("details")
    private String details;

    public Message(int senderId, int receiverId, String time, String type, int status, String details){
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.time = time;
        this.type = type;
        this.status = status;
        this.details = details;
    }

    public Message() {
    }

    public int getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int serverId) {
        this.senderId = serverId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }
}
