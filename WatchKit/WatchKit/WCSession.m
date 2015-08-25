#import "WCSession.h"

@interface PCKMessageCapturer ()

@end

@implementation WCSession

static WCSession *defaultSession;

+ (WCSession *)defaultSession {
    if (!defaultSession){
        defaultSession = [[WCSession alloc] init];
    }
    return defaultSession;
}

+ (void)afterEach {
    defaultSession = nil;
}

@end