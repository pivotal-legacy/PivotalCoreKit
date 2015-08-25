#import "WKExtension.h"

@implementation WKExtension

static WKExtension *sharedExtension;

+ (WKExtension *)sharedExtension {
    if (!_sharedExtension){
        _sharedExtension = [[WKExtension alloc] init];
    }
    return _sharedExtension;
}

+ (void)afterEach {
    _sharedExtension = nil;
}

- (void)openSystemURL:(NSURL *)url {
    [super openSystemURL:url];
}

@end