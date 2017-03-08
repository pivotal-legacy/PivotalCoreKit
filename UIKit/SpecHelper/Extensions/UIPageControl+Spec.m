#import "UIPageControl+Spec.h"

static NSString *exceptionName = @"Untappable";
static NSString *hiddenExceptionReason = @"Can't tap an invisible control";
static NSString *disabledExceptionReason = @"Can't tap a disabled control";
static NSString *zeroSizeExceptionReason = @"Can't tap a control with no width or height. Your control may not be laid out correctly.";

@implementation UIPageControl (Spec)

- (void)tapLeft {
    [self checkTappable];
    
    if (self.currentPage > 0) {
        self.currentPage--;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)tapRight {
    [self checkTappable];
    
    if (self.currentPage < self.numberOfPages - 1) {
        self.currentPage++;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Private

- (void)checkTappable {
    if (self.hidden) {
        [[NSException exceptionWithName:exceptionName reason:hiddenExceptionReason userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:exceptionName reason:disabledExceptionReason userInfo:nil] raise];
    }
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        [[NSException exceptionWithName:exceptionName reason:zeroSizeExceptionReason userInfo:nil] raise];
    }
}


@end
