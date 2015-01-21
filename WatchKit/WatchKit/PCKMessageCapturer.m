#import "PCKMessageCapturer.h"


@interface PCKMessageCapturer ()

@property (nonatomic) NSMutableArray *sent_messages;

@end


@implementation PCKMessageCapturer

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
    [anInvocation retainArguments];
    [_sent_messages addObject:anInvocation];
}

@end
