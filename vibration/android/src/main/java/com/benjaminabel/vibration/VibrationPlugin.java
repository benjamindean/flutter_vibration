package com.benjaminabel.vibration;

import android.content.Context;
import android.os.Vibrator;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class VibrationPlugin implements FlutterPlugin, MethodCallHandler {
    private static final String CHANNEL = "vibration";
    private MethodChannel methodChannel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final Vibrator vibrator = (Vibrator) flutterPluginBinding.getApplicationContext().getSystemService(Context.VIBRATOR_SERVICE);
        final VibrationMethodChannelHandler methodChannelHandler = new VibrationMethodChannelHandler(new Vibration(vibrator));

        this.methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL);
        this.methodChannel.setMethodCallHandler(methodChannelHandler);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.methodChannel.setMethodCallHandler(null);
        this.methodChannel = null;
    }
}