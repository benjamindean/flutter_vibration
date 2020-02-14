//
//  Vibration.m
//  vibration
//
//  Created by 车德超 on 2020/2/14.
//

#import "Vibration.h"
#import <AudioToolbox/AudioToolbox.h>

@interface Vibration ()

@property (nonatomic, assign) bool isDevice;

@end

@implementation Vibration

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"vibration"
            binaryMessenger:[registrar messenger]];
  Vibration* instance = [[Vibration alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.isDevice = (TARGET_OS_SIMULATOR == 0);
  if ([@"hasVibrator" isEqualToString:call.method]) {
      result([[NSNumber alloc] initWithBool:self.isDevice]);
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"hasAmplitudeControl" isEqualToString:call.method]) {
     result([[NSNumber alloc] initWithBool:self.isDevice]);
   } else if ([@"vibrate" isEqualToString:call.method]) {
       AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
       result(nil);
   }else if ([@"cancel" isEqualToString:call.method]) {
       result(nil);
   }else {
    result(FlutterMethodNotImplemented);
  }
}

@end
