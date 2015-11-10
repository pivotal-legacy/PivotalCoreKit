#import "Cedar.h"
#import "PCKMessageCapturer.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface PCKSpecMessageCapturer : PCKMessageCapturer
- (void)setBurgled:(NSString *)burgleStatus;
+ (void)setBlargled:(NSString *)blargleStatus;
@end
@implementation PCKSpecMessageCapturer
- (void)setBurgled:(NSString *)burgleStatus { }
+ (void)setBlargled:(NSString *)blargleStatus { }
@end

SPEC_BEGIN(PCKMessageCapturerSpec)

describe(@"PCKMessageCapturer", ^{
    __block PCKSpecMessageCapturer *subject;

    beforeEach(^{
        subject = [[PCKSpecMessageCapturer alloc] init];
    });

    describe(@"resetting messages sent to an instance", ^{
        beforeEach(^{
            [subject setBurgled:@"burgle-burgle"];
            [subject reset_sent_messages];
        });

        it(@"should not hold onto any more sent messages", ^{
            [subject sent_messages] should be_empty;
        });

        it(@"should have declared that it received the selector", ^{
            subject should_not have_received(@selector(setBurgled:));
        });
    });

    describe(@"resetting messages sent to the class", ^{
        beforeEach(^{
            [PCKSpecMessageCapturer setBlargled:@"bargle-bargle"];
            [subject reset_sent_messages];
        });

        afterEach(^{
            stop_spying_on([PCKSpecMessageCapturer class]);
        });

        it(@"should not hold onto any more sent messages", ^{
            [PCKSpecMessageCapturer sent_class_messages] should be_empty;
        });

        it(@"should not have_received the selector anymore", ^{
            [PCKSpecMessageCapturer class] should_not have_received(@selector(setBlargled:));
        });
    });
});

SPEC_END

@implementation PCKMessageCapturer (HaveReceivedMatcherSupport)
+ (NSArray *)sent_messages {
    return [self sent_class_messages];
}
@end
