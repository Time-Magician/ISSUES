package com.example.studyservice.Utility;

import java.text.SimpleDateFormat;

public class CommonUtil {
    public static java.sql.Time strToTime(String strDate) {
        String str = strDate;
        SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
        java.util.Date date = null;
        try {
            date = format.parse(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
        java.sql.Time time = new java.sql.Time(date.getTime());
        return time.valueOf(str);
    }
}
