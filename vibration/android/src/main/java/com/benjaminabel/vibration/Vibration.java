package com.benjaminabel.vibration;

import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.media.AudioAttributes;

import java.util.List;

public class Vibration {
    private final Vibrator vibrator;

    Vibration(Vibrator vibrator) {
        this.vibrator = vibrator;
    }

    @SuppressWarnings("deprecation")
    void vibrate(long duration, int amplitude) {
        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if (vibrator.hasAmplitudeControl()) {
                    vibrator.vibrate(VibrationEffect.createOneShot(duration, amplitude), new AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .build());
                } else {
                    vibrator.vibrate(VibrationEffect.createOneShot(duration, VibrationEffect.DEFAULT_AMPLITUDE), new AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .build());
                }
            } else {
                vibrator.vibrate(duration);
            }
        }
    }

    @SuppressWarnings("deprecation")
    void vibrate(List<Integer> pattern, int repeat) {
        long[] patternLong = new long[pattern.size()];

        for (int i = 0; i < patternLong.length; i++) {
            patternLong[i] = pattern.get(i).intValue();
        }

        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createWaveform(patternLong, repeat), new AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .build());
            } else {
                vibrator.vibrate(patternLong, repeat);
            }
        }
    }

    @SuppressWarnings("deprecation")
    void vibrate(List<Integer> pattern, int repeat, List<Integer> intensities) {
        long[] patternLong = new long[pattern.size()];
        int[] intensitiesArray = new int[intensities.size()];

        for (int i = 0; i < patternLong.length; i++) {
            patternLong[i] = pattern.get(i).intValue();
        }

        for (int i = 0; i < intensitiesArray.length; i++) {
            intensitiesArray[i] = intensities.get(i);
        }

        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if (vibrator.hasAmplitudeControl()) {
                    vibrator.vibrate(VibrationEffect.createWaveform(patternLong, intensitiesArray, repeat), new AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .build());
                } else {
                    vibrator.vibrate(VibrationEffect.createWaveform(patternLong, repeat), new AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .build());
                }
            } else {
                vibrator.vibrate(patternLong, repeat);
            }
        }
    }

    Vibrator getVibrator() {
        return this.vibrator;
    }
}