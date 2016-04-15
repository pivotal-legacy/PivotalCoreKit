#import "PCKMessageCapturer.h"
#import <objc/runtime.h>

@implementation PCKMessageCapturer {
    NSMutableArray *_sent_messages;
}

static NSMutableArray *sent_class_messages_array;

#pragma mark - NSObject

+ (void)load {
    id cedarHooksProtocol = NSProtocolFromString(@"CDRHooks");
    if (cedarHooksProtocol) {
        class_addProtocol(self, cedarHooksProtocol);
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sent_messages = [NSMutableArray array];
    }
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation retainArguments];
    [_sent_messages addObject:anInvocation];
}

- (void)reset_sent_messages {
    [_sent_messages removeAllObjects];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if (!sent_class_messages_array) {
        sent_class_messages_array = [NSMutableArray array];
    }
    [sent_class_messages_array addObject:anInvocation];
}

+ (NSArray *)sent_class_messages
{
    return sent_class_messages_array;
}

+ (void)reset_sent_messages {
    [sent_class_messages_array removeAllObjects];
}

+ (void)afterEach
{
    sent_class_messages_array = [NSMutableArray array];
}

@end
