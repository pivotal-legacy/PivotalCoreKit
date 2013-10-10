#import "SpecHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIView_Spec)

describe(@"UIView+Spec", ^{
    describe(@"+animateWithDuration:animations:completion:", ^{
        __block BOOL animationBlockCalled;
        __block BOOL completionBlockCalled;
        beforeEach(^{
            animationBlockCalled = NO;
            completionBlockCalled = NO;
        });
        
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
});

SPEC_END
