#import "VibrationPlugin.h"
#import "Vibration.h"

@implementation VibrationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [Vibration registerWithRegistrar:registrar];
}
@end
