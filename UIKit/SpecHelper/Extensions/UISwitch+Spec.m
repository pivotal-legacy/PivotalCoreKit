#import "UISwitch+Spec.h"

@implementation UISwitch (Spec)

- (void)toggle {
    if (self.hidden) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't toggle an invisible switch" userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't toggle a disabled switch" userInfo:nil] raise];
    }
    self.on = !self.on;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)toggleToOn:(BOOL)on {
    if (self.hidden) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't toggle an invisible switch" userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't toggle a disabled switch" userInfo:nil] raise];
    }
    if (self.on != on) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    self.on = on;
}

@end
