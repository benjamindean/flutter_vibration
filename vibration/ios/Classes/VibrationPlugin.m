#import "VibrationPlugin.h"
#if __has_include(<vibration/vibration-Swift.h>)
#import <vibration/vibration-Swift.h>
#else
#import "vibration-Swift.h"
#endif

@implementation VibrationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [VibrationPluginSwift registerWithRegistrar:registrar];
}
@end
