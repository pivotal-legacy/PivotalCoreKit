#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation UIViewController (Spec)

#pragma mark - Modals

- (void)presentViewController:(UIViewController *)modalViewController animated:(BOOL)animated completion:(void(^)(void))onComplete {
    [self presentModalViewController:modalViewController animated:animated];
    if (onComplete) {
        onComplete();
    }
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    if (self.modalViewController) {
        NSString *errorReason = [NSString stringWithFormat:@"Presenting modal view controller (%@) with other modal (%@) previously active", modalViewController, self.modalViewController];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:errorReason userInfo:nil] raise];
    }

    self.presentedViewController = modalViewController;
    modalViewController.presentingViewController = self;
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    if (self.presentedViewController) {
        objc_setAssociatedObject(self.presentedViewController, @"presentingViewController", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"presentedViewController", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else if (self.presentingViewController) {
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self dismissModalViewControllerAnimated:flag];
    if (completion) {
        completion();
    }
}

- (UIViewController *)modalViewController {
    return objc_getAssociatedObject(self, "presentedViewController");
}

- (void)setPresentedViewController:(UIViewController *)modalViewController {
    objc_setAssociatedObject(self, @"presentedViewController", modalViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)presentedViewController {
    return objc_getAssociatedObject(self, @"presentedViewController");
}

- (void)setPresentingViewController:(UIViewController *)presentingViewController {
    objc_setAssociatedObject(self, "presentingViewController", presentingViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)presentingViewController {
    return objc_getAssociatedObject(self, "presentingViewController");
}


#pragma mark - Animation
- (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    animations();
    completion(YES);
}

@end
#pragma clang diagnostic pop
