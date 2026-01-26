package com.benjaminabel.vibration;

import android.content.Context;
import android.os.Vibrator;
import android.os.Build;
import android.os.VibratorManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class VibrationPlugin implements FlutterPlugin {
    private static final String CHANNEL = "vibration";
    private MethodChannel methodChannel;

    @SuppressWarnings("deprecation")
    public Vibrator getVibrator(@NonNull FlutterPluginBinding flutterPluginBinding) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            return getLegacyVibrator(flutterPluginBinding);
        } else {
            try {
                final VibratorManager vibratorManager = (VibratorManager) flutterPluginBinding.getApplicationContext().getSystemService(Context.VIBRATOR_MANAGER_SERVICE);

                return vibratorManager.getDefaultVibrator();
            } catch(NoSuchMethodError | NoClassDefFoundError e) {
                return getLegacyVibrator(flutterPluginBinding);
            }
        }
    }

    private Vibrator getLegacyVibrator(@NonNull FlutterPluginBinding flutterPluginBinding) {
        return (Vibrator) flutterPluginBinding.getApplicationContext().getSystemService(Context.VIBRATOR_SERVICE);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final Vibrator vibrator = this.getVibrator(flutterPluginBinding);
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
