package com.example.userservice.Dao;

public interface RedisDao {
    public void setRedis(String key, String value);
    public String getRedis(String key);
    public Boolean delRedis(String key);
}
