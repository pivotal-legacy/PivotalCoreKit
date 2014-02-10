#import "SpecHelper.h"
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

    describe(@"+animateWithDuration:animations:completion:", ^{
        subjectAction(^{
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
    });

    describe(@"+animateWithDuration:delay:options:animations:completion:", ^{
        subjectAction(^{
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

SPEC_END
