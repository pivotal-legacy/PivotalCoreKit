#import "CDRSpecHelper.h"
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

            describe(@"when the gesture recognizer is not added to a view", ^{
                beforeEach(^{
                    [view removeGestureRecognizer:recognizer];
                });

                it(@"raises an exception", ^{
                    ^{ [recognizer recognize]; } should raise_exception.with_reason(@"Can't recognize when not in a view");
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

        describe(@"managing state", ^{
            __block UIGestureRecognizerState capturedState;

            beforeEach(^{
                target stub_method(@selector(ciao:)).and_do_block(^(UIGestureRecognizer *gestureRecognizer) {
                    capturedState = gestureRecognizer.state;
                });
                [recognizer addTarget:target action:@selector(ciao:)];
            });

            context(@"before the recognizer has recognized a gesture", ^{
                it(@"should have the UIGestureRecognizerStatePossible state", ^{
                    recognizer.state should equal(UIGestureRecognizerStatePossible);
                });
            });

            context(@"once the recoginzer has recognized a gesture, while the actions are being performed", ^{
                it(@"should have the UIGestureRecognizerStateRecognized state", ^{
                    [recognizer recognize];
                    capturedState should equal(UIGestureRecognizerStateRecognized);
                    capturedState should equal(UIGestureRecognizerStateEnded);
                });
            });

            context(@"once the recognizer has completed recognizing a gesture", ^{
                it(@"should reset the state to UIGestureRecognizerStatePossible", ^{
                    [recognizer recognize];
                    recognizer.state should equal(UIGestureRecognizerStatePossible);
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
    });

    context(@"for a gesture recognizer created in code", ^{
        beforeEach(^{
            recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(hello)] autorelease];
            [view addGestureRecognizer:recognizer];
        });

        itShouldBehaveLike(@"triggering a gesture recognizer");

        describe(@"removing targets", ^{
            __block Target *secondTarget;

            beforeEach(^{
                secondTarget = [[[Target alloc] init] autorelease];
                spy_on(secondTarget);
                [recognizer addTarget:target action:@selector(secondAction)];
                [recognizer addTarget:secondTarget action:@selector(hello)];
            });

            context(@"when the target and action are both explicitly specified", ^{
                beforeEach(^{
                    [recognizer removeTarget:target action:@selector(hello)];
                    [recognizer recognize];
                });

                it(@"should not call the action on the removed target", ^{
                    target should_not have_received(@selector(hello));
                });

                it(@"should call the remaining action on the target", ^{
                    target should have_received(@selector(secondAction));
                });

                it(@"should call the action on the remaining targets", ^{
                    secondTarget should have_received(@selector(hello));
                });
            });

            context(@"when the target is nil and the action is explicitly specified", ^{
                beforeEach(^{
                    [recognizer removeTarget:nil action:@selector(hello)];
                    [recognizer recognize];
                });

                it(@"should not call the actions on any targets", ^{
                    target should_not have_received(@selector(hello));
                    target should_not have_received(@selector(secondAction));
                    secondTarget should_not have_received(@selector(hello));
                });
            });

            context(@"when the target is explicitly specified and the action is NULL", ^{
                beforeEach(^{
                    [recognizer removeTarget:target action:NULL];
                    [recognizer recognize];
                });

                it(@"should not call the actions on target", ^{
                    target should_not have_received(@selector(hello));
                    target should_not have_received(@selector(secondAction));
                });

                it(@"should call the action on secondTarget", ^{
                    secondTarget should have_received(@selector(hello));
                });
            });

            context(@"when the target is nil and the action is NULL", ^{
                beforeEach(^{
                    [recognizer removeTarget:nil action:NULL];
                    [recognizer recognize];
                });

                it(@"should not call the actions on any targets", ^{
                    target should_not have_received(@selector(hello));
                    target should_not have_received(@selector(secondAction));
                    secondTarget should_not have_received(@selector(hello));
                });
            });
        });

        describe(@"when initialized without a target or action", ^{
            it(@"should not raise", ^{
                UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:nil action:nil] autorelease];
                [view addGestureRecognizer:recognizer];
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

        describe(@"removing targets", ^{
            sharedExamplesFor(@"not calling the action on the target", ^(NSDictionary *sharedContext) {
                it(@"should not call the action on the removed target", ^{
                    [recognizer recognize];
                    target should_not have_received(@selector(hello));
                });
            });

            context(@"when the target and action are both explicitly specified", ^{
                beforeEach(^{
                    [recognizer removeTarget:target action:@selector(hello)];
                });

                itShouldBehaveLike(@"not calling the action on the target");
            });

            context(@"when the target is nil and the action is explicitly specified", ^{
                beforeEach(^{
                    [recognizer removeTarget:nil action:@selector(hello)];
                });

                itShouldBehaveLike(@"not calling the action on the target");
            });

            context(@"when the target is explicitly specified and the action is NULL", ^{
                beforeEach(^{
                    [recognizer removeTarget:target action:NULL];
                });

                itShouldBehaveLike(@"not calling the action on the target");
            });

            context(@"when the target is nil and the action is NULL", ^{
                beforeEach(^{
                    [recognizer removeTarget:nil action:NULL];
                });

                itShouldBehaveLike(@"not calling the action on the target");
            });
        });
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
