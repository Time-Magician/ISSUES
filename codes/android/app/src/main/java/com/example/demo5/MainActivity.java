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
import android.widget.Toast;

import com.example.demo5.AlarmManager.RepeatingAlarm;
import com.example.demo5.ProcessLock.ProcessMonitorService;
import com.example.demo5.ShakeSensor.SensorManagerHelper;

import java.util.Calendar;
import java.util.TimeZone;

public class MainActivity extends FlutterActivity{
    private Intent serviceIntent;
    private MethodChannel methodChannel;
    public static MainActivity instance = null;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        SensorManagerHelper sensorHelper = new SensorManagerHelper(this);
        instance = this;
        String CHANNEL1 = "Channel";
        serviceIntent = new Intent(MainActivity.this, ProcessMonitorService.class);

        Intent intent = new Intent(MainActivity.this, ProcessMonitorService.class);
        methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL1);
        methodChannel.setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("startStudy")) {
                    if(VERSION.SDK_INT >= Build.VERSION_CODES.O)
                        MainActivity.this.startForegroundService(serviceIntent);
                    else
                        MainActivity.this.startService(serviceIntent);
                    result.success("success");
                } else if (call.method.equals("stopStudy")) {
//                    Intent intent = new Intent(MainActivity.this, ProcessMonitorService.class);
                    MainActivity.this.stopService(serviceIntent);
                    result.success("success");
                } else if(call.method.equals("startAlarm")){
                    int hour = call.argument("hour");
                    int minute = call.argument("minute");
                    String musicName=call.argument("musicName");
                    alarm(hour,minute,musicName);
                } else if(call.method.equals("cancelAlarm")){
                    int hour =call.argument("hour");
                    int minute = call.argument("minute");
                    cancelAlarm(hour,minute);
                } else if(call.method.equals("shakeListen")){
                    sensorHelper.start();
                    sensorHelper.setOnShakeListener(() -> {
                        // TODO Auto-generated method stub
//                        System.out.println("shake");
                        shake();
                    });
                } else if(call.method.equals("stopShakeListen")){
                    sensorHelper.stop();
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

    public void shake() { methodChannel.invokeMethod("shake",1); }

    public void music(String musicName){
        methodChannel.invokeMethod("test",musicName);
    }

    private void alarm(int hour,int minute,String musicName) {
        // 获取系统的闹钟服务
        AlarmManager am = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        // 触发闹钟的时间（毫秒）
        Intent intent = new Intent(this, RepeatingAlarm.class);
        intent.setAction("com.gcc.alarm");
        String uri="content://calendar/calendar_alerts/"+String.valueOf(hour)+":"+String.valueOf(minute);
        intent.setData(Uri.parse(uri));
        intent.putExtra("musicName",musicName);

        PendingIntent op = PendingIntent.getBroadcast(this, 0, intent, 0);

        Calendar c = Calendar.getInstance(TimeZone.getTimeZone("GMT+8"));
        c.setTimeInMillis(System.currentTimeMillis());
        c.set(Calendar.HOUR_OF_DAY, hour);
        c.set(Calendar.MINUTE, minute);
        c.set(Calendar.SECOND,0);

        if(System.currentTimeMillis()>c.getTimeInMillis()){
            am.set(AlarmManager.RTC_WAKEUP, c.getTimeInMillis()+86400000, op);
        }
        else{
            am.set(AlarmManager.RTC_WAKEUP, c.getTimeInMillis(), op);
        }
        System.out.println("Set Alarm:"+String.valueOf(hour)+":"+String.valueOf(minute));
    }

    private void cancelAlarm(int hour,int minute){
        AlarmManager am = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(this, RepeatingAlarm.class);
        intent.setAction("com.gcc.alarm");
        String uri="content://calendar/calendar_alerts/"+String.valueOf(hour)+":"+String.valueOf(minute);
        intent.setData(Uri.parse(uri));

        PendingIntent op = PendingIntent.getBroadcast(this, 0, intent, 0);

        am.cancel(op);
        System.out.println("Cancel Alarm:"+String.valueOf(hour)+":"+String.valueOf(minute));
    }
}