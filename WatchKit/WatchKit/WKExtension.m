#import "WKExtension.h"
#import <objc/runtime.h>

@interface PCKMessageCapturer ()
- (void)openSystemURL:(NSURL *)URL NS_REQUIRES_SUPER;
@end

@interface WKExtension ()
@property (nonatomic, readwrite) WKInterfaceController *rootInterfaceController;
@end

@implementation WKExtension

static WKExtension *__sharedExtension;

+ (void)load {
    id cedarHooksProtocol = NSProtocolFromString(@"CDRHooks");
    if (cedarHooksProtocol) {
        class_addProtocol(self, cedarHooksProtocol);
    }
}

+ (void)setSharedExtension:(WKExtension *)sharedExtension {
    __sharedExtension = sharedExtension;
}

+ (WKExtension *)sharedExtension {
    if (!__sharedExtension){
        __sharedExtension = [[WKExtension alloc] init];
    }
    return __sharedExtension;
}

+ (void)afterEach {
    __sharedExtension = nil;
}

- (void)openSystemURL:(NSURL *)url {
    [super openSystemURL:url];
}

@end