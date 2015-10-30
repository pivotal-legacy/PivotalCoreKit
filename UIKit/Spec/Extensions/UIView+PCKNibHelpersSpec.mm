#import "Cedar.h"
#import "OuterView.h"
#import "InnerView.h"
#import "MainController.h"
#import "ChildViewController.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(UIView_PCKNibHelpers)

describe(@"Using a Nib to load another nib-based view class", ^{
    __block OuterView *outerView;

    beforeEach(^{
        outerView = [[[UINib nibWithNibName:NSStringFromClass([OuterView class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
        [outerView layoutIfNeeded];
    });

    it(@"should have subviews as outlets, and not blow up if the placeholder has a temporary subview", ^{
        outerView.innerView should be_instance_of([InnerView class]);
    });

    it(@"should have the correct layout", ^{
        CGRectGetHeight(outerView.subview.frame) should be_close_to(280.0);
        CGRectGetMaxX(outerView.subview.frame) should be_close_to(CGRectGetMinX(outerView.innerView.frame) - outerView.horizontalSpace.constant);

        CGRectGetWidth(outerView.innerView.frame) should be_close_to(340.0);
        CGRectGetMaxY(outerView.innerView.frame) should be_close_to(CGRectGetMinY(outerView.subview.frame) - outerView.verticalSpace.constant);
    });

    describe(@"loading an inner view with a nib from another nib", ^{
        __block InnerView *innerView;
        beforeEach(^{
            innerView = outerView.innerView;
        });

        it(@"should have its subviews", ^{
            innerView.subview should_not be_nil;
            innerView.anotherSubview should_not be_nil;
        });

        it(@"should have its inner layout and bindings intact", ^{
            innerView.anotherSubview.frame.size should equal(CGSizeMake(50, 50));

            CGRectGetMinX(innerView.subview.frame) should be_close_to(CGRectGetMaxX(innerView.anotherSubview.frame) + innerView.horizontalSpace.constant);
            CGRectGetMinY(innerView.anotherSubview.frame) should be_close_to(CGRectGetMaxY(innerView.subview.frame) + innerView.verticalSpace.constant);
        });
    });
});

SPEC_END
