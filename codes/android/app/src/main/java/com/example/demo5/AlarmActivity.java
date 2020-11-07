package com.example.demo5;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.AssetManager;
import android.media.MediaPlayer;
import android.os.Bundle;

import java.util.Calendar;

import io.flutter.embedding.android.FlutterActivity;

public class AlarmActivity extends FlutterActivity {

    MediaPlayer mp;
    AssetManager assetManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.aty_alarm);
//        MainActivity.instance.testFun();
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
        if (mp != null) {
            if (mp.isPlaying()) {
                mp.stop();
            }
            mp.release();
        }
    }

    public void alarmOialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage("你有未处理的事件");
        builder.setPositiveButton("稍后提醒",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        alarm();
                        finish();
                    }
                });

        builder.setNegativeButton("停止", new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                cancelAlarm();
                finish();// 关闭窗口
            }
        });
        builder.show().setCanceledOnTouchOutside(false);
        ;

    }

    private void alarm() {
        // 获取系统的闹钟服务
        AlarmManager am = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        // 触发闹钟的时间（毫秒）
        Intent intent = new Intent(this, RepeatingAlarm.class);
        intent.setAction("com.gcc.alarm");
        PendingIntent op = PendingIntent.getBroadcast(this, 0, intent, 0);
        // 启动一次只会执行一次的闹钟
        Calendar c = Calendar.getInstance();
        c.setTimeInMillis(System.currentTimeMillis());
        am.set(AlarmManager.RTC_WAKEUP, c.getTimeInMillis()+20000, op);
    }

    /**
     * 取消闹钟
     */
    private void cancelAlarm() {
        // Create the same intent, and thus a matching IntentSender, for
        // the one that was scheduled.
        Intent intent = new Intent(AlarmActivity.this, RepeatingAlarm.class);
        intent.setAction("com.gcc.alarm");
        PendingIntent sender = PendingIntent.getBroadcast(AlarmActivity.this,
                0, intent, 0);

        // And cancel the alarm.
        AlarmManager am = (AlarmManager) getSystemService(ALARM_SERVICE);
        am.cancel(sender);
    }


}