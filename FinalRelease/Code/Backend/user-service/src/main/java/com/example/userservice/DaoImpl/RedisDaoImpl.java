package com.example.userservice.DaoImpl;

import com.example.userservice.Dao.RedisDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.concurrent.TimeUnit;

@Repository
public class RedisDaoImpl implements RedisDao {
    @Autowired
    private StringRedisTemplate redisTemplate;

    @Override
    public void setRedis(String key, String value) {
        redisTemplate.opsForValue().set(key,value,300, TimeUnit.SECONDS);
        System.out.println("存入缓存成功");
    }

    @Override
    public String getRedis(String key) {
        String value = redisTemplate.opsForValue().get(key);
        System.out.println("取出缓存中"+key+"的数据是:"+value);

        return value;
    }

    @Override
    public Boolean delRedis(String key) {
        Boolean delFlag = redisTemplate.delete(key);
        return delFlag;
    }
}
