#import "UIView+Spec.h"

@implementation UIView (Spec)

- (UIView *)subviewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier {
    for (UIView *subview in self.subviews) {
        if ([subview.accessibilityIdentifier isEqual:accessibilityIdentifier]) {
            return subview;
        }
    }
    return nil;
}

- (UIView *)firstSubviewOfClass:(Class)aClass {
    NSMutableArray *subviewQueue = [NSMutableArray arrayWithArray:self.subviews];

    while ([subviewQueue count] > 0) {
        UIView *subview = [subviewQueue firstObject];

        if ([subview isKindOfClass:aClass]) {
            return subview;
        }

        [subviewQueue removeObjectAtIndex:0];
        [subviewQueue addObjectsFromArray:subview.subviews];
    }

    return nil;
}

- (BOOL)isTrulyVisible {
    if (self.hidden) {
        return NO;
    }
    if (self.alpha == 0) {
        return NO;
    }
    if (!self.subviews.count || self.clipsToBounds) {
        if (CGRectGetWidth([self frame]) == 0 || CGRectGetHeight([self frame]) == 0) {
            return NO;
        }
    }
    if (self.superview) {
        return [self.superview isTrulyVisible];
    }
    return YES;
}

@end
