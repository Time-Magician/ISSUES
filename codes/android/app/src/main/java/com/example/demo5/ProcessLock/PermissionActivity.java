package com.example.demo5.ProcessLock;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Settings;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;

import com.example.demo5.MainActivity;
import com.example.demo5.R;

public class PermissionActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        showNormalDialog();
    }

    private void showNormalDialog(){
        /* @setIcon 设置对话框图标
         * @setTitle 设置对话框标题
         * @setMessage 设置对话框消息提示
         * setXXX方法返回Dialog对象，因此可以链式设置属性
         */
        final AlertDialog.Builder normalDialog =
                new AlertDialog.Builder(PermissionActivity.this,AlertDialog.THEME_DEVICE_DEFAULT_LIGHT);
        normalDialog.setTitle("需要授权");
        normalDialog.setMessage("为了应用能够正常运行，需要您授予以下权限：通知权限、自动启动权限、查看使用情况权限、允许后台运行。");
        normalDialog.setPositiveButton("去授权",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);
                        Uri packageURI = Uri.parse("package:" + "com.example.demo5");
                        intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,packageURI);
                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);
                        finish();
                    }
                });
        normalDialog.setNegativeButton("已授权",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        finish();
                    }
                });
        // 显示
        normalDialog.show();
    }
}
