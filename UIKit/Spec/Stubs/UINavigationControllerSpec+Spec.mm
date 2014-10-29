#import <UIKit/UIKit.h>
#import <Cedar-iOS.h>

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface CustomNavigationBar : UINavigationBar
@end

@implementation CustomNavigationBar
@end

@interface CustomToolbar : UIToolbar
@end

@implementation CustomToolbar
@end

SPEC_BEGIN(UINavigationControllerSpecExtensionsSpec)

describe(@"UINavigationController (spec extensions)", ^{
    __block UINavigationController *navigationController;
    __block id<UINavigationControllerDelegate> navigationControllerDelegate;
    __block UIViewController *rootViewController;
    __block UIViewController *pushedViewController;

    sharedExamplesFor(@"a stubbed navigation controller", ^(NSDictionary *sharedContext) {
        it(@"should add to the stack when pushed", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            navigationController.viewControllers.count should equal(2);
            navigationController.topViewController should be_same_instance_as(pushedViewController);
            navigationController.visibleViewController should be_same_instance_as(pushedViewController);
        });

        it(@"should message the delegate when pushing onto the navigation stack", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            navigationControllerDelegate should have_received(@selector(navigationController:willShowViewController:animated:)).with(navigationController, pushedViewController, YES);
            navigationControllerDelegate should have_received(@selector(navigationController:didShowViewController:animated:)).with(navigationController, pushedViewController, YES);
        });

        it(@"should remove from the stack when popped", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            [navigationController popViewControllerAnimated:YES];

            navigationController.viewControllers.count should equal(1);
            navigationController.topViewController should be_same_instance_as(rootViewController);
            navigationController.visibleViewController should be_same_instance_as(rootViewController);
        });

        it(@"should message the delegate when popping a controller off of the navigation stack", ^{
            [navigationController pushViewController:pushedViewController animated:YES];
            [navigationController popViewControllerAnimated:YES];

            navigationControllerDelegate should have_received(@selector(navigationController:willShowViewController:animated:)).with(navigationController, rootViewController, YES);
            navigationControllerDelegate should have_received(@selector(navigationController:didShowViewController:animated:)).with(navigationController, rootViewController, YES);
        });

        it(@"should pop to a particular controller with the rest of the navigation stack intact", ^{
            UIViewController *middleController = [[UIViewController alloc] init];

            [navigationController pushViewController:middleController animated:YES];
            [navigationController pushViewController:pushedViewController animated:YES];

            [navigationController popToViewController:middleController animated:YES];

            navigationController.viewControllers.count should equal(2);

            navigationController.topViewController should be_same_instance_as(middleController);
            navigationController.visibleViewController should be_same_instance_as(middleController);
        });

        it(@"should message the delegate when popping to a particular view controller in the navigation stack", ^{
            UIViewController *middleController = [[UIViewController alloc] init];

            [navigationController pushViewController:middleController animated:YES];
            [navigationController pushViewController:pushedViewController animated:YES];

            [(id<CedarDouble>)navigationControllerDelegate reset_sent_messages];
            [navigationController popToViewController:middleController animated:YES];

            navigationControllerDelegate should have_received(@selector(navigationController:willShowViewController:animated:)).with(navigationController, middleController, YES);
            navigationControllerDelegate should have_received(@selector(navigationController:didShowViewController:animated:)).with(navigationController, middleController, YES);
        });

        it(@"should pop to the root controller", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            [navigationController popToRootViewControllerAnimated:YES];

            navigationController.viewControllers.count should equal(1);
            navigationController.visibleViewController should be_same_instance_as(rootViewController);
            navigationController.topViewController should be_same_instance_as(rootViewController);
        });

        it(@"should message the delegate when popping to the root controller", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            [navigationController popToRootViewControllerAnimated:YES];

            navigationControllerDelegate should have_received(@selector(navigationController:willShowViewController:animated:)).with(navigationController, rootViewController, YES);
            navigationControllerDelegate should have_received(@selector(navigationController:didShowViewController:animated:)).with(navigationController, rootViewController, YES);
        });

        it(@"should blow up when popping to a controller which isn't in the navigation stack", ^{
            [navigationController pushViewController:pushedViewController animated:YES];
            ^{ [navigationController popToViewController:[[UIViewController alloc] init] animated:NO]; } should raise_exception;
        });

        it(@"should return the expected visible view controller when a controller is presented modally", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            UIViewController *presentedViewController = [[UIViewController alloc] init];
            [pushedViewController presentViewController:presentedViewController animated:NO completion:nil];

            navigationController.topViewController should be_same_instance_as(pushedViewController);
            navigationController.visibleViewController should be_same_instance_as(presentedViewController);
        });

        it(@"should return the expected visible view controller when the navigation controller presents a view controller modally", ^{
            UIViewController *presentedViewController = [[UIViewController alloc] init];
            [navigationController presentViewController:presentedViewController animated:NO completion:nil];

            navigationController.topViewController should be_same_instance_as(rootViewController);
            navigationController.visibleViewController should be_same_instance_as(presentedViewController);
        });

        it(@"should return the view controller presented by a view controller in the middle of the navigation stack", ^{
            UIViewController *middleViewController = [[UIViewController alloc] init];
            [navigationController pushViewController:middleViewController animated:NO];
            [navigationController pushViewController:pushedViewController animated:NO];

            UIViewController *presentedViewController = [[UIViewController alloc] init];
            [middleViewController presentViewController:presentedViewController animated:NO completion:nil];

            navigationController.topViewController should be_same_instance_as(pushedViewController);
            navigationController.visibleViewController should be_same_instance_as(presentedViewController);
        });
    });

    beforeEach(^{
        rootViewController = [[UIViewController alloc] init];
        pushedViewController = [[UIViewController alloc] init];
        navigationControllerDelegate = nice_fake_for(@protocol(UINavigationControllerDelegate));
    });

    context(@"a navigation controller created with a root view controller", ^{
        beforeEach(^{
            navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
            navigationController.delegate = navigationControllerDelegate;
            [navigationController view];
        });

        itShouldBehaveLike(@"a stubbed navigation controller");
    });

    context(@"a navigation controller created with nav bar and toolbar classes", ^{
        beforeEach(^{
            navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[CustomNavigationBar class] toolbarClass:[CustomToolbar class]];
            [navigationController pushViewController:rootViewController animated:YES];
            navigationController.delegate = navigationControllerDelegate;
            [navigationController view];
        });

        it(@"should have a navigation bar with the specified class", ^{
            navigationController.navigationBar should be_instance_of([CustomNavigationBar class]);
        });

        it(@"should have a toolbar with the specified class", ^{
            navigationController.toolbar should be_instance_of([CustomToolbar class]);
        });

        itShouldBehaveLike(@"a stubbed navigation controller");
    });

    context(@"a navigation controller created within a storyboard", ^{
        beforeEach(^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NavigationStackExample" bundle:nil];
            navigationController = [storyboard instantiateInitialViewController];
            navigationController.delegate = navigationControllerDelegate;
            rootViewController = navigationController.visibleViewController;
            [navigationController view];
        });

        it(@"should have the root view controller specified in the storyboard", ^{
            navigationController.visibleViewController should be_instance_of([UITableViewController class]);
        });

        itShouldBehaveLike(@"a stubbed navigation controller");
    });
});

SPEC_END
