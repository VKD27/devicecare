#import "DeviceCarePlugin.h"
#if __has_include(<devicecare/devicecare-Swift.h>)
#import <devicecare/devicecare-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "devicecare-Swift.h"
#endif

@implementation DeviceCarePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeviceCarePlugin registerWithRegistrar:registrar];
}
@end
