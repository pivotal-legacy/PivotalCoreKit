#import "UIBarButtonItem+Button.h"

@implementation UIBarButtonItem (Button)

+ (UIBarButtonItem *)barButtonItemUsingButton:(UIButton *)button {
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

- (UIButton *)button {
    if ([self.customView isKindOfClass:[UIButton class]]) {
        return (UIButton *)self.customView;
    }
    return nil;
}

@end
