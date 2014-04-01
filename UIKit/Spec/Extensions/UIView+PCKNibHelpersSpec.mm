#import "SpecHelper.h"
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

    it(@"should have subviews as outlets", ^{
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

describe(@"loading a child controller from a parent controller's nib", ^{
    __block MainController *mainController;
    __block ChildViewController *childController;
    beforeEach(^{
        mainController = [[[MainController alloc] init] autorelease];
        [mainController.view layoutIfNeeded];
        childController = mainController.childController;
        [childController.view layoutIfNeeded];
    });

    it(@"should have the child", ^{
        childController should be_instance_of([ChildViewController class]);
    });

    it(@"should correctly position the child", ^{
        CGRectGetMinY(childController.view.frame) should be_close_to(368);
    });

    it(@"should load the child controller's view and bind its outlets", ^{
        childController.helloLabel.text should equal(@"Hello");
    });

    it(@"should constrain the child's children", ^{
        childController.helloLabel.center.x should be_close_to(CGRectGetMidX(childController.view.bounds));
    });
});

SPEC_END
