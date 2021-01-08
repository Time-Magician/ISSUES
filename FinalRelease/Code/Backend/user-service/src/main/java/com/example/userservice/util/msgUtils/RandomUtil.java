package com.example.userservice.util.msgUtils;

public class RandomUtil {
    public static String RandomNumber(){
        Integer max=999999,min=100000;
        Integer ran = (int) (Math.random()*(max-min)+min);
        System.out.println(ran.toString());
        return ran.toString();
    }
}
