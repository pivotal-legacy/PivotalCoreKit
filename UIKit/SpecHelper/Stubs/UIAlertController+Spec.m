#import "UIAlertController+Spec.h"
#import "UIAlertAction+Spec.h"


@implementation UIAlertController (Spec)

- (void)dismissByTappingCancelButton {
    UIAlertAction *cancelAction = [self cancelAction];
    if (cancelAction.handler) {
        cancelAction.handler(cancelAction);
    }
}

- (void)dismissByTappingButtonWithTitle:(NSString *)title {
    UIAlertAction *action = [self actionWithButtonTitle:title];
    if (action.handler) {
        action.handler(action);
    }
}

#pragma mark - Private

- (UIAlertAction *)cancelAction {
    NSPredicate *cancelPredicate = [NSPredicate predicateWithBlock:^BOOL(UIAlertAction *action, NSDictionary *bindings) {
        return action.style == UIAlertActionStyleCancel;
    }];

    UIAlertAction *cancelAction = [[self.actions filteredArrayUsingPredicate:cancelPredicate] lastObject];
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        if (!cancelAction) {
            [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"UIAlertController does not have a cancel button" userInfo:nil] raise];
        }
        return cancelAction;
    } else {
        return cancelAction ? cancelAction : self.actions.lastObject;
    }
}

- (UIAlertAction *)actionWithButtonTitle:(NSString *)title {
    NSArray *buttonTitles = [self.actions valueForKey:@"title"];
    NSUInteger buttonIndex = [buttonTitles indexOfObject:title];
    if (buttonIndex == NSNotFound) {
        NSString *reason = [NSString stringWithFormat:@"UIAlertController does not have a button titled '%@' -- current button titles are %@", title, buttonTitles];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil] raise];
    }
    return self.actions[buttonIndex];
}

@end
