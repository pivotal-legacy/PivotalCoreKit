#import "Cedar.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface CustomNavigationBar : UINavigationBar
@end

@implementation CustomNavigationBar
@end

#if !TARGET_OS_TV
@interface CustomToolbar : UIToolbar
@end

@implementation CustomToolbar
@end
#endif

/*!
 * The test which uses this fails on iOS 8.x / 64-bit.
 *
 * Radar filed & confirmed fixed in iOS 9+.
 */
bool hasAssertBug() {
    bool has = false;
#ifndef __IPHONE_9_0
#if __LP64__
    has = true;
#endif
#endif
    return has;
};


SPEC_BEGIN(UINavigationControllerSpecExtensionsSpec)

describe(@"UINavigationController (spec extensions)", ^{
    __block UINavigationController *navigationController;
    __block UIViewController *rootViewController;
    __block UIViewController *pushedViewController;

    sharedExamplesFor(@"a stubbed navigation controller", ^(NSDictionary *sharedContext) {
        beforeEach(^{
            NSAssertionHandler *assertionHandler = [NSAssertionHandler currentHandler];
            spy_on(assertionHandler);

            assertionHandler stub_method(@selector(handleFailureInMethod:object:file:lineNumber:description:)).and_raise_exception();
        });

        afterEach(^{
            NSAssertionHandler *assertionHandler = [NSAssertionHandler currentHandler];
            stop_spying_on(assertionHandler);
        });

        it(@"should add to the stack when pushed", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            navigationController.viewControllers.count should equal(2);
            navigationController.topViewController should be_same_instance_as(pushedViewController);
            navigationController.visibleViewController should be_same_instance_as(pushedViewController);
        });

        it(@"should remove from the stack when popped", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            [navigationController popViewControllerAnimated:YES];

            navigationController.viewControllers.count should equal(1);
            navigationController.topViewController should be_same_instance_as(rootViewController);
            navigationController.visibleViewController should be_same_instance_as(rootViewController);
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

        it(@"should pop to the root controller", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            [navigationController popToRootViewControllerAnimated:YES];

            navigationController.viewControllers.count should equal(1);
            navigationController.visibleViewController should be_same_instance_as(rootViewController);
            navigationController.topViewController should be_same_instance_as(rootViewController);
        });


        it(@"should blow up when popping to a controller which isn't in the navigation stack", hasAssertBug() ? (CDRSpecBlock)nil : ^{
            [navigationController pushViewController:pushedViewController animated:YES];
            ^{ [navigationController popToViewController:[[UIViewController alloc] init] animated:NO]; } should raise_exception;
        });

        it(@"should return the expected visible view controller when a controller is presented modally", ^{
            [navigationController pushViewController:pushedViewController animated:YES];

            UIViewController *presentedViewController = [[UIViewController alloc] init];
            [pushedViewController presentViewController:presentedViewController animated:YES completion:nil];

            navigationController.topViewController should be_same_instance_as(pushedViewController);
            navigationController.visibleViewController should be_same_instance_as(presentedViewController);
        });

        it(@"should return the expected visible view controller when the navigation controller presents a view controller modally", ^{
            UIViewController *presentedViewController = [[UIViewController alloc] init];
            [navigationController presentViewController:presentedViewController animated:YES completion:nil];

            navigationController.topViewController should be_same_instance_as(rootViewController);
            navigationController.visibleViewController should be_same_instance_as(presentedViewController);
        });

        it(@"should return the view controller presented by a view controller in the middle of the navigation stack", ^{
            UIViewController *middleViewController = [[UIViewController alloc] init];
            [navigationController pushViewController:middleViewController animated:YES];
            [navigationController pushViewController:pushedViewController animated:YES];

            UIViewController *presentedViewController = [[UIViewController alloc] init];
            [middleViewController presentViewController:presentedViewController animated:YES completion:nil];

            navigationController.topViewController should be_same_instance_as(pushedViewController);
            navigationController.visibleViewController should be_same_instance_as(presentedViewController);
        });

        it(@"should allow setting the view controllers it presents with animation", ^{
            UIViewController *firstViewController = [[UIViewController alloc] init];
            UIViewController *secondViewController = [[UIViewController alloc] init];
            UIViewController *thirdViewController = [[UIViewController alloc] init];
            NSArray *viewControllers = @[firstViewController, secondViewController, thirdViewController];

            [navigationController setViewControllers:viewControllers animated:YES];
            navigationController.viewControllers should equal(viewControllers);
        });
    });

    __block UIWindow *window;
    beforeEach(^{
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];

        rootViewController = [[UIViewController alloc] init];
        pushedViewController = [[UIViewController alloc] init];
    });

    context(@"a navigation controller created with a root view controller", ^{
        beforeEach(^{
            navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
            window.rootViewController = navigationController;
            [navigationController view];
        });

        itShouldBehaveLike(@"a stubbed navigation controller");
    });

    context(@"a navigation controller created with nav bar and toolbar classes", ^{
#if TARGET_OS_TV
        Class toolbarClass = Nil;
#else
        Class toolbarClass = [CustomToolbar class];
#endif

        beforeEach(^{
            navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[CustomNavigationBar class] toolbarClass:toolbarClass];
            window.rootViewController = navigationController;

            [navigationController pushViewController:rootViewController animated:YES];
            [navigationController view];
        });

        it(@"should have a navigation bar with the specified class", ^{
            navigationController.navigationBar should be_instance_of([CustomNavigationBar class]);
        });

#if !TARGET_OS_TV
        it(@"should have a toolbar with the specified class", ^{
            navigationController.toolbar should be_instance_of(toolbarClass);
        });
#endif

        itShouldBehaveLike(@"a stubbed navigation controller");
    });

    context(@"a navigation controller created within a storyboard", ^{
        beforeEach(^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NavigationStackExample" bundle:nil];
            navigationController = [storyboard instantiateInitialViewController];
            window.rootViewController = navigationController;

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
