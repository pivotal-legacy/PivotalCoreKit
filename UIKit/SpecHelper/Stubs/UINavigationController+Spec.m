#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
#error This file should be be compiled with ARC disabled
#endif

@implementation UINavigationController (Spec)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *viewControllers = [self.viewControllers arrayByAddingObject:viewController];
    [self updateViewControllers:viewControllers animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated {
    NSArray *viewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, self.viewControllers.count - 1)];
    [self updateViewControllers:viewControllers animated:animated];
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSUInteger idx = [self.viewControllers indexOfObject:viewController];
    if (idx != NSNotFound) {
        NSArray *viewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, idx + 1)];
        [self updateViewControllers:viewControllers animated:animated];
    } else {
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Can't pop to a controller which isn't in the stack" userInfo:@{}] raise];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *viewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, 1)];
    [self updateViewControllers:viewControllers animated:animated];
}

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

- (void)updateViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.delegate navigationController:self willShowViewController:viewControllers.lastObject animated:animated];
    }

    [self setViewControllers:viewControllers animated:animated];

    if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.delegate navigationController:self didShowViewController:viewControllers.lastObject animated:animated];
    }
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]];
}

@end
