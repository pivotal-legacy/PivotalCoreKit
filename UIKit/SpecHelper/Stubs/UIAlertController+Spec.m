#import "UIAlertController+Spec.h"
#import "UIAlertAction+Spec.h"

@implementation UIAlertController (Spec)

- (void)dismissByTappingCancelButton {
    UIAlertAction *cancelAction = [self cancelAction];
    if (cancelAction.handler) {
        cancelAction.handler(cancelAction);
    }
}

#pragma mark - Private

- (UIAlertAction *)cancelAction {
    NSPredicate *cancelPredicate = [NSPredicate predicateWithBlock:^BOOL(UIAlertAction *action, NSDictionary *bindings) {
        return action.style == UIAlertActionStyleCancel;
    }];

    UIAlertAction *cancelAction = [[self.actions filteredArrayUsingPredicate:cancelPredicate] lastObject];
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        return cancelAction;
    } else {
        return cancelAction ? cancelAction : self.actions.lastObject;
    }
}

@end
