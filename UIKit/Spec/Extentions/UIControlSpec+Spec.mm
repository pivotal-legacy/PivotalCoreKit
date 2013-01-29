#import "SpecHelper.h"
#import "UIControl+Spec.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface Target : NSObject
@property (nonatomic) BOOL wasCalled;
- (void)callMe;
@end

@implementation Target
- (void)callMe {
    self.wasCalled = YES;
}
@end

void (^expectFailureWithMessage)(NSString *, CDRSpecBlock) = ^(NSString *message, CDRSpecBlock block) {
    @try {
        block();
    }
    @catch (NSException *x) {
        if (![message isEqualToString:x.reason]) {
            NSString *reason = [NSString stringWithFormat:@"Expected failure message: <%@> but received failure message <%@>", message, x.reason];
            [[CDRSpecFailure specFailureWithReason:reason] raise];
        }
        return;
    }

    fail(@"Expectation should have failed.");
};

SPEC_BEGIN(UIControl_SpecSpec)

describe(@"UIControlSpec", ^{
    __block UIButton *button;
    __block UISlider *slider;
    __block Target *target;

    beforeEach(^{
        target = [[[Target alloc] init] autorelease];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        slider = [[[UISlider alloc] init] autorelease];
        [slider addTarget:target action:@selector(callMe) forControlEvents:UIControlEventValueChanged];
        [button addTarget:target action:@selector(callMe) forControlEvents:UIControlEventTouchUpInside];
    });

    describe(@"-slideTo:", ^{
        beforeEach(^{
            slider.hidden = NO;
            slider.enabled = YES;
        });

        context(@"when visible and enabled", ^{
            it(@"should send control actions", ^{
                [slider slideTo:0.5f];
                target.wasCalled should be_truthy;
            });
        });

        context(@"when visible and disabled", ^{
            beforeEach(^{
                slider.enabled = NO;
            });

            it(@"should cause a spec failure", ^{
                expectFailureWithMessage(@"Can't slide a disabled control", ^{
                    [slider slideTo:0.5f];
                });
            });

            it(@"should not send control actions", ^{
                target.wasCalled should equal(NO);
            });
        });

        context(@"when not visible", ^{
            beforeEach(^{
                slider.hidden = YES;
            });

            it(@"should cause a spec failure", ^{
                expectFailureWithMessage(@"Can't slide an invisible control", ^{
                    [slider slideTo:0.5f];
                });
            });

            it(@"should not send control actions", ^{
                target.wasCalled should equal(NO);
            });
        });
    });

    describe(@"-tap", ^{
        beforeEach(^{
            button.hidden = NO;
            button.enabled = YES;
        });

        context(@"when visible and enabled", ^{
            it(@"should send control actions", ^{
                [button tap];
                target.wasCalled should be_truthy;
            });
        });

        context(@"when visible and disabled", ^{
            beforeEach(^{
                button.enabled = NO;
            });

            it(@"should cause a spec failure", ^{
                expectFailureWithMessage(@"Can't tap a disabled control", ^{
                    [button tap];
                });
            });

            it(@"should not send control actions", ^{
                target.wasCalled should equal(NO);
            });
        });

        context(@"when not visible", ^{
            beforeEach(^{
                button.hidden = YES;
            });

            it(@"should cause a spec failure", ^{
                expectFailureWithMessage(@"Can't tap an invisible control", ^{
                    [button tap];
                });
            });

            it(@"should not send control actions", ^{
                target.wasCalled should equal(NO);
            });
        });
    });
});

SPEC_END
