#import "WCSession.h"

@interface PCKMessageCapturer ()

-(void)activateSession NS_REQUIRES_SUPER;
+(BOOL)isSupported NS_REQUIRES_SUPER;
- (BOOL)updateApplicationContext:(NSDictionary<NSString *, id> *)applicationContext error:(NSError **)error NS_REQUIRES_SUPER;

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

-(void)activateSession{
    [super activateSession];
}

+(BOOL)isSupported{
   return [super isSupported];
}

- (BOOL)updateApplicationContext:(NSDictionary<NSString *, id> *)applicationContext error:(NSError **)error {
    return [super updateApplicationContext:applicationContext error:error];
}

@end