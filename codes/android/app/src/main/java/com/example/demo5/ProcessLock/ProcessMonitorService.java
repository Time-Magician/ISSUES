package com.example.demo5.ProcessLock;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.provider.Settings;
//import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

import androidx.core.app.NotificationCompat;

import com.example.demo5.MainActivity;
import com.example.demo5.R;

import java.util.ArrayList;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.concurrent.locks.*;


public class ProcessMonitorService extends Service {



    //第一次打开“有权查看使用情况的应用”
    private boolean isFirst = true;
    ArrayList<String> forbidApps = new ArrayList<>();
    private boolean isStoped = false;

    @SuppressLint("HandlerLeak")
    Handler  handler = new Handler(){

        public void handleMessage(android.os.Message msg){
            super.handleMessage(msg);
            //getTaskPackname();
//            if("com.ljheee.jokes".equals(getTaskPackname())){
            if(forbidApps.contains(getTaskPackname()) && !isStoped){
                Log.e("TAG","handler triggered");
                Intent intent = new Intent(getApplicationContext(),LockActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);

            }

            handler.sendEmptyMessageDelayed(1, 500);//500毫秒“轮询”一次，查看栈顶app
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
//        setContentView(R.layout.activity_main);
//        button = (Button)findViewById(R.id.button);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "message")
                    .setContentText("你的蛙蛙正在后台学习")
                    .setContentTitle("正在学习")
                    .setSmallIcon(R.drawable.launch_background);
            NotificationChannel channel = new NotificationChannel("message", "Message", NotificationManager.IMPORTANCE_LOW);
            NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            manager.createNotificationChannel(channel);
            builder.setChannelId("message");
            startForeground(1, builder.build());
        }

        getAppList();
        int selfIndex = forbidApps.indexOf("com.example.demo5");
        forbidApps.remove(selfIndex);
//        forbidApps.add("com.android.chrome");
//        forbidApps.add("com.tencent.mm");
//        forbidApps.add("com.tencent.mobileqq");

        handler.sendEmptyMessageDelayed(1, 500);
//        handler.sendEmptyMessageDelayed(1, 10000);
        //isNoSwitch();

//        button.setOnClickListener(new OnClickListener() {
//            @Override
//            public void onClick(View arg0) {
//                goToAndroidSettings();
//                //使用UsageStatsManager获取，但是这种获取方法需要用户在手机上赋予APP权限才可以使用，就是在安全-高级-有权查看使用情况的应用 在这个模块中勾选上指定APP就可以获取到栈顶的应用名
//            }
//        });
    }

    @Override
    public IBinder onBind(Intent intent){
        throw new UnsupportedOperationException("Not Implemented yet");
    }

    @Override
    public void onDestroy() {
        isStoped = true;

        handler = new Handler(){

            public void handleMessage(android.os.Message msg){
                super.handleMessage(msg);
            }
        };
        stopForeground(true);
        this.stopSelf();
        super.onDestroy();
        Log.d("MyService", "Destroyed");
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        Log.d("MyService", "Task Removed");
        super.onTaskRemoved(rootIntent);
        //do something you want
        //stop service
        stopForeground(true);
        this.stopSelf();
    }

    private void getAppList() {
        PackageManager pm = getPackageManager();
        // Return a List of all packages that are installed on the device.
        List<PackageInfo> packages = pm.getInstalledPackages(0);
        for (PackageInfo packageInfo : packages) {
            // 判断系统/非系统应用
            if ((packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 0) // 非系统应用
            {
                String packageName = packageInfo.packageName;
                System.out.println("MainActivity.getAppList, packageInfo=" + packageName);
                forbidApps.add(packageName);
            } else {
                // 系统应用
            }
        }
    }

    /**
     * 打开“有权查看使用情况的应用”
     * Android 5.0以后版本
     */
    public void goToAndroidSettings(){
        //打开--com.android.settings
        Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }

    /**
     * 获取栈顶应用程序--包名
     * @return
     */
    @TargetApi(Build.VERSION_CODES.CUPCAKE)
    @SuppressLint("NewApi")
    private String getTaskPackname() {
        boolean isNoSwitch = isNoSwitch();
        Log.e("Android", "isNoSwitch=: " + isNoSwitch);

        String currentApp = "CurrentNULL";
        //LOLLIPOP = API 21,Android 5.0
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {

            UsageStatsManager usm = (UsageStatsManager) this.getSystemService(Context.USAGE_STATS_SERVICE);
            long time = System.currentTimeMillis();
            List<UsageStats> appList = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, time - 1000 * 1000, time);


            //5.1以上，如果不打开此设置，queryUsageStats获取到的是size为0的list
//            if(isFirst||(!isNoSwitch())||appList.size() == 0 || appList == null){
            if((!isNoSwitch())&&isFirst){
                isFirst = false;
                goToAndroidSettings();
            }else{
                SortedMap<Long, UsageStats> mySortedMap = new TreeMap<Long, UsageStats>();
                for (UsageStats usageStats : appList) {
                    mySortedMap.put(usageStats.getLastTimeUsed(), usageStats);
                }
                if (mySortedMap != null && !mySortedMap.isEmpty()) {
                    currentApp = mySortedMap.get(mySortedMap.lastKey()).getPackageName();
                }
            }
        } else {
            ActivityManager am = (ActivityManager) this.getSystemService(Context.ACTIVITY_SERVICE);
            List<ActivityManager.RunningAppProcessInfo> tasks = am.getRunningAppProcesses();
            currentApp = tasks.get(0).processName;
        }
//        if(currentTop.equals(currentApp))
//            currentApp = "currentDup";
//        else {
//            currentTop = currentApp;
//        }
        Log.e("TAG", "Current App in foreground is: " + currentApp);
        return currentApp;
    }

    /**
     * 判断当前设备中有没有 “有权查看使用权限的应用” 这个选项
     * @return
     */
    private boolean isNoOption() {
        PackageManager packageManager = getApplicationContext().getPackageManager();
        Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
        List<ResolveInfo> list = packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
        return list.size() > 0;
    }

    /**
     * 判断调用该设备中“有权查看使用权限的应用”这个选项的APP有没有打开
     * @return  此APP打开这个选项，就返回true
     */
    private boolean isNoSwitch() {
        long ts = System.currentTimeMillis();
        UsageStatsManager usageStatsManager = (UsageStatsManager) getApplicationContext().getSystemService(Context.USAGE_STATS_SERVICE);
        List<UsageStats> queryUsageStats = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_BEST, 0, ts);
        if (queryUsageStats == null || queryUsageStats.isEmpty()) {
            return false;
        }
        return true;
    }

}
