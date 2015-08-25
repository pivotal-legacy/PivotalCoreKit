#import "WKExtension.h"

@interface PCKMessageCapturer ()
- (void)openSystemURL:(NSURL *)URL NS_REQUIRES_SUPER;
@end

@implementation WKExtension

static WKExtension *sharedExtension;

+ (WKExtension *)sharedExtension {
    if (!sharedExtension){
        sharedExtension = [[WKExtension alloc] init];
    }
    return sharedExtension;
}

+ (void)afterEach {
    sharedExtension = nil;
}

- (void)openSystemURL:(NSURL *)url {
    [super openSystemURL:url];
}

@end