package com.example.demo5.AlarmManager;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.example.demo5.AlarmManager.AlarmActivity;

public class RepeatingAlarm extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction()!=null&&intent.getAction().equals("com.gcc.alarm")) {//自定义的action
            String alarmIndex = intent.getStringExtra("alarmIndex");
            System.out.println("******"+alarmIndex);
            intent = new Intent(context, AlarmActivity.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.putExtra("alarmIndex",alarmIndex);
            context.startActivity(intent);
        }
    }
}
