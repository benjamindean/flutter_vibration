package com.benjaminabel.vibration;

import android.content.Context;
import android.os.Vibrator;
import android.os.Build;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class VibrationPlugin implements FlutterPlugin {
    private static final String CHANNEL = "vibration";
    private MethodChannel methodChannel;

    @SuppressWarnings("deprecation")
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final Vibrator vibrator = (Vibrator) flutterPluginBinding.getApplicationContext().getSystemService(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O ? Context.VIBRATOR_SERVICE : Context.VIBRATOR_MANAGER_SERVICE);
        final VibrationMethodChannelHandler methodChannelHandler = new VibrationMethodChannelHandler(new Vibration(vibrator));

        this.methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL);
        this.methodChannel.setMethodCallHandler(methodChannelHandler);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.methodChannel.setMethodCallHandler(null);
        this.methodChannel = null;
    }
}