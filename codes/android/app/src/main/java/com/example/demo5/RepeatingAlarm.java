package com.example.demo5;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.os.Message;
import android.telecom.Call;

import java.io.IOException;

public class RepeatingAlarm extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction()!=null&&intent.getAction().equals("com.gcc.alarm")) {//自定义的action
            String musicName=intent.getStringExtra("musicName");
//            intent = new Intent(context,AlarmActivity.class);
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            intent.putExtra("musicName",musicName);
//            context.startActivity(intent);
            MainActivity.instance.music(musicName);
        }
    }
}
