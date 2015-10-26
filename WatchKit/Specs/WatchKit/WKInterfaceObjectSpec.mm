#import "Cedar.h"
#import <WatchKit/WatchKit.h>


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(WKInterfaceObjectSpec)

describe(@"WKInterfaceObject", ^{
    __block WKInterfaceObject *subject;

    beforeEach(^{
        subject = [[WKInterfaceObject alloc] init];
    });

    describe(@"setters", ^{
        it(@"should record the invocation for setHidden:", ^{
            [subject setHidden:YES];
            subject should have_received(@selector(setHidden:)).with(YES);
        });

        it(@"should record the invocation for setAlpha:", ^{
            CGFloat alpha = 0.5;
            [subject setAlpha:alpha];
            subject should have_received(@selector(setAlpha:)).with(alpha);
        });

        it(@"should record the invocation for setWidth:", ^{
            CGFloat width = 1.5;
            [subject setWidth:width];
            subject should have_received(@selector(setWidth:)).with(width);
        });

        it(@"should record the invocation for setHeight:", ^{
            CGFloat height = 1.7;
            [subject setHeight:height];
            subject should have_received(@selector(setHeight:)).with(height);
        });
    });

    describe(@"getters", ^{
        it(@"should allow reading the most recently-set value for setHidden:", ^{
            [subject setHidden:YES];
            [subject isHidden] should be_truthy;
        });

        it(@"should allow reading the most recently-set value for setAlpha:", ^{
            CGFloat alpha = 0.3;
            [subject setAlpha:alpha];
            [subject alpha] should equal(alpha);
        });

        it(@"should allow reading the most recently-set value for setWidth:", ^{
            CGFloat width = 50;
            [subject setWidth:width];
            [subject width] should equal(width);
        });

        it(@"should allow reading the most recently-set value for setHeight:", ^{
            CGFloat height = 30;
            [subject setHeight:height];
            [subject height] should equal(height);
        });
    });
});

SPEC_END
