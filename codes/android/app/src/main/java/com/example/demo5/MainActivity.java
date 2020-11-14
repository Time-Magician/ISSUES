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

import com.baidu.aip.imageclassify.AipImageClassify;
import com.example.demo5.AlarmManager.AlarmActivity;
import com.example.demo5.AlarmManager.RepeatingAlarm;
import com.example.demo5.ProcessLock.ProcessMonitorService;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.TimeZone;
import java.util.concurrent.CountDownLatch;

public class MainActivity extends FlutterActivity{
    private Intent serviceIntent;
    private MethodChannel methodChannel;
    public static MainActivity instance = null;
    public static final String APP_ID = "22907417";
    public static final String API_KEY = "zU2tRIF1FaHD8gxy3QTPY7Qw";
    public static final String SECRET_KEY = "rIpRruQPpWPnTkxZnqsi1XnN9a4qltc9";
    AipImageClassify client = new AipImageClassify(APP_ID, API_KEY, SECRET_KEY);

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        instance = this;
        String CHANNEL1 = "Channel";
        serviceIntent = new Intent(MainActivity.this, ProcessMonitorService.class);
        methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL1);
        methodChannel.setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
                switch (call.method) {
                    case "startStudy":
                        if (VERSION.SDK_INT >= Build.VERSION_CODES.O)
                            MainActivity.this.startForegroundService(serviceIntent);
                        else
                            MainActivity.this.startService(serviceIntent);
                        result.success("success");
                        break;
                    case "stopStudy":
//                    Intent intent = new Intent(MainActivity.this, ProcessMonitorService.class);
                        MainActivity.this.stopService(serviceIntent);
                        result.success("success");
                        break;
                    case "startAlarm": {
                        int hour = call.argument("hour");
                        int minute = call.argument("minute");
                        String musicName = call.argument("musicName");
                        alarm(hour, minute, musicName);
                        break;
                    }
                    case "cancelAlarm": {
                        int hour = call.argument("hour");
                        int minute = call.argument("minute");
                        cancelAlarm(hour, minute);
                        break;
                    }
                    case "imageClassify":
                        String path = call.argument("image");
                        List<String> keyword = new ArrayList<>();
                        Thread thread= new Thread(new Runnable() {
                            @Override
                            public void run() {
                                HashMap<String, String> options = new HashMap<String, String>();
                                options.put("top_num", "3");
                                options.put("filter_threshold", "0.7");
                                options.put("baike_num", "5");

                                assert path != null;
                                FileInputStream inStream = null;
                                try {
                                    inStream = new FileInputStream(path);
                                } catch (FileNotFoundException e) {
                                    e.printStackTrace();
                                }
                                byte[] file = new byte[0];
                                try {
                                    file = InputStreamToByte(inStream);
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }
                                JSONObject res = client.advancedGeneral(file, options);
                                try {
                                    JSONArray imageResult = res.getJSONArray("result");

                                    for (int i = 0; i < imageResult.length(); i++) {
                                        keyword.add((String) imageResult.getJSONObject(i).get("keyword"));
                                    }

                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            }
                        });
                        thread.start();
                        System.out.println(keyword);
                        try {
                            thread.join();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                        result.success(keyword);
                        break;
                    default:
                        result.notImplemented();
                        break;
                }
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    private byte[] InputStreamToByte(InputStream is) throws IOException, IOException {
        ByteArrayOutputStream bytestream = new ByteArrayOutputStream();
        int ch;
        while ((ch = is.read()) != -1) {
            bytestream.write(ch);
        }
        byte[] imgData = bytestream.toByteArray();
        bytestream.close();
        return imgData;
    }


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