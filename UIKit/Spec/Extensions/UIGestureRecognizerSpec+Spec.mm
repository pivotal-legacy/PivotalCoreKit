#import "SpecHelper.h"
#import "UIGestureRecognizer+Spec.h"
#import "Target.h"

@interface SpecGestureRecognizerViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *recognizer;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *segueRecognizer;
@property (nonatomic, strong) IBOutlet Target *target;
@end
@implementation SpecGestureRecognizerViewController @end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIGestureRecognizer_SpecSpec)

describe(@"UIGestureRecognizerSpec", ^{
    __block UITapGestureRecognizer *recognizer;
    __block Target *target;
    __block UIView *view;

    beforeEach(^{
        view = [[[UIView alloc] init] autorelease];
        target = [[[Target alloc] init] autorelease];
        spy_on(target);
    });

    sharedExamplesFor(@"triggering a gesture recognizer", ^(NSDictionary *sharedContext) {
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

        describe(@"removing targets", ^{
            beforeEach(^{
                [recognizer removeTarget:target action:@selector(hello)];
            });

            it(@"should not call the action on the removed target", ^{
                [recognizer recognize];
                target should_not have_received(@selector(hello));
            });
        });

    });

    context(@"for a gesture recognizer created in code", ^{
        beforeEach(^{
            recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(hello)] autorelease];
            [view addGestureRecognizer:recognizer];
        });

        itShouldBehaveLike(@"triggering a gesture recognizer");

        describe(@"when initialized without a target or action", ^{
            it(@"should not raise", ^{
                UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:nil action:nil] autorelease];
                ^{
                    [recognizer recognize];
                } should_not raise_exception;
            });
        });
    });

    context(@"for a gesture recognizer created in a storyboard", ^{
        __block SpecGestureRecognizerViewController *controller;

        beforeEach(^{
            controller = [[UIStoryboard storyboardWithName:@"UIGestureRecognizer" bundle:nil] instantiateInitialViewController];
            controller.view should_not be_nil;

            view = controller.view;
            target = controller.target;
            spy_on(target);
            recognizer = controller.recognizer;
        });

        itShouldBehaveLike(@"triggering a gesture recognizer");
    });

    context(@"for a segue-triggering gesture recognizer created in a storyboard", ^{
        __block SpecGestureRecognizerViewController *controller;

        beforeEach(^{
            controller = [[UIStoryboard storyboardWithName:@"UIGestureRecognizer" bundle:nil] instantiateInitialViewController];
            controller.view should_not be_nil;
        });

        it(@"should trigger the connected segue when it is recognized", ^{
            [controller.segueRecognizer recognize];
            controller.presentedViewController should_not be_nil;
        });
    });
});

SPEC_END
