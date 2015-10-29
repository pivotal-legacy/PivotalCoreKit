#import "Cedar.h"
#import "UIControl+Spec.h"
#import "Target.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(UIControl_SpecSpec)

describe(@"UIControlSpec", ^{
    __block UIButton *button;
    __block Target *target;

    beforeEach(^{
        target = [[Target alloc] init];
        spy_on(target);

        button = [UIButton buttonWithType:UIButtonTypeCustom];

#if TARGET_OS_TV
        UIControlEvents event = UIControlEventPrimaryActionTriggered;
#else
        UIControlEvents event = UIControlEventTouchUpInside;
#endif
        [button addTarget:target action:@selector(hello) forControlEvents:event];
    });

    describe(@"-tap", ^{
        beforeEach(^{
            button.hidden = NO;
            button.enabled = YES;
        });

        context(@"when visible and enabled", ^{
            it(@"should send control actions", ^{
                [button tap];
                target should have_received(@selector(hello));
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
                target should_not have_received(@selector(hello));
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
                target should_not have_received(@selector(hello));
            });
        });
    });
});

SPEC_END
