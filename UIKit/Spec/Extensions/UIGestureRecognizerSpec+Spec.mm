#import "Cedar.h"
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
        view = [[UIView alloc] init];
        target = [[Target alloc] init];
        spy_on(target);
    });

    sharedExamplesFor(@"triggering a gesture recognizer", ^(NSDictionary *sharedContext) {
        describe(@"when initialized with a target", ^{
            void (^sharedRecognition)(SEL, id) = ^(SEL selector, id arguments) {
                it(@"calls the target action when recognized", ^{
                    target should_not have_received(@selector(hello));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [recognizer performSelector:selector withObject:arguments];
#pragma clang diagnostic pop
                    target should have_received(@selector(hello));
                });

                describe(@"when the view containing the gesture recognizer is hidden", ^{
                    beforeEach(^{
                        view.hidden = YES;
                    });

                    it(@"raises an exception", ^{
                        ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                            [recognizer performSelector:selector withObject:arguments];
#pragma clang diagnostic pop
                        } should raise_exception.with_reason(@"Can't recognize when in a hidden view");
                    });
                });

                describe(@"when the gesture recognizer is not added to a view", ^{
                    beforeEach(^{
                        [view removeGestureRecognizer:recognizer];
                    });

                    it(@"raises an exception", ^{
                        ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                            [recognizer performSelector:selector withObject:arguments];
#pragma clang diagnostic pop
                        } should raise_exception.with_reason(@"Can't recognize when not in a view");
                    });
                });

                describe(@"when the gesture recognizer is disabled", ^{
                    beforeEach(^{
                        recognizer.enabled = NO;
                    });

                    it(@"raises an exception", ^{
                        ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                            [recognizer performSelector:selector withObject:arguments];
#pragma clang diagnostic pop
                        } should raise_exception.with_reason(@"Can't recognize when recognizer is disabled");
                    });
                });
            };

            describe(@"-recognize", ^{
                sharedRecognition(@selector(recognize), nil);
            });

            describe(@"-recognizeWithState:", ^{
                sharedRecognition(@selector(recognizeWithState:), @(UIGestureRecognizerStateChanged));
            });
        });

        describe(@"managing state", ^{
            __block UIGestureRecognizerState capturedState;
            __block UIGestureRecognizerState capturedStateUsingKVC;

            beforeEach(^{
                target stub_method(@selector(ciao:)).and_do_block(^(UIGestureRecognizer *gestureRecognizer) {
                    capturedState = gestureRecognizer.state;
                    capturedStateUsingKVC = (UIGestureRecognizerState)[[gestureRecognizer valueForKey:@"state"] integerValue];
                });
                [recognizer addTarget:target action:@selector(ciao:)];
            });

            context(@"before the recognizer has recognized a gesture", ^{
                it(@"should have the UIGestureRecognizerStatePossible state", ^{
                    recognizer.state should equal(UIGestureRecognizerStatePossible);
                });
            });

            context(@"once the recognizer has recognized a gesture, while the actions are being performed", ^{
                context(@"if no state was specified", ^{
                    beforeEach(^{
                        [recognizer recognize];
                    });

                    it(@"should have the UIGestureRecognizerStateRecognized state", ^{
                        capturedState should equal(UIGestureRecognizerStateRecognized);
                        capturedState should equal(UIGestureRecognizerStateEnded);
                    });

                    it(@"should consistently report its state", ^{
                        capturedState should equal(capturedStateUsingKVC);
                    });

                    it(@"should reset the recognizer's state to UIGestureRecognizerStatePossible", ^{
                        recognizer.state should equal(UIGestureRecognizerStatePossible);
                    });

                    it(@"should report the correct state using valueForKey:", ^{
                        [[recognizer valueForKey:@"state"] integerValue] should equal(UIGestureRecognizerStatePossible);
                    });
                });

                context(@"if a state is recognized", ^{
                    beforeEach(^{
                        [recognizer recognizeWithState:UIGestureRecognizerStateBegan];
                    });

                    it(@"should have the specified state", ^{
                        capturedState should equal(UIGestureRecognizerStateBegan);
                    });

                    it(@"should consistently report its state", ^{
                        capturedState should equal(capturedStateUsingKVC);
                    });

                    it(@"should not reset the recognizer's state", ^{
                        recognizer.state should equal(UIGestureRecognizerStateBegan);
                    });

                    it(@"should still report the given state using valueForKey:", ^{
                        [[recognizer valueForKey:@"state"] integerValue] should equal(UIGestureRecognizerStateBegan);
                    });
                });
            });

            context(@"asking the recognizer for it's location in a view", ^{
                beforeEach(^{
                    [recognizer setLocationInView:CGPointMake(5, 5)];
                });

                it(@"should return CGPointZero if mocking is turned off", ^{
                    [recognizer disableLocationInViewMocking];
                    [recognizer locationInView:view] should equal(CGPointZero);
                });

                context(@"with location mocking enabled", ^{
                    beforeEach(^{
                        [recognizer enableLocationInViewMocking];
                    });

                    afterEach(^{
                        [recognizer disableLocationInViewMocking];
                    });

                    context(@"In the view it's stubbed for", ^{
                        it(@"should return the point it was stubbed for", ^{
                            [recognizer locationInView:view] should equal(CGPointMake(5, 5));
                        });
                    });

                    context(@"In a superview of that view", ^{
                        __block UIView *superview;

                        beforeEach(^{
                            superview = [[UIView alloc] init];

                            view.frame = CGRectMake(10, 10, 20, 20);
                            [superview addSubview:view];
                        });

                        it(@"should correctly translate to the superview's coordinate system",^{
                            [recognizer locationInView:superview] should equal(CGPointMake(15, 15));
                        });
                    });

                    context(@"In a subview of that view", ^{
                        __block UIView *subview;

                        beforeEach(^{
                            subview = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];

                            [view addSubview:subview];
                        });

                        it(@"should correctly translate to the subview's coordinate system",^{
                            [recognizer locationInView:subview] should equal(CGPointMake(-5, -5));
                        });
                    });

                    context(@"In a view from an entirely different hierarchy", ^{
                        it(@"raises an exception", ^{
                            UIView *completelyDifferentView = [[UIView alloc] init];

                            ^{
                                [recognizer locationInView:completelyDifferentView];
                            } should raise_exception.with_reason(@"Can't give location in view not related to gesture recognizer's view");
                        });
                    });

                    context(@"With a nil view", ^{
                        context(@"If the view is in a window hierarchy", ^{
                            __block UIWindow *window;
                            beforeEach(^{
                                window = [[UIWindow alloc] init];

                                view.frame = CGRectMake(5, 5, 20, 20);
                                [window addSubview:view];
                            });

                            it(@"should return the point it was stubbed for, translated to the window's coordinate points", ^{
                                [recognizer locationInView:nil] should equal(CGPointMake(10, 10));
                            });
                        });

                        context(@"If the view is not in a window hierarchy", ^{
                            it(@"raises an exception", ^{
                                ^{
                                    [recognizer locationInView:nil];
                                } should raise_exception.with_reason(@"Can't give location in view with no view and gesture recognizer not part of a window hierarchy");
                            });
                        });
                    });
                });
            });
        });

        describe(@"when additional targets are set", ^{
            __block Target *newTarget;
            beforeEach(^{
                newTarget = [[Target alloc] init];
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
                newTarget = [[Target alloc] init];
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
            recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(hello)];
            [view addGestureRecognizer:recognizer];
        });

        itShouldBehaveLike(@"triggering a gesture recognizer");

        it(@"-recognize should not raise", ^{
            UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
            [view addGestureRecognizer:recognizer];
            ^{
                [recognizer recognize];
            } should_not raise_exception;
        });

        it(@"-recognizeWithState: should not raise", ^{
            UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
            [view addGestureRecognizer:recognizer];
            ^{
                [recognizer recognizeWithState:UIGestureRecognizerStateFailed];
            } should_not raise_exception;
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
