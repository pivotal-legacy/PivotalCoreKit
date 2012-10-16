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
    self.modalViewController = modalViewController;
    self.presentedViewController = modalViewController;
    modalViewController.presentingViewController = self;
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    self.modalViewController.presentingViewController = nil;
    self.modalViewController = nil;

    if (self.presentingViewController) {
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    } else {
        objc_setAssociatedObject(self.presentedViewController, @"presentingViewController", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @"presentedViewController", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self dismissModalViewControllerAnimated:flag];
    if (completion) {
        completion();
    }
}

- (void)setModalViewController:(UIViewController *)modalViewController {
    objc_setAssociatedObject(self, "modalViewController", modalViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)modalViewController {
    return objc_getAssociatedObject(self, "modalViewController");
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
