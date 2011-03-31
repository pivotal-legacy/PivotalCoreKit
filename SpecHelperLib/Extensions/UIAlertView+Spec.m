#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static char UIAlertViewShowKey;

@implementation UIAlertView (Spec)

- (void)show {
    objc_setAssociatedObject(self, &UIAlertViewShowKey, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isVisible {
    NSNumber *visible = objc_getAssociatedObject(self, &UIAlertViewShowKey);
    return [visible boolValue];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    objc_setAssociatedObject(self, &UIAlertViewShowKey, [NSNumber numberWithBool:NO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
}

@end
