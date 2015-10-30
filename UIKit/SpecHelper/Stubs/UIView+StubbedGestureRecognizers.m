#import "UIView+StubbedGestureRecognizers.h"
#import "UIGestureRecognizer+Spec.h"

@implementation UIView (StubbedGestureRecognizers)

#pragma mark - UIGestureRecognizer helpers

- (void)tap {
    [[self recognizersWithClass:[UITapGestureRecognizer class]] makeObjectsPerformSelector:@selector(recognize)];
}

- (void)swipe {
    [[self recognizersWithClass:[UISwipeGestureRecognizer class]] makeObjectsPerformSelector:@selector(recognize)];
}

#if !TARGET_OS_TV
- (void)pinch {
    [[self recognizersWithClass:[UIPinchGestureRecognizer class]] makeObjectsPerformSelector:@selector(recognize)];
}
#endif

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
