#import "VibrationPlugin.h"
#import <vibration/vibration-Swift.h>

@implementation VibrationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVibrationPlugin registerWithRegistrar:registrar];
}
@end
