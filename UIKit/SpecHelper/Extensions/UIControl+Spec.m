#import "UIControl+Spec.h"

@implementation UIControl (Spec)

- (void)tap {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
