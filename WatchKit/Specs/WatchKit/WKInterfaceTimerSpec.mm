#import "Cedar.h"
#import <WatchKit/WatchKit.h>


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceTimerSpec)

describe(@"WKInterfaceTimer", ^{
    __block WKInterfaceTimer *subject;

    beforeEach(^{
        subject = [[WKInterfaceTimer alloc] init];
    });

    describe(@"setters", ^{
        it(@"should record the invocation for setTextColor:", ^{
            [subject setTextColor:[UIColor blueColor]];
            subject should have_received(@selector(setTextColor:)).with([UIColor blueColor]);
        });

        it(@"should record the invocation for setDate:", ^{
            [subject setDate:[NSDate dateWithTimeIntervalSince1970:0]];
            subject should have_received(@selector(setDate:)).with([NSDate dateWithTimeIntervalSince1970:0]);
        });

        it(@"should record the invocation for start:", ^{
            [subject start];
            subject should have_received(@selector(start));
        });

        it(@"should record the invocation for stop", ^{
            [subject stop];
            subject should have_received(@selector(stop));
        });
    });

});

SPEC_END
