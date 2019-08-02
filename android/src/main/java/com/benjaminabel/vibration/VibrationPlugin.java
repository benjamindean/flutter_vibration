package com.benjaminabel.vibration;

import android.content.Context;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class VibrationPlugin implements MethodCallHandler {
    private final Vibrator vibrator;
    private static final String CHANNEL = "vibration";

    private VibrationPlugin(Registrar registrar) {
        this.vibrator = (Vibrator) registrar.context().getSystemService(Context.VIBRATOR_SERVICE);
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new VibrationPlugin(registrar));
    }

    private void vibrate(long duration) {
        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createOneShot(duration, VibrationEffect.DEFAULT_AMPLITUDE));
            } else {
                vibrator.vibrate(duration);
            }
        }
    }

    private void vibrate(List<Integer> pattern, int repeat) {
        long[] patternLong = new long[pattern.size()];

        for (int i = 0; i < patternLong.length; i++) {
            patternLong[i] = pattern.get(i).intValue();
        }

        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createWaveform(patternLong, repeat));
            } else {
                vibrator.vibrate(patternLong, repeat);
            }
        }
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
        case "hasVibrator":
            result.success(vibrator.hasVibrator());

            break;
        case "hasAmplitudeControl":
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                result.success(vibrator.hasAmplitudeControl());
            } else {
                // For earlier API levels, return false rather than raising a
                // MissingPluginException in order to allow applications to handle
                // non-existence gracefully.
                result.success(false);
            }

            break;
        case "vibrate":
            int duration = call.argument("duration");
            List<Integer> pattern = call.argument("pattern");
            int repeat = call.argument("repeat");

            if (pattern.size() > 0) {
                vibrate(pattern, repeat);
            } else {
                vibrate(duration);
            }

            result.success(null);

            break;
        case "cancel":
            vibrator.cancel();

            result.success(null);

            break;
        default:
            result.notImplemented();

        }
    }
}
