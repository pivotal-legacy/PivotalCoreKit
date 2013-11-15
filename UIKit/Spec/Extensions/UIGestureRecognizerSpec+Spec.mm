#import "SpecHelper.h"
#import "UIGestureRecognizer+Spec.h"
#import "Target.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIGestureRecognizer_SpecSpec)

describe(@"UIGestureRecognizerSpec", ^{
    __block UITapGestureRecognizer *recognizer;
    __block Target *target;
    __block UIView *view;

    beforeEach(^{
        [UIGestureRecognizer whitelistClassForGestureSnooping:[Target class]];
        view = [[[UIView alloc] init] autorelease];
        target = [[[Target alloc] init] autorelease];
        spy_on(target);

        recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(hello)] autorelease];
        [view addGestureRecognizer:recognizer];
    });

    describe(@"when initialized with a target", ^{
        it(@"calls the target action when recognized", ^{
            target should_not have_received(@selector(hello));
            [recognizer recognize];
            target should have_received(@selector(hello));
        });

        describe(@"when the view containing the gesture recognizer is hidden", ^{
            beforeEach(^{
                view.hidden = YES;
            });

            it(@"raises an exception", ^{
                ^{
                    [recognizer recognize];
                } should raise_exception.with_reason(@"Can't recognize when in a hidden view");
            });
        });

        describe(@"when the gesture recognizer is disabled", ^{
            beforeEach(^{
                recognizer.enabled = NO;
            });

            it(@"raises an exception", ^{
                ^{
                    [recognizer recognize];
                } should raise_exception.with_reason(@"Can't recognize when recognizer is disabled");
            });
        });
    });

    describe(@"when additional targets are set", ^{
        __block Target *newTarget;
        beforeEach(^{
            newTarget = [[[Target alloc] init] autorelease];
            spy_on(newTarget);
            [recognizer addTarget:newTarget action:@selector(goodbye)];
        });

        it(@"calls the additional target action when recognized", ^{
            newTarget should_not have_received(@selector(goodbye));
            [recognizer recognize];
            newTarget should have_received(@selector(goodbye));
        });
    });

    describe(@"when a target that takes the recognizer as an argument is set", ^{
        __block Target *newTarget;
        beforeEach(^{
            newTarget = [[[Target alloc] init] autorelease];
            spy_on(newTarget);
            [recognizer addTarget:newTarget action:@selector(ciao:)];
        });

        it(@"calls the additional target action when recognized", ^{
            newTarget should_not have_received(@selector(ciao:));
            [recognizer recognize];
            newTarget should have_received(@selector(ciao:)).with(recognizer);
        });
    });

    describe(@"when initialized without a target or action", ^{
        it(@"should not raise", ^{
            UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:nil action:nil] autorelease];
            ^{
                [recognizer recognize];
            } should_not raise_exception;
        });
    });

    describe(@"removing targets", ^{
        beforeEach(^{
            [recognizer removeTarget:target action:@selector(hello)];
        });

        it(@"should not call the action on the removed target", ^{
            [recognizer recognize];
            target should_not have_received(@selector(hello));
        });
    });

    describe(@"cleaning up the installed whitelist", ^{
        __block Target *aTarget;
        __block UITapGestureRecognizer *resetRecognizer;

        beforeEach(^{
            [UIGestureRecognizer whitelistClassForGestureSnooping:[Target class]];
            UIView *aView = [[[UIView alloc] init] autorelease];
            aTarget = [[[Target alloc] init] autorelease];
            spy_on(aTarget);

            resetRecognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
            [aView addGestureRecognizer:resetRecognizer];

        });

        it(@"removes the registered whitelist of gesture recognizer targets when Cedar calls afterEach", ^{
            [UIGestureRecognizer afterEach];
            [resetRecognizer addTarget:aTarget action:@selector(hello)];
            [resetRecognizer recognize];
            aTarget should_not have_received(@selector(hello));
        });
    });
});

SPEC_END
