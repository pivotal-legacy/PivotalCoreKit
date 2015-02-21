#import "UIBarButtonItem+Spec.h"
#import "UIControl+Spec.h"

@implementation UIBarButtonItem (Spec)

- (void)tap {
    if (self.enabled == NO) {
        @throw @"Attempted to tap disabled bar button item";
    }

    if ([self.customView isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self.customView;
        [button tap];
    } else {
        [self.target performSelector:self.action withObject:self];
    }
}

@end
