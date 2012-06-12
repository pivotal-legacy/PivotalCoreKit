#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation UIViewController (Spec)

#pragma mark - Modals
- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    NSAssert(!self.modalViewController, @"Looks like modal controller is already presented.");
    self.modalViewController = modalViewController;
    modalViewController.presentingViewController = self;
}

- (void)setModalViewController:(UIViewController *)modalViewController {
    objc_setAssociatedObject(self, "modalViewController", modalViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    NSAssert(self.modalViewController, @"Looks like modal controller was not presented by the receiver.");
    self.modalViewController.presentingViewController = nil;
    self.modalViewController = nil;
}

- (UIViewController *)modalViewController {
    return objc_getAssociatedObject(self, "modalViewController");
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
