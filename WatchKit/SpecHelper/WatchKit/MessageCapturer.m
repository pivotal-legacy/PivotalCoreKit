#import "MessageCapturer.h"


@interface MessageCapturer ()

@property (nonatomic) NSMutableArray *sent_messages;

@end


@implementation MessageCapturer

#pragma mark - NSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sent_messages = [NSMutableArray array];
    }
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [_sent_messages addObject:anInvocation];
}

@end
