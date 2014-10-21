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
    [[self recognizersWithClass:[UITapGestureRecognizer class]] makeObjectsPerformSelector:@selector(recognize)];
}

- (void)swipe {
    [[self recognizersWithClass:[UISwipeGestureRecognizer class]] makeObjectsPerformSelector:@selector(recognize)];
}

- (void)pinch {
    [[self recognizersWithClass:[UIPinchGestureRecognizer class]] makeObjectsPerformSelector:@selector(recognize)];
}

- (void)swipeInDirection:(UISwipeGestureRecognizerDirection)swipeDirection {
    NSArray *swipeRecognizers = [self recognizersWithClass:[UISwipeGestureRecognizer class]];
    NSPredicate *directionPredicate = [NSPredicate predicateWithFormat:@"direction = %@", @(swipeDirection)];
    return [[swipeRecognizers filteredArrayUsingPredicate:directionPredicate] makeObjectsPerformSelector:@selector(recognize)];
}

#pragma mark - Private

- (NSArray *)recognizersWithClass:(Class)klazz {
    return [self.gestureRecognizers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class = %@", klazz]];
}

@end
