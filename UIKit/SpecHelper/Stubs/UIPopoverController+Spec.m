#import "UIPopoverController+Spec.h"

@implementation UIPopoverController (Spec)
static UIPopoverController *currentPopoverController;
static UIPopoverArrowDirection pckArrowDirection;

+ (instancetype)currentPopoverController {
    return currentPopoverController;
}

+ (void)reset {
    currentPopoverController = nil;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)dealloc {
    // [super dealloc] will raise an exception if -isPopoverVisible is YES when deallocating
    if (self == currentPopoverController) {
        currentPopoverController = nil;
    }
}

// -presentPopoverFromBarButtonItem:permittedArrowDirections:animated: calls through to this method
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {
    currentPopoverController = self;

    pckArrowDirection = arrowDirections;
}

- (void)dismissPopoverAnimated:(BOOL)animated {
    if (self == currentPopoverController) {
        currentPopoverController = nil;
    }
}

- (BOOL)isPopoverVisible {
    return (self == currentPopoverController);
}

- (UIPopoverArrowDirection)popoverArrowDirection {
    return pckArrowDirection;
}

#pragma clang diagnostic pop

@end
