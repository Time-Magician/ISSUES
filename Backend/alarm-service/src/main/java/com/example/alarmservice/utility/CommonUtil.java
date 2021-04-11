package com.example.alarmservice.utility;

import java.text.SimpleDateFormat;
import java.util.HashSet;
import java.util.Set;

public class CommonUtil {
    static HashSet<String> repeatValidStr = new HashSet<String>(){{
        add("周一");
        add("周二");
        add("周三");
        add("周四");
        add("周五");
        add("周六");
        add("周日");
    }};

    static HashSet<String> missionValidStr = new HashSet<String>(){{
        add("算术题");
        add("小游戏");
        add("指定物品拍照");
        add("摇晃手机");
        add("吹气");
        add("随机任务");
    }};
    public static java.sql.Time strToTime(String strDate) throws Exception{
        String str = strDate;
        SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
        java.util.Date date = null;
        try {
            format.setLenient(false);
            date = format.parse(str);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        java.sql.Time time = new java.sql.Time(date.getTime());
        return time.valueOf(str);
    }

    public static boolean checkRepeatValidate(String repeat){
        for(String str : repeat.split(" ")){
            if(!repeatValidStr.contains(str)){
                return false;
            }
        }
        return true;
    }

    public static boolean checkMissionValidate(String mission){
        if(!missionValidStr.contains(mission)){
            return false;
        }
        return true;
    }
}
