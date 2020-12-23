package com.example.demo5;

import android.annotation.SuppressLint;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Message;
import android.os.Handler;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.content.Intent;
import android.os.Build.VERSION;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.baidu.aip.imageclassify.AipImageClassify;
import com.example.demo5.AlarmManager.RepeatingAlarm;
import com.example.demo5.AudioSensor.AudioRecordManager;
import com.example.demo5.ProcessLock.ProcessMonitorService;
import com.example.demo5.ShakeSensor.SensorManagerHelper;

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
import java.util.Map;
import java.util.TimeZone;

public class MainActivity extends FlutterActivity{
    private Intent serviceIntent;
    private MethodChannel methodChannel;
    public static MainActivity instance = null;
    public static final String APP_ID = "22907417";
    public static final String API_KEY = "zU2tRIF1FaHD8gxy3QTPY7Qw";
    public static final String SECRET_KEY = "rIpRruQPpWPnTkxZnqsi1XnN9a4qltc9";
    private AudioRecordManager audioRecordManger;      //调用话筒实现类
    private static final int RECORD = 2;              //监听话筒
    AipImageClassify client = new AipImageClassify(APP_ID, API_KEY, SECRET_KEY);

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        SensorManagerHelper sensorHelper = new SensorManagerHelper(this);
        instance = this;
        String CHANNEL1 = "Channel";
        serviceIntent = new Intent(MainActivity.this, ProcessMonitorService.class);
        methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL1);
        methodChannel.setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
                switch (call.method) {
                    case "startStudy":
                        String mode = call.argument("mode");
                        List<String> whiteListList = call.argument("whiteList");
                        String[] whiteList = whiteListList.toArray(new String[whiteListList.size()]);
                        serviceIntent.putExtra("whiteList", whiteList);
                        serviceIntent.putExtra("mode", mode);
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
                        int timeSpan = call.argument("timeSpan");
                        String alarmIndex = call.argument("alarmIndex");
                        alarm(hour, minute, alarmIndex,timeSpan);
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
                        @SuppressLint("HandlerLeak") Handler uiHandler = new Handler() {
                            @Override
                            public void handleMessage(Message msg) {
                                result.success(msg.obj);
                            }
                        };
                        new Thread(new Runnable() {
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
                                    Message msg = new Message();
                                    msg.obj = keyword;
                                    uiHandler.sendMessage(msg);

                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            }

                        }).start();

                        System.out.println(keyword);
                        break;
                    case "shakeListen":
                        sensorHelper.start();
                        sensorHelper.setOnShakeListener(() -> {
                            // TODO Auto-generated method stub
                            shake();
                        });
                        break;
                    case "stopShakeListen":
                        sensorHelper.stop();
                        break;
                    case "startAudioSensor":
                        @SuppressLint("HandlerLeak") Handler audioHandler = new Handler() {
                            @Override
                            public void handleMessage(Message msg) {
                                double volume = Double.parseDouble(msg.obj.toString());
                                System.out.println(volume);
                                if(volume >= 60)
                                    highPitch();
                            }
                        };
                        //实例化话筒实现类
                        if(ContextCompat.checkSelfPermission(MainActivity.instance, android.Manifest.permission.RECORD_AUDIO)
                                != PackageManager.PERMISSION_GRANTED){
                            ActivityCompat.requestPermissions(MainActivity.instance,new String[]{
                                    android.Manifest.permission.RECORD_AUDIO},1);
                            while (ContextCompat.checkSelfPermission(MainActivity.instance, android.Manifest.permission.RECORD_AUDIO)
                                    != PackageManager.PERMISSION_GRANTED);
                            result.success("retry");
                        } else {
                            audioRecordManger = new AudioRecordManager(audioHandler,RECORD); //实例化话筒实现类
                            audioRecordManger.getNoiseLevel();
                        }
                        //打开话筒监听声音
                        break;
                    case "stopAudioSensor":
                        audioRecordManger.stopRecord();
                        break;
                    case "getApplicationList":{
                        Map<String, String> appList = getAppList();
                        methodChannel.invokeMethod("appList",appList);
                        break;
                    }
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

    public Map<String, String> getAppList() {
        Map<String, String> appList = new HashMap<>();
        PackageManager pm = getPackageManager();
        // Return a List of all packages that are installed on the device.
        List<PackageInfo> packages = pm.getInstalledPackages(0);
        for (PackageInfo packageInfo : packages) {
            // 判断系统/非系统应用
            if ((packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 0) // 非系统应用
            {
                String packageName = packageInfo.packageName;
                String appName = packageInfo.applicationInfo.loadLabel(getPackageManager()).toString();
                System.out.println(appName);
                appList.put(packageName, appName);
            }
        }
        appList.remove("com.example.demo5");
        return appList;
    }

    public void shake() { methodChannel.invokeMethod("shake",1); }

    public void highPitch() { methodChannel.invokeMethod("highPitch",1); }

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


    public void music(String alarmIndex){
        methodChannel.invokeMethod("test",alarmIndex);
    }

    private void alarm(int hour, int minute, String alarmIndex,int timeSpan) {
        // 获取系统的闹钟服务
        AlarmManager am = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        // 触发闹钟的时间（毫秒）
        Intent intent = new Intent(this, RepeatingAlarm.class);
        intent.setAction("com.gcc.alarm");
        String uri="content://calendar/calendar_alerts/"+String.valueOf(hour)+":"+String.valueOf(minute);
        intent.setData(Uri.parse(uri));
        intent.putExtra("alarmIndex", alarmIndex);

        PendingIntent op = PendingIntent.getBroadcast(this, 0, intent, 0);

        Calendar c = Calendar.getInstance(TimeZone.getTimeZone("GMT+8"));
        c.setTimeInMillis(System.currentTimeMillis());
        c.set(Calendar.HOUR_OF_DAY, hour);
        c.set(Calendar.MINUTE, minute);
        c.set(Calendar.SECOND,0);

        am.set(AlarmManager.RTC_WAKEUP, c.getTimeInMillis()+86400000*timeSpan, op);

        System.out.println("Set Alarm:"+String.valueOf(hour)+":"+String.valueOf(minute)+" after "+String.valueOf(timeSpan)+" day");
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