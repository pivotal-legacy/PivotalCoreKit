#import "Cedar.h"
#import "UIView+StubbedAnimation.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIView_StubbedAnimations)

describe(@"UIView+StubbedAnimation", ^{
    __block BOOL animationBlockCalled;
    __block BOOL completionBlockCalled;

    beforeEach(^{
        animationBlockCalled = NO;
        completionBlockCalled = NO;
    });

    describe(@"with animations not paused", ^{
        describe(@"+animateWithDuration:animations:", ^{
            beforeEach(^{
                [UIView animateWithDuration:0.666 animations:^{
                    animationBlockCalled = YES;
                }];
            });

            it(@"should call the animation block", ^{
                animationBlockCalled should be_truthy;
            });

            it(@"should remember the duration", ^{
                [UIView lastAnimationDuration] should be_close_to(.666);
            });
        });

        describe(@"+animateWithDuration:animations:completion:", ^{
            beforeEach(^{
                [UIView animateWithDuration:0.666 animations:^{
                    animationBlockCalled = YES;
                } completion:^(BOOL finished) {
                    completionBlockCalled = YES;
                }];
            });

            it(@"should call the animation block", ^{
                animationBlockCalled should be_truthy;
            });

            it(@"should call the completion block", ^{
                completionBlockCalled should be_truthy;
            });

            it(@"should remember the duration", ^{
                [UIView lastAnimationDuration] should be_close_to(.666);
            });
        });

        describe(@"+animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:", ^{
            beforeEach(^{
                [UIView animateWithDuration:0.666 delay:10 usingSpringWithDamping:176 initialSpringVelocity:117 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    animationBlockCalled = YES;
                } completion:^(BOOL finished) {
                    completionBlockCalled = YES;
                }];
            });

            it(@"should call the animation block", ^{
                animationBlockCalled should be_truthy;
            });

            it(@"should call the completion block", ^{
                completionBlockCalled should be_truthy;
            });

            it(@"should remember the damping ratio", ^{
                [UIView lastAnimationSpringWithDamping] should be_close_to(176);
            });

            it(@"should remember the initial spring velocity", ^{
                [UIView lastAnimationInitialSpringVelocity] should be_close_to(117);
            });

            it(@"should remember the duration", ^{
                [UIView lastAnimationDuration] should be_close_to(.666);
            });

            it(@"should remember the delay", ^{
                [UIView lastAnimationDelay] should be_close_to(10);
            });

            it(@"should remember the options", ^{
                [UIView lastAnimationOptions] should equal(UIViewAnimationOptionTransitionCrossDissolve);
            });
        });

        describe(@"+animateWithDuration:delay:options:animations:completion:", ^{
            beforeEach(^{
                [UIView animateWithDuration:0.666 delay:10
                                    options:UIViewAnimationOptionTransitionFlipFromBottom
                                 animations:^{
                                     animationBlockCalled = YES;
                                 } completion:^(BOOL finished) {
                                     completionBlockCalled = YES;
                                 }];
            });

            it(@"should remember the duration", ^{
                [UIView lastAnimationDuration] should be_close_to(.666);
            });

            it(@"should remember the delay", ^{
                [UIView lastAnimationDelay] should be_close_to(10);
            });

            it(@"should remember the options", ^{
                [UIView lastAnimationOptions] should equal(UIViewAnimationOptionTransitionFlipFromBottom);
            });

            it(@"should call the animation block", ^{
                animationBlockCalled should be_truthy;
            });

            it(@"should call the completion block", ^{
                completionBlockCalled should be_truthy;
            });
        });

        describe(@"+transitionWithView:duration:options:animations:completion:", ^{
            UIView *view = [[UIView alloc] init];

            beforeEach(^{
                [UIView transitionWithView:view
                                  duration:0.666
                                   options:UIViewAnimationOptionTransitionFlipFromBottom
                                animations:^{
                                    animationBlockCalled = YES;
                                }
                                completion:^(BOOL finished) {
                                    completionBlockCalled = YES;
                                }];
            });

            it(@"should remember the view", ^{
                [UIView lastWithView] should be_same_instance_as(view);
            });

            it(@"should remember the duration", ^{
                [UIView lastAnimationDuration] should be_close_to(.666);
            });

            it(@"should remember the options", ^{
                [UIView lastAnimationOptions] should equal(UIViewAnimationOptionTransitionFlipFromBottom);
            });

            it(@"should call the animation block", ^{
                animationBlockCalled should be_truthy;
            });

            it(@"should call the completion block", ^{
                completionBlockCalled should be_truthy;
            });
        });

        describe(@"+transitionFromView:toView:duration:options:completion:", ^{
            UIView *fromView = [[UIView alloc] init];
            UIView *toView = [[UIView alloc] init];

            beforeEach(^{
                [UIView transitionFromView:fromView
                                    toView:toView
                                  duration:0.666
                                   options:UIViewAnimationOptionTransitionFlipFromBottom
                                completion:^(BOOL finished) {
                                    completionBlockCalled = YES;
                                }];
            });

            it(@"should remember the from view", ^{
                [UIView lastFromView] should be_same_instance_as(fromView);
            });

            it(@"should remember the to view", ^{
                [UIView lastToView] should be_same_instance_as(toView);
            });

            it(@"should remember the duration", ^{
                [UIView lastAnimationDuration] should be_close_to(.666);
            });

            it(@"should remember the options", ^{
                [UIView lastAnimationOptions] should equal(UIViewAnimationOptionTransitionFlipFromBottom);
            });

            it(@"should call the completion block", ^{
                completionBlockCalled should be_truthy;
            });
        });
    });

    describe(@"with animations paused", ^{
        __block BOOL completionBlockParameter;

        beforeEach(^{
            [UIView pauseAnimations];
        });

        sharedExamplesFor(@"not executing animation or completion", ^(NSDictionary *sharedContext) {
            it(@"should not execute the the animation block", ^{
                animationBlockCalled should be_falsy;
            });

            it(@"should not execute the completion block", ^{
                completionBlockCalled should be_falsy;
            });
        });

        sharedExamplesFor(@"completing, reseting and cancelling", ^(NSDictionary *sharedContext) {
            it(@"should record the animation duration", ^{
                [[UIView lastAnimation] duration] should equal(0.666);
            });

            it(@"should reset all animations if +reset is called", ^{
                [UIView resetAnimations];

                animationBlockCalled should be_falsy;
                completionBlockCalled should be_falsy;
                [UIView animations] should be_empty;
            });

            describe(@"completing", ^{
                beforeEach(^{
                    [[UIView lastAnimation] complete];
                });

                it(@"should run the completion block with YES", ^{
                    completionBlockParameter should be_truthy;
                });
            });

            describe(@"cancelling", ^{
                beforeEach(^{
                    [[UIView lastAnimation] cancel];
                });

                it(@"should call the completion block with NO", ^{
                    completionBlockCalled should be_truthy;
                    completionBlockParameter should be_falsy;
                });
            });
        });

        sharedExamplesFor(@"resuming with animation block", ^(NSDictionary *sharedContext) {
            it(@"should resume all queued up animations when resume is called", ^{
                [UIView resumeAnimations];

                animationBlockCalled should be_truthy;
                completionBlockCalled should be_truthy;
                [UIView animations] should be_empty;
            });

            describe(@"running animations", ^{
                beforeEach(^{
                    [[UIView lastAnimation] animate];
                });

                it(@"should run the animation block", ^{
                    animationBlockCalled should be_truthy;
                });
            });
        });

        sharedExamplesFor(@"resuming without animation block", ^(NSDictionary *sharedContext) {
            it(@"should resume all queued up animations when resume is called", ^{
                [UIView resumeAnimations];

                completionBlockCalled should be_truthy;
                [UIView animations] should be_empty;
            });
        });

        describe(@"animation", ^{
            beforeEach(^{
                [UIView animateWithDuration:0.666
                                 animations:^{
                                     animationBlockCalled = YES;
                                 }
                                 completion:^(BOOL finished) {
                                     completionBlockCalled = YES;
                                     completionBlockParameter = finished;
                                 }];
            });

            itShouldBehaveLike(@"not executing animation or completion");
            itShouldBehaveLike(@"completing, reseting and cancelling");
            itShouldBehaveLike(@"resuming with animation block");
        });

        describe(@"transition with view", ^{
            __block UIView *view;

            beforeEach(^{
                view = [[UIView alloc] init];

                [UIView transitionWithView:view
                                  duration:0.666
                                   options:UIViewAnimationOptionTransitionFlipFromBottom
                                animations:^{
                                    animationBlockCalled = YES;
                                }
                                completion:^(BOOL finished) {
                                    completionBlockCalled = YES;
                                    completionBlockParameter = finished;
                                }];
            });

            it(@"should record the view", ^{
                [[UIView lastAnimation] withView] should be_same_instance_as(view);
            });

            itShouldBehaveLike(@"not executing animation or completion");
            itShouldBehaveLike(@"completing, reseting and cancelling");
            itShouldBehaveLike(@"resuming without animation block");
        });

        describe(@"transition from view to view", ^{
            __block UIView *fromView;
            __block UIView *toView;

            beforeEach(^{
                fromView = [[UIView alloc] init];
                toView = [[UIView alloc] init];

                [UIView transitionFromView:fromView
                                    toView:toView
                                  duration:0.666
                                   options:UIViewAnimationOptionTransitionFlipFromBottom
                                completion:^(BOOL finished) {
                                    completionBlockCalled = YES;
                                    completionBlockParameter = finished;
                                }];
            });

            it(@"should record the from view", ^{
                [[UIView lastAnimation] fromView] should be_same_instance_as(fromView);
            });

            it(@"should record the to view", ^{
                [[UIView lastAnimation] toView] should be_same_instance_as(toView);
            });

            itShouldBehaveLike(@"not executing animation or completion");
            itShouldBehaveLike(@"completing, reseting and cancelling");
            itShouldBehaveLike(@"resuming without animation block");
        });
    });
});

SPEC_END
