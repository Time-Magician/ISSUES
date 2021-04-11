package com.example.studyservice.Utility;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;

public class CommonUtil {
    static HashSet<String> missionValidStr = new HashSet<String>(){{
        add("算术题");
        add("小游戏");
        add("指定物品拍照");
        add("摇晃手机");
        add("吹气");
        add("随机任务");
    }};
    public static java.sql.Date strToDate(String strDate)throws Exception {
        String str = strDate;
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date d = null;
        try {
            format.setLenient(false);
            d = format.parse(str);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        java.sql.Date date = new java.sql.Date(d.getTime());
        return date;
    }

    public static boolean checkMissionValidate(String mission){
        if(!missionValidStr.contains(mission)){
            return false;
        }
        return true;
    }
}
