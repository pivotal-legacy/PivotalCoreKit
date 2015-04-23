#import "PCKMessageCapturer.h"

@interface PCKMessageCapturer ()

@property (nonatomic) NSMutableArray *sent_messages;

@end

@implementation PCKMessageCapturer

static  NSMutableArray *sent_class_messages_array;

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

+ (void)afterEach
{
    sent_class_messages_array = [NSMutableArray array];
}

@end
