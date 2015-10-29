#import "UISwitch+Spec.h"

@implementation UISwitch (Spec)

- (void)toggle {
    [self runAssertions];

    self.on = !self.on;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)toggleToOn:(BOOL)on {
    [self runAssertions];

    if (self.on != on) {
        self.on = on;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Private

- (void)runAssertions {
    if (self.hidden) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't toggle an invisible switch" userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't toggle a disabled switch" userInfo:nil] raise];
    }
}

@end
