#import "UIControl+Spec.h"

@implementation UIControl (Spec)

- (void)tap {
    if (self.hidden) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't tap an invisible control" userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't tap a disabled control" userInfo:nil] raise];
    }
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)slideTo:(float)value {
    if (self.hidden) {
        [[NSException exceptionWithName:@"Unslideable" reason:@"Can't slide an invisible control" userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:@"Unslideable" reason:@"Can't slide a disabled control" userInfo:nil] raise];
    }
    [(UISlider *)self setValue:value animated:NO];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
