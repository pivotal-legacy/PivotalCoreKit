#import "Cedar.h"
#import "UITabBarController+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UITabBarController_Spec)

describe(@"UITabBarController_Spec", ^{
    __block UITabBarController *controller;
    __block id<UITabBarControllerDelegate, CedarDouble> delegate;
    __block UIViewController *viewController0, *viewController1;
    beforeEach(^{
        controller = [[UITabBarController alloc] init];

        delegate = fake_for(@protocol(UITabBarControllerDelegate));
        controller.delegate = delegate;

        viewController0 = [[UIViewController alloc] init];
        viewController1 = [[UIViewController alloc] init];
        controller.viewControllers = @[viewController0, viewController1];
    });

    describe(@"tapping tabs", ^{
        beforeEach(^{
            controller.selectedIndex should equal(0);
            controller.selectedViewController should be_same_instance_as(viewController0);
        });

        subjectAction(^{ [controller tapTabAtIndex:1]; });

        context(@"when the delegate says it should be selected", ^{
            beforeEach(^{
                delegate stub_method(@selector(tabBarController:shouldSelectViewController:))
                .with(controller).and_with(viewController1)
                .and_return(YES);
            });

            it(@"should select the tab", ^{
                controller.selectedIndex should equal(1);
            });

            it(@"should select the controller", ^{
                controller.selectedViewController should be_same_instance_as(viewController1);
            });

            context(@"when the delegate wants to know", ^{
                beforeEach(^{
                    delegate stub_method(@selector(tabBarController:didSelectViewController:));
                });

                it(@"should tell the delegate", ^{
                    delegate should have_received(@selector(tabBarController:didSelectViewController:));
                });
            });

            context(@"when the delegate doesn't care", ^{
                beforeEach(^{
                    delegate stub_method(@selector(respondsToSelector:))
                    .with(@selector(tabBarController:didSelectViewController:))
                    .and_return(NO);
                });

                it(@"should not tell the delegate", ^{
                    delegate should_not have_received(@selector(tabBarController:didSelectViewController:));
                });
            });
        });

        context(@"when the delegate says it should not be selected", ^{
            __block NSUInteger previouslySelectedTab;
            beforeEach(^{
                previouslySelectedTab = controller.selectedIndex;
                delegate stub_method(@selector(tabBarController:shouldSelectViewController:)).and_return(NO);
            });

            it(@"doesn't select it", ^{
                controller.selectedIndex should equal(previouslySelectedTab);
                controller.selectedViewController should equal(viewController0);
            });
        });

        context(@"when the delegate doesn't care if it should be selected", ^{
            it(@"should select the tab", ^{
                controller.selectedIndex should equal(1);
            });

            context(@"when the delegate wants to know", ^{
                beforeEach(^{
                    delegate stub_method(@selector(tabBarController:didSelectViewController:));
                });

                it(@"should tell the delegate", ^{
                    delegate should have_received(@selector(tabBarController:didSelectViewController:));
                });
            });
        });
    });
});

SPEC_END
