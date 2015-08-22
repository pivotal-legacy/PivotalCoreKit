#import "CDRSpecHelper.h"
#import "UISlider+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UISlider_SpecSpec)

describe(@"UISlider+Spec", ^{
    __block UISlider *slider;
    __block NSMutableArray *target;

    beforeEach(^{
        target = [NSMutableArray array];
        spy_on(target);
        slider = [[UISlider alloc] init];
        [slider addTarget:target action:@selector(removeAllObjects) forControlEvents:UIControlEventValueChanged];
    });

    describe(@"-slideTo:", ^{
        beforeEach(^{
            slider.hidden = NO;
            slider.enabled = YES;
        });

        context(@"when visible and enabled", ^{
            it(@"should send control actions", ^{
                [slider slideTo:0.5f];
                target should have_received("removeAllObjects");
            });
        });

        context(@"when visible and disabled", ^{
            beforeEach(^{
                slider.enabled = NO;
            });

            it(@"should cause a spec failure", ^{
                ^{
                    [slider slideTo:0.5f];
                } should raise_exception.with_reason(@"Can't slide a disabled control");
            });

            it(@"should not send control actions", ^{
                @try {
                    [slider slideTo:0.5f];
                } @catch(NSException *e) { }
                target should_not have_received("removeAllObjects");
            });
        });

        context(@"when not visible", ^{
            beforeEach(^{
                slider.hidden = YES;
            });

            it(@"should cause a spec failure", ^{
                ^{
                    [slider slideTo:0.5f];
                } should raise_exception.with_reason(@"Can't slide an invisible control");
            });

            it(@"should not send control actions", ^{
                @try {
                    [slider slideTo:0.5f];
                } @catch(NSException *e) { }
                target should_not have_received("removeAllObjects");
            });
        });
    });
});

SPEC_END
