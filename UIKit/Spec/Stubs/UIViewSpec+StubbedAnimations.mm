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
    });

    describe(@"with animations paused", ^{
        __block BOOL completionBlockParameter;

        beforeEach(^{
            [UIView pauseAnimations];
            [UIView animateWithDuration:0.666 animations:^{
                animationBlockCalled = YES;
            } completion:^(BOOL finished) {
                completionBlockCalled = YES;
                completionBlockParameter = finished;
            }];
        });

        it(@"should not execute the the animation block", ^{
            animationBlockCalled should be_falsy;
        });

        it(@"should not execute the completion block", ^{
            completionBlockCalled should be_falsy;
        });

        it(@"should records the animation", ^{
            [[UIView lastAnimation] duration] should equal(0.666);
        });

        describe(@"running animations", ^{
            beforeEach(^{
                [[UIView lastAnimation] animate];
            });

            it(@"should run the animation block", ^{
                animationBlockCalled should be_truthy;
            });
        });

        describe(@"completing", ^{
            beforeEach(^{
                [[UIView lastAnimation] animate];
                [[UIView lastAnimation] complete];
            });

            it(@"should run the completion block with YES", ^{
                completionBlockCalled should be_truthy;
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
});

SPEC_END
