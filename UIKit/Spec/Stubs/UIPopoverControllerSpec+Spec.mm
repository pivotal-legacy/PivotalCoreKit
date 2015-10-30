#import "Cedar.h"
#import "UIPopoverController+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface SpecPopoverBackgroundView : UIPopoverBackgroundView
@end

@implementation SpecPopoverBackgroundView
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

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
                UINavigationItem *navItem = [[UINavigationItem alloc] init];
                navItem.rightBarButtonItem = barButtonItem;
                UINavigationBar *navBar = [[UINavigationBar alloc] init];
                navBar.items = @[navItem];

                [popoverController presentPopoverFromBarButtonItem:barButtonItem
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
            });

            it(@"+currentPopoverController returns the popoverController", ^{
                [UIPopoverController currentPopoverController] should be_same_instance_as(popoverController);
            });
        });
    });
});

SPEC_END

#pragma clang diagnostic pop
