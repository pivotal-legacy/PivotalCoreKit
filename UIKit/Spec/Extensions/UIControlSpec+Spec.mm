#import "SpecHelper.h"
#import "UIControl+Spec.h"
#import "Target.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(UIControl_SpecSpec)

describe(@"UIControlSpec", ^{
    __block UIButton *button;
    __block Target *target;

    beforeEach(^{
        target = [[[Target alloc] init] autorelease];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:target action:@selector(callMe) forControlEvents:UIControlEventTouchUpInside];
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
                ^{
                    [button tap];
                } should raise_exception.with_reason(@"Can't tap a disabled control");
            });

            it(@"should not send control actions", ^{
                @try {
                    [button tap];
                } @catch(NSException *e) { }
                target.wasCalled should equal(NO);
            });
        });

        context(@"when not visible", ^{
            beforeEach(^{
                button.hidden = YES;
            });

            it(@"should cause a spec failure", ^{
                ^{
                    [button tap];
                } should raise_exception.with_reason(@"Can't tap an invisible control");
            });

            it(@"should not send control actions", ^{
                @try {
                    [button tap];
                } @catch(NSException *e) { }
                target.wasCalled should equal(NO);
            });
        });
    });
});

SPEC_END
