#import "SpecHelper.h"
#import "UIPopoverController+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

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
    
    describe(@"+currentPopoverController", ^{
        describe(@"when the popoverController is presented from rect", ^{
            beforeEach(^{
                UIView *presentingView = [[UIView alloc] initWithFrame:(CGRect){.size.width = 200, .size.height = 200}];
                UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [window addSubview:presentingView];
                
                [popoverController presentPopoverFromRect:CGRectMake(20, 20, 30, 30)
                                                   inView:presentingView
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
            });
            
            it(@"returns the popoverController", ^{
                [UIPopoverController currentPopoverController] should be_same_instance_as(popoverController);
            });
        });
        
        describe(@"when the popoverController is presented from a bar button item", ^{
            beforeEach(^{
                UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
                UIToolbar *toolbar = [[UIToolbar alloc] init];
                toolbar.items = @[barButtonItem];
                
                UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [window addSubview:toolbar];
                
                [popoverController presentPopoverFromBarButtonItem:barButtonItem
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
            });
            
            it(@"returns the popoverController", ^{
                [UIPopoverController currentPopoverController] should be_same_instance_as(popoverController);
            });
        });
            });
});

SPEC_END
