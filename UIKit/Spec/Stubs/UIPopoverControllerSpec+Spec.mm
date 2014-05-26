#import "SpecHelper.h"
#import "UIPopoverController+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface SpecPopoverBackgroundView : UIPopoverBackgroundView
@end

@implementation SpecPopoverBackgroundView
@end

SPEC_BEGIN(UIPopoverControllerSpecExtensionsSpec)

describe(@"UIPopoverController (spec extensions)", ^{
    __block UIPopoverController *popoverController;
    __block UIViewController *contentViewController;

    afterEach(^{
        stop_spying_on([UIDevice currentDevice]);
    });

    beforeEach(^{
        spy_on([UIDevice currentDevice]);
        [UIDevice currentDevice] stub_method(@selector(userInterfaceIdiom)).and_return(UIUserInterfaceIdiomPad);

        contentViewController = [[UIViewController alloc] init];
        popoverController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];

        popoverController should_not be_nil;
    });

    describe(@"stubbed methods", ^{
        describe(@"when the popoverController is presented from rect", ^{
            beforeEach(^{
                UIView *presentingView = [[UIView alloc] initWithFrame:(CGRect){.size.width = 200, .size.height = 200}];

                [popoverController presentPopoverFromRect:CGRectMake(20, 20, 30, 30)
                                                   inView:presentingView
                                 permittedArrowDirections:UIPopoverArrowDirectionLeft
                                                 animated:YES];
            });

            it(@"+currentPopoverController returns the popoverController", ^{
                [UIPopoverController currentPopoverController] should be_same_instance_as(popoverController);
            });

            it(@"is visible", ^{
                popoverController.isPopoverVisible should be_truthy;
            });

            it(@"popover arrow direction is left", ^{
                popoverController.popoverArrowDirection should equal(UIPopoverArrowDirectionLeft);
            });

            describe(@"when a popoverController is then dismissed", ^{
                beforeEach(^{
                    [popoverController dismissPopoverAnimated:NO];
                });

                it(@"+currentPopoverController returns nil", ^{
                    [UIPopoverController currentPopoverController] should be_nil;
                });

                it(@"is not visible", ^{
                    popoverController.isPopoverVisible should be_falsy;
                });
            });

            describe(@"+reset", ^{
                beforeEach(^{
                    [UIPopoverController reset];
                });

                it(@"clears the currentPopoverController", ^{
                    [UIPopoverController currentPopoverController] should be_nil;
                });
            });
        });

        describe(@"when the popoverController is presented from a bar button item", ^{
            beforeEach(^{
                UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
                UIToolbar *toolbar = [[UIToolbar alloc] init];
                toolbar.items = @[barButtonItem];
                [popoverController presentPopoverFromBarButtonItem:barButtonItem
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
            });

            it(@"+currentPopoverController returns the popoverController", ^{
                [UIPopoverController currentPopoverController] should be_same_instance_as(popoverController);
            });
        });
    });

    describe(@"methods that should continue to work", ^{
        describe(@"-contentViewController", ^{
            it(@"should be set to content view controller", ^{
                popoverController.contentViewController should be_same_instance_as(contentViewController);
            });
        });

        describe(@"-setContentViewController:animated:", ^{
            __block UIViewController *newContentViewController;

            beforeEach(^{
                newContentViewController = [[UIViewController alloc] init];

                [popoverController setContentViewController:newContentViewController animated:YES];
            });

            it(@"changes contentViewController to newContentViewController", ^{
                popoverController.contentViewController should be_same_instance_as(newContentViewController);
            });
        });

        describe(@"-setPopoverContentSize:animated:", ^{
            beforeEach(^{
                [popoverController setPopoverContentSize:CGSizeMake(400, 500) animated:YES];
            });

            it(@"changes the popoverContentSize", ^{
                popoverController.popoverContentSize should equal(CGSizeMake(400, 500));
            });
        });

        describe(@"setting passthrough views", ^{
            __block UIView *view;
            beforeEach(^{
                view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 400)];

                popoverController.passthroughViews = @[view];
            });

            it(@"changes the passthroughViews", ^{
                popoverController.passthroughViews should contain(view);
            });
        });

        describe(@"setting the delegate", ^{
            __block id <UIPopoverControllerDelegate> delegate;
            beforeEach(^{
                delegate = nice_fake_for(@protocol(UIPopoverControllerDelegate));
                popoverController.delegate = delegate;
            });

            it(@"changes the delegate", ^{
                popoverController.delegate should be_same_instance_as(delegate);
            });
        });

        describe(@"-popoverLayoutMargins", ^{
            it(@"should returns the default layout margins", ^{
                popoverController.popoverLayoutMargins should equal(UIEdgeInsetsMake(30, 10, 10, 10));
            });
        });

        describe(@"setting the popover layout margins", ^{
            beforeEach(^{
                popoverController.popoverLayoutMargins = UIEdgeInsetsMake(5, 10, 15, 20);
            });

            it(@"changes the popoverLayoutMargins", ^{
                popoverController.popoverLayoutMargins should equal(UIEdgeInsetsMake(5, 10, 15, 20));
            });
        });

        describe(@"setting the popover background view class", ^{
            beforeEach(^{
                popoverController.popoverBackgroundViewClass = [SpecPopoverBackgroundView class];
            });

            it(@"changes the popoverBackgroundViewClass", ^{
                popoverController.popoverBackgroundViewClass should equal([SpecPopoverBackgroundView class]);
            });
        });

        describe(@"setting the background color", ^{
            beforeEach(^{
                if ([popoverController respondsToSelector:@selector(backgroundColor)]) {
                    popoverController.backgroundColor = [UIColor magentaColor];
                }
            });

            it(@"changes the backgroundColor", ^{
                if ([popoverController respondsToSelector:@selector(backgroundColor)]) {
                    popoverController.backgroundColor should equal([UIColor magentaColor]);
                }
            });
        });
    });
});

SPEC_END
