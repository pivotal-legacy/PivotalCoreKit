#import "WCSession.h"

@interface PCKMessageCapturer ()

-(void)activateSession NS_REQUIRES_SUPER;
+(BOOL)isSupported NS_REQUIRES_SUPER;
- (BOOL)updateApplicationContext:(NSDictionary<NSString *, id> *)applicationContext error:(NSError **)error NS_REQUIRES_SUPER;
-(void)sendMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler errorHandler:(void (^)(NSError * _Nonnull))errorHandler NS_REQUIRES_SUPER;

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

-(void)sendMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler errorHandler:(void (^)(NSError * _Nonnull))errorHandler{
    [super sendMessage:message replyHandler:replyHandler errorHandler:errorHandler];
}

@end