package com.benjaminabel.vibration;

import android.os.Build;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class VibrationMethodChannelHandler implements MethodChannel.MethodCallHandler {
    private final Vibration vibration;

    VibrationMethodChannelHandler(Vibration vibrationPlugin) {
        assert (vibrationPlugin != null);
        this.vibration = vibrationPlugin;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "hasAmplitudeControl":
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    result.success(vibration.getVibrator().hasAmplitudeControl());
                } else {
                    // For earlier API levels, return false rather than raising a
                    // MissingPluginException in order to allow applications to handle
                    // non-existence gracefully.
                    result.success(false);
                }

                break;
            case "hasCustomVibrationsSupport":
                result.success(true);

                break;
            case "vibrate":
                int duration = call.argument("duration");
                List<Integer> pattern = call.argument("pattern");
                int repeat = call.argument("repeat");
                List<Integer> intensities = call.argument("intensities");
                int amplitude = call.argument("amplitude");

                if (pattern.size() > 0 && intensities.size() > 0) {
                    vibration.vibrate(pattern, repeat, intensities);
                } else if (pattern.size() > 0) {
                    vibration.vibrate(pattern, repeat);
                } else {
                    vibration.vibrate(duration, amplitude);
                }

                result.success(null);

                break;
            case "cancel":
                vibration.getVibrator().cancel();

                result.success(null);

                break;
            default:
                result.notImplemented();
        }
    }
}