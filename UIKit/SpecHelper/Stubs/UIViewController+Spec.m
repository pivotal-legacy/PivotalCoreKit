#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

static char PRESENTING_CONTROLLER_KEY;
static char PRESENTED_CONTROLLER_KEY;

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
        self.presentedViewController.presentingViewController = nil;
        self.presentedViewController = nil;
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
    return self.presentedViewController;
}

- (void)setPresentedViewController:(UIViewController *)modalViewController {
    objc_setAssociatedObject(self, &PRESENTED_CONTROLLER_KEY, modalViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)presentedViewController {
    return objc_getAssociatedObject(self, &PRESENTED_CONTROLLER_KEY);
}

- (void)setPresentingViewController:(UIViewController *)presentingViewController {
    objc_setAssociatedObject(self, &PRESENTING_CONTROLLER_KEY, presentingViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)presentingViewController {
    return objc_getAssociatedObject(self, &PRESENTING_CONTROLLER_KEY);
}


#pragma mark - Animation
- (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    animations();
    completion(YES);
}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    animations();
    completion(YES);
}

@end
#pragma clang diagnostic pop
