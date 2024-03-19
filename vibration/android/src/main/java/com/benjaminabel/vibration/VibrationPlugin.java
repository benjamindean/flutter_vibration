package com.benjaminabel.vibration;

import android.content.Context;
import android.os.Build;
import android.os.Vibrator;
import android.os.VibratorManager;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class VibrationPlugin implements FlutterPlugin {
    private static final String CHANNEL = "vibration";
    private MethodChannel methodChannel;

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        teardownChannels();
    }

    @SuppressWarnings("deprecation")
    public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
        final VibrationPlugin vibrationPlugin = new VibrationPlugin();

        vibrationPlugin.setupChannels(registrar.messenger(), registrar.context());
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        setupChannels(binding.getBinaryMessenger(), binding.getApplicationContext());
    }

    private void setupChannels(BinaryMessenger messenger, Context context) {
        Vibrator vibrator;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            VibratorManager vibratorManager = (VibratorManager) context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE);
            vibrator = vibratorManager.getDefaultVibrator();
        } else {
            vibrator = (Vibrator) context.getSystemService(Context.VIBRATOR_SERVICE);
        }
        final VibrationMethodChannelHandler methodChannelHandler = new VibrationMethodChannelHandler(new Vibration(vibrator));

        this.methodChannel = new MethodChannel(messenger, CHANNEL);
        this.methodChannel.setMethodCallHandler(methodChannelHandler);
    }

    private void teardownChannels() {
        this.methodChannel.setMethodCallHandler(null);
        this.methodChannel = null;
    }
}