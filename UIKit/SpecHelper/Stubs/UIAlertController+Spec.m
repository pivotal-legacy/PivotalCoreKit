#import "UIAlertController+Spec.h"
#import "UIAlertAction+Spec.h"

@implementation UIAlertController (Spec)

- (void)dismissByTappingCancelButton {
    if (!self.presentingViewController) {
        [[NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:@"Can't dismiss a UIAlertController when it is not presented"
                               userInfo:nil] raise];
    }

    [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
        UIAlertAction *cancelAction = [self pck_cancelAction];
        if (cancelAction.handler) {
            cancelAction.handler(cancelAction);
        }
    }];
}

- (void)dismissByTappingButtonWithTitle:(NSString *)title {
    if (!self.presentingViewController) {
        [[NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:@"Can't dismiss a UIAlertController when it is not presented"
                               userInfo:nil] raise];
    }

    [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
        UIAlertAction *action = [self pck_actionWithButtonTitle:title];
        if (action.handler) {
            action.handler(action);
        }
    }];
}

#pragma mark - Private

- (UIAlertAction *)pck_cancelAction {
    NSPredicate *cancelPredicate = [NSPredicate predicateWithBlock:^BOOL(UIAlertAction *action, NSDictionary *bindings) {
        return action.style == UIAlertActionStyleCancel;
    }];

    UIAlertAction *cancelAction = [[self.actions filteredArrayUsingPredicate:cancelPredicate] lastObject];
    if (!cancelAction) {
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"UIAlertController does not have a cancel button" userInfo:nil] raise];
    }
    return cancelAction;
}

- (UIAlertAction *)pck_actionWithButtonTitle:(NSString *)title {
    NSArray *buttonTitles = [self.actions valueForKey:@"title"];
    NSUInteger buttonIndex = [buttonTitles indexOfObject:title];
    if (buttonIndex == NSNotFound) {
        NSString *reason = [NSString stringWithFormat:@"UIAlertController does not have a button titled '%@' -- current button titles are %@", title, buttonTitles];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil] raise];
    }
    return self.actions[buttonIndex];
}

- (void)_uninstallSelectGestureRecognizer {
    // UIAlertController's implementation of this method is called from -dealloc and calls -view.
    // Since the view is generally not previously loaded when used while PCK is loaded, this means
    // that the view is loaded for the first time while UIAlertController is deallocating, which
    // is not allowed and prints scary console messages under iOS 9. Overriding this method here
    // prevents the view from being loaded in this situation.
}

@end
