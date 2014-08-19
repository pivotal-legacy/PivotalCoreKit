#import "UIView+Spec.h"
#import "UIGestureRecognizer+Spec.h"

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

#pragma mark - UIGestureRecognizer helpers
- (void)tap {
    [self recognizeAllGesturesMatching:[UITapGestureRecognizer class]];
}

- (void)swipe {
    [self recognizeAllGesturesMatching:[UISwipeGestureRecognizer class]];
}

- (void)pinch {
    [self recognizeAllGesturesMatching:[UIPinchGestureRecognizer class]];
}

#pragma mark - Private
- (void) recognizeAllGesturesMatching:(Class)klazz {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        if ([recognizer class] == klazz) {
            [recognizer recognize];
        }
    }
}

@end
