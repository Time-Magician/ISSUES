package com.example.demo5.AlarmManager;
import android.os.Bundle;

import com.example.demo5.MainActivity;
import com.example.demo5.R;

import io.flutter.embedding.android.FlutterActivity;


public class AlarmActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.aty_alarm);
        String musicName=this.getIntent().getStringExtra("musicName");
        MainActivity.instance.music(musicName);
        finish();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}