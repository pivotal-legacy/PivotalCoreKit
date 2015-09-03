#import "Cedar.h"
#import <WatchKit/WatchKit.h>


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceDateSpec)

describe(@"WKInterfaceDate", ^{
    __block WKInterfaceDate *subject;

    beforeEach(^{
        subject = [[WKInterfaceDate alloc] init];
    });

    describe(@"setters", ^{
        it(@"should record the invocation for setTextColor:", ^{
            [subject setTextColor:[UIColor blueColor]];

            subject should have_received(@selector(setTextColor:)).with([UIColor blueColor]);
        });

        it(@"should record the invocation for setTimeZone:", ^{
            NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            [subject setTimeZone:timeZone];

            subject should have_received(@selector(setTimeZone:)).with(timeZone);
        });

        it(@"should record the invocation for setCalendar:", ^{
            NSCalendar *calendar = [NSCalendar new];
            [subject setCalendar:calendar];

            subject should have_received(@selector(setCalendar:)).with(calendar);
        });
    });
});

SPEC_END
