#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "PCKMethodRedirector.h"

@interface UINavigationController (SpecPrivate)

- (void)originalPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController ignoringAnimated:(BOOL)animated;
- (UIViewController *)originalPopViewControllerAnimated:(BOOL)animated;
- (UIViewController *)popViewControllerIgnoringAnimated:(BOOL)animated;
- (NSArray *)originalPopToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController *)viewController ignoringAnimated:(BOOL)animated;
- (NSArray *)originalPopToRootViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToRootViewControllerIgnoringAnimated:(BOOL)animated;
- (void)setViewControllers:(NSArray *)viewControllers ignoringAnimated:(BOOL)animated;
- (void)originalSetViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

@end

@interface UINavigationControllerStubbing : NSObject
@end

@implementation UINavigationControllerStubbing

+ (void)load {
    [PCKMethodRedirector redirectSelector:@selector(pushViewController:animated:)
                                 forClass:[UINavigationController class]
                                       to:@selector(pushViewController:ignoringAnimated:)
                            andRenameItTo:@selector(originalPushViewController:animated:)];

    [PCKMethodRedirector redirectSelector:@selector(popViewControllerAnimated:)
                                 forClass:[UINavigationController class]
                                       to:@selector(popViewControllerIgnoringAnimated:)
                            andRenameItTo:@selector(originalPopViewControllerAnimated:)];

    [PCKMethodRedirector redirectSelector:@selector(popToViewController:animated:)
                                 forClass:[UINavigationController class]
                                       to:@selector(popToViewController:ignoringAnimated:)
                            andRenameItTo:@selector(originalPopToViewController:animated:)];

    [PCKMethodRedirector redirectSelector:@selector(popToRootViewControllerAnimated:)
                                 forClass:[UINavigationController class]
                                       to:@selector(popToRootViewControllerIgnoringAnimated:)
                            andRenameItTo:@selector(originalPopToRootViewControllerAnimated:)];

    [PCKMethodRedirector redirectSelector:@selector(setViewControllers:animated:)
                                 forClass:[UINavigationController class]
                                       to:@selector(setViewControllers:ignoringAnimated:)
                            andRenameItTo:@selector(originalSetViewControllers:animated:)];
}

@end

#pragma mark -

@implementation UINavigationController (Spec)

- (void)pushViewController:(UIViewController *)viewController ignoringAnimated:(BOOL)animated {
    [self originalPushViewController:viewController animated:NO];
}

- (UIViewController *)popViewControllerIgnoringAnimated:(BOOL)animated {
    return [self originalPopViewControllerAnimated:NO];
}

- (NSArray *)popToViewController:(UIViewController *)viewController ignoringAnimated:(BOOL)animated {
    //NOTE: This should raise an exception if the viewController is nil or not in the navigation stack, but doesn't on 64-bit simulator - http://openradar.appspot.com/18831038
    return [self originalPopToViewController:viewController animated:NO];
}

- (NSArray *)popToRootViewControllerIgnoringAnimated:(BOOL)animated {
    return [self originalPopToRootViewControllerAnimated:NO];
}

- (void)setViewControllers:(NSArray *)viewControllers ignoringAnimated:(BOOL)animated {
    [self originalSetViewControllers:viewControllers animated:NO];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (UIViewController *)visibleViewController {
    if (self.presentedViewController) {
        return self.presentedViewController;
    } else {
        for (UIViewController *viewController in self.viewControllers) {
            if (viewController.presentedViewController) {
                return viewController.presentedViewController;
            }
        }
    }
    return self.topViewController;
}

#pragma clang diagnostic pop

@end
