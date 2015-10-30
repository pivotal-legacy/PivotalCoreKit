#import "UIViewController+Spec.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static char PRESENTING_CONTROLLER_KEY;
static char PRESENTED_CONTROLLER_KEY;


@implementation UIViewController (Spec)

+ (void)load {
    [self pck_useSpecStubs:YES];
}

+ (void)pck_useSpecStubs:(BOOL)useSpecStubs {
    unsigned int outCount;
    Method *methods = class_copyMethodList(self, &outCount);
    for (int i = 0; i < outCount; ++i) {
        Method method = methods[i];
        SEL pckSelector = method_getName(method);
        NSString *pckSelectorName = NSStringFromSelector(pckSelector);

        if ([pckSelectorName hasPrefix:@"pck_"]) {
            Method pckMethod = class_getInstanceMethod(self, pckSelector);
            IMP pckImplementation = method_getImplementation(pckMethod);

            NSString *originalSelectorName = [pckSelectorName substringFromIndex:@"pck_".length];
            SEL originalSelector = NSSelectorFromString(originalSelectorName);

            Method currentMethod = class_getInstanceMethod(self, originalSelector);
            if (currentMethod == NULL) { continue; }

            NSString *preservedSelectorName = [@"_pck_preserved_" stringByAppendingString:originalSelectorName];
            SEL preservedSelector = NSSelectorFromString(preservedSelectorName);

            if (useSpecStubs) {
                // class_addMethod is used here since it only adds the method if it doesn't already exist, and is a
                // no-op otherwise. This prevents us from accidentally overwriting the preserved original IMP with a
                // pck stub
                class_addMethod(self, preservedSelector, method_getImplementation(currentMethod), method_getTypeEncoding(currentMethod));
                method_setImplementation(currentMethod, pckImplementation);
            }
            else {
                Method preservedMethod = class_getInstanceMethod(self, preservedSelector);
                if (preservedMethod == NULL) { continue; }

                IMP preservedImplementation = method_getImplementation(preservedMethod);
                method_setImplementation(currentMethod, preservedImplementation);
            }
        }
    }
    free(methods);
}

#pragma mark - Modals

- (void)pck_presentViewController:(UIViewController *)modalViewController animated:(BOOL)animated completion:(void(^)(void))onComplete {
    if (!modalViewController) {
        NSString *errorReason = [NSString stringWithFormat:@"Application tried to present a nil modal view controller on target %@", self];
        [[NSException exceptionWithName:NSInvalidArgumentException reason:errorReason userInfo:nil] raise];
    }
    if (self.presentedViewController) {
        NSString *errorReason = [NSString stringWithFormat:@"Presenting modal view controller (%@) with other modal (%@) previously active", modalViewController, self.presentedViewController];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:errorReason userInfo:nil] raise];
    }

    [self _pck_setPresentedViewController:modalViewController];
    [modalViewController _pck_setPresentingViewController:self];
    if (onComplete) {
        onComplete();
    }
}

- (void)pck_dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.presentedViewController) {
        [self.presentedViewController _pck_setPresentingViewController:nil];
        [self _pck_setPresentedViewController:nil];
    } else if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:completion];
    } else if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:completion];
    }

    if (completion) {
        completion();
    }
}

#pragma mark Deprecated Modal APIs

- (void)pck_presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    [self presentViewController:modalViewController animated:animated completion:nil];
}

- (void)pck_dismissModalViewControllerAnimated:(BOOL)animated {
    [self dismissViewControllerAnimated:animated completion:nil];
}

- (UIViewController *)pck_modalViewController {
    return self.presentedViewController;
}

#pragma mark Modal Properties

- (void)_pck_setPresentedViewController:(UIViewController *)modalViewController {
    objc_setAssociatedObject(self, &PRESENTED_CONTROLLER_KEY, modalViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)pck_presentedViewController {
    return objc_getAssociatedObject(self, &PRESENTED_CONTROLLER_KEY);
}

- (void)_pck_setPresentingViewController:(UIViewController *)presentingViewController {
    objc_setAssociatedObject(self, &PRESENTING_CONTROLLER_KEY, presentingViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)pck_presentingViewController {
    return objc_getAssociatedObject(self, &PRESENTING_CONTROLLER_KEY);
}

#pragma mark - Animation

- (void)pck_animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    animations();
    completion(YES);
}

- (void)pck_transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {

    [[self view] addSubview:toViewController.view];

    if (animations) {
        animations();
    }

    if (completion) {
        completion(YES);
    }
}

@end
#pragma clang diagnostic pop
