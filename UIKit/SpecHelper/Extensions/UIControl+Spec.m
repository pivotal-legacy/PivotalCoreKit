#import "UIControl+Spec.h"

static NSString *exceptionName = @"Untappable";
static NSString *hiddenExceptionReason = @"Can't tap an invisible control";
static NSString *disabledExceptionReason = @"Can't tap a disabled control";
static NSString *zeroSizeExceptionReason = @"Can't tap a control with no width or height. Your control may not be laid out correctly.";

@implementation UIControl (Spec)

- (void)tap {
    if (self.hidden) {
        [[NSException exceptionWithName:exceptionName reason:hiddenExceptionReason userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:exceptionName reason:disabledExceptionReason userInfo:nil] raise];
    }
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        [[NSException exceptionWithName:exceptionName reason:zeroSizeExceptionReason userInfo:nil] raise];
    }
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
