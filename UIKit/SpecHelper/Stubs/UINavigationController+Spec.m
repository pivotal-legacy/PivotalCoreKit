#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UINavigationControllerStubbing : NSObject

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector;

@end

@implementation UINavigationControllerStubbing

+ (void)initialize {
    [self redirectSelector:@selector(pushViewController:animated:)
                  forClass:[UINavigationController class]
                        to:@selector(pushViewController:ignoringAnimated:)
             andRenameItTo:@selector(originalPushViewController:animated:)];

    [self redirectSelector:@selector(popViewControllerAnimated:)
                  forClass:[UINavigationController class]
                        to:@selector(popViewControllerIgnoringAnimated:)
             andRenameItTo:@selector(originalPopViewControllerAnimated:)];

    [self redirectSelector:@selector(popToViewController:animated:)
                  forClass:[UINavigationController class]
                        to:@selector(popToViewController:ignoringAnimated:)
             andRenameItTo:@selector(originalPopToViewController:animated:)];

    [self redirectSelector:@selector(popToRootViewControllerAnimated:)
                  forClass:[UINavigationController class]
                        to:@selector(popToRootViewControllerIgnoringAnimated:)
             andRenameItTo:@selector(originalPopToRootViewControllerAnimated:)];
}

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    if ([klass instancesRespondToSelector:renamedSelector]) {
        return;
    }

    Method originalMethod = class_getInstanceMethod(klass, originalSelector);
    class_addMethod(klass, renamedSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));

    Method newMethod = class_getInstanceMethod(klass, newSelector);
    class_replaceMethod(klass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
}

@end

@interface UINavigationController (SpecPrivate)

- (void)originalPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)originalPopViewControllerAnimated:(BOOL)animated;
- (NSArray *)originalPopToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray *)originalPopToRootViewControllerAnimated:(BOOL)animated;

@end

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
