#import "Cedar.h"
#import "UIKit+PivotalSpecHelperStubs.h"

@interface CustomActivity : UIActivity
@end

@implementation CustomActivity
- (NSString *)activityTitle {
    return @"Custom Activity";
}
@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIActivityViewControllerSpecExtensionsSpec)

describe(@"UIActivityViewController (spec extensions)", ^{
    __block UIActivityViewController *activityViewController;


    beforeEach(^{
        NSArray *activityItems = @[ @"activity item 1", [NSURL URLWithString:@"github.com/pivotal/PivotalCoreKit"] ];
        CustomActivity *activity = [[CustomActivity alloc] init];
        activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[ activity ]];
    });

    describe(@"-activityItems", ^{
        it(@"should return the set activities", ^{
            activityViewController.activityItems should equal(@[ @"activity item 1", [NSURL URLWithString:@"github.com/pivotal/PivotalCoreKit"] ]);
        });
    });

    describe(@"-applicationActivites", ^{
        it(@"should return the set application activities", ^{
            activityViewController.applicationActivities.count should equal(1);
            [activityViewController.applicationActivities.lastObject activityTitle] should equal(@"Custom Activity");
        });
    });

    describe(@"accessing a modally presented activity view controller", ^{
        __block UIViewController *presentingViewController;

        beforeEach(^{
            presentingViewController = [[UIViewController alloc] init];
            [presentingViewController presentViewController:activityViewController animated:NO completion:nil];
        });

        it(@"should return the set values", ^{
            [(UIActivityViewController *)presentingViewController.presentedViewController activityItems] should equal(@[ @"activity item 1", [NSURL URLWithString:@"github.com/pivotal/PivotalCoreKit"] ]);
        });
    });
});

SPEC_END
