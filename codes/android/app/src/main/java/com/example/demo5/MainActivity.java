package com.example.demo5;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.content.Intent;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.util.Log;

import com.example.demo5.ProcessLock.ProcessMonitorService;

import java.util.Calendar;
import java.util.Objects;
import java.util.TimeZone;

public class MainActivity extends FlutterActivity {
    private Intent alarmIntent;
    private MethodChannel methodChannel;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String CHANNEL1 = "Channel";
        Intent intent = new Intent(MainActivity.this, ProcessMonitorService.class);
        alarmIntent = new Intent(MainActivity.this,AlarmActivity.class);
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL1).setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("startStudy")) {

                    if(VERSION.SDK_INT >= Build.VERSION_CODES.O)
                        MainActivity.this.startForegroundService(intent);
                    else
                        MainActivity.this.startService(intent);
                    result.success("success");
                } else if (call.method.equals("stopStudy")) {
//                    Intent intent = new Intent(MainActivity.this, ProcessMonitorService.class);
                    MainActivity.this.stopService(intent);
                    result.success("success");
                } else if(call.method.equals("startAlarm")){
                    int hour = call.argument("hour");
                    int minute = call.argument("minute");
                    alarm(hour,minute);
                }
                else if(call.method.equals("cancelAlarm")){
                    int hour =call.argument("hour");
                    int minute = call.argument("minute");
                    cancelalarm(hour,minute);
                }
              else {
                    result.notImplemented();
                }
            }
        });
    }
  @Override
    protected void onDestroy() {
        super.onDestroy();
    }


    private void alarm(int hour,int minute) {
        // 获取系统的闹钟服务
        AlarmManager am = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        // 触发闹钟的时间（毫秒）
        Intent intent = new Intent(this, RepeatingAlarm.class);
        intent.setAction("com.gcc.alarm");
        String uri="content://calendar/calendar_alerts/"+String.valueOf(hour)+":"+String.valueOf(minute);
        intent.setData(Uri.parse(uri));

        PendingIntent op = PendingIntent.getBroadcast(this, 0, intent, 0);
        // 启动一次只会执行一次的闹钟
        Calendar c = Calendar.getInstance(TimeZone.getTimeZone("GMT+8"));
        c.setTimeInMillis(System.currentTimeMillis());

        c.set(Calendar.HOUR_OF_DAY, hour);
        c.set(Calendar.MINUTE, minute);
        c.set(Calendar.SECOND,0);

        am.set(AlarmManager.RTC_WAKEUP, c.getTimeInMillis()-30000, op);
        // 指定时间重复执行闹钟
        // am.setRepeating(AlarmManager.RTC,triggerTime,2000,op);
    }

    private void cancelalarm(int hour,int minute){
        AlarmManager am = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        // 触发闹钟的时间（毫秒）
        Intent intent = new Intent(this, RepeatingAlarm.class);
        intent.setAction("com.gcc.alarm");
        String uri="content://calendar/calendar_alerts/"+String.valueOf(hour)+":"+String.valueOf(minute);
        intent.setData(Uri.parse(uri));
        PendingIntent op = PendingIntent.getBroadcast(this, 0, intent, 0);
        // 启动一次只会执行一次的闹钟
        am.cancel(op);
    }
}
