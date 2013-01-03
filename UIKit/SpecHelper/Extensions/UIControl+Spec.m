#import "UIControl+Spec.h"

@implementation UIControl (Spec)

- (void)tap {
    NSAssert(self.hidden == NO, @"Can't tap an invisible control");
    NSAssert(self.isEnabled == YES, @"Can't tap a disabled control");
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
