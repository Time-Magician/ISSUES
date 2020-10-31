package com.example.demo5;

import android.app.Activity;
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

import com.example.demo5.ProcessLock.ProcessMonitorService;

public class MainActivity extends FlutterActivity {

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String CHANNEL1 = "Lock.plugin";
        Intent intent = new Intent(MainActivity.this, ProcessMonitorService.class);
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
                } else {
                    result.notImplemented();
                }
            }
        });
    }
}
