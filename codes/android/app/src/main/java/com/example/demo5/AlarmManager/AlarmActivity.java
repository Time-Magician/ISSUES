package com.example.demo5.AlarmManager;

import androidx.appcompat.app.AlertDialog;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.AssetManager;
import android.media.MediaPlayer;
import android.os.Bundle;

import com.example.demo5.MainActivity;
import com.example.demo5.R;

import java.util.Calendar;

import io.flutter.embedding.android.FlutterActivity;

import com.baidu.aip.imageclassify.AipImageClassify;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

public class AlarmActivity extends FlutterActivity {

    MediaPlayer mp;
    AssetManager assetManager;
    public static final String APP_ID = "22907417";
    public static final String API_KEY = "zU2tRIF1FaHD8gxy3QTPY7Qw";
    public static final String SECRET_KEY = "rIpRruQPpWPnTkxZnqsi1XnN9a4qltc9";
    AipImageClassify client = new AipImageClassify(APP_ID, API_KEY, SECRET_KEY);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.aty_alarm);
        String musicName=this.getIntent().getStringExtra("musicName");
        MainActivity.instance.music(musicName);

        try {
            sample();
        } catch (JSONException e) {
            e.printStackTrace();
        }

        finish();
//        mp = new MediaPlayer();
//        String musicName=this.getIntent().getStringExtra("musicName")+".mp3";
//        assetManager = getAssets();
//        try {
//            AssetFileDescriptor file = assetManager.openFd(musicName);
//            mp.setDataSource(file.getFileDescriptor(), file.getStartOffset(),
//                    file.getLength());
//            mp.prepare();
//            file.close();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        mp.setVolume(0.5f, 0.5f);
//        mp.setLooping(true);
//        mp.start();


//        alarmOialog();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
    public void sample() throws JSONException {
        HashMap<String, String> options = new HashMap<String, String>();
        options.put("top_num", "3");
        options.put("filter_threshold", "0.7");
        options.put("baike_num", "5");

        // 参数为本地路径
        byte[] file = readFile("test.jpg");
        JSONObject res = client.advancedGeneral(file, options);
        System.out.println(res.toString(2));
    }

//    public void alarmOialog() {
//        AlertDialog.Builder builder = new AlertDialog.Builder(this);
//        builder.setMessage("你有未处理的事件");
//        builder.setPositiveButton("稍后提醒",
//                new DialogInterface.OnClickListener() {
//                    @Override
//                    public void onClick(DialogInterface dialogInterface, int i) {
//                        alarm();
//                        finish();
//                    }
//                });
//
//        builder.setNegativeButton("停止", new DialogInterface.OnClickListener() {
//
//            @Override
//            public void onClick(DialogInterface dialogInterface, int i) {
//                cancelAlarm();
//                finish();// 关闭窗口
//            }
//        });
//        builder.show().setCanceledOnTouchOutside(false);
//        ;
//
//    }
//
//    private void alarm() {
//        // 获取系统的闹钟服务
//        AlarmManager am = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
//        // 触发闹钟的时间（毫秒）
//        Intent intent = new Intent(this, RepeatingAlarm.class);
//        intent.setAction("com.gcc.alarm");
//        PendingIntent op = PendingIntent.getBroadcast(this, 0, intent, 0);
//        // 启动一次只会执行一次的闹钟
//        Calendar c = Calendar.getInstance();
//        c.setTimeInMillis(System.currentTimeMillis());
//        am.set(AlarmManager.RTC_WAKEUP, c.getTimeInMillis()+20000, op);
//    }
//
//    /**
//     * 取消闹钟
//     */
//    private void cancelAlarm() {
//        // Create the same intent, and thus a matching IntentSender, for
//        // the one that was scheduled.
//        Intent intent = new Intent(AlarmActivity.this, RepeatingAlarm.class);
//        intent.setAction("com.gcc.alarm");
//        PendingIntent sender = PendingIntent.getBroadcast(AlarmActivity.this,
//                0, intent, 0);
//
//        // And cancel the alarm.
//        AlarmManager am = (AlarmManager) getSystemService(ALARM_SERVICE);
//        am.cancel(sender);
//    }
}