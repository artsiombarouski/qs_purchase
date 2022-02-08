#import "QsPurchasePlugin.h"
#if __has_include(<qs_purchase/qs_purchase-Swift.h>)
#import <qs_purchase/qs_purchase-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "qs_purchase-Swift.h"
#endif

@implementation QsPurchasePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQsPurchasePlugin registerWithRegistrar:registrar];
}
@end
