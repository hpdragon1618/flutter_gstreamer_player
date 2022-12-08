#import "FlutterGstreamerPlayerPlugin.h"
#if __has_include(<flutter_gstreamer_player/flutter_gstreamer_player-Swift.h>)
#import <flutter_gstreamer_player/flutter_gstreamer_player-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_gstreamer_player-Swift.h"
#endif

@implementation FlutterGstreamerPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterGstreamerPlayerPlugin registerWithRegistrar:registrar];
}
@end
