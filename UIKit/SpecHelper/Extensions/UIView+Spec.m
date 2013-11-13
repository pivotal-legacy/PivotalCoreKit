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

#pragma mark - UIGestureRecognizer helpers
- (void)tap {
    void (^enumerator)(UIGestureRecognizer *, NSUInteger, BOOL *) = [self gestureEnumeratorForClass:[UITapGestureRecognizer class]];
    [self.gestureRecognizers enumerateObjectsUsingBlock:enumerator];
    Block_release(enumerator);
}

- (void)swipe {
    void (^enumerator)(UIGestureRecognizer *, NSUInteger, BOOL *) = [self gestureEnumeratorForClass:[UISwipeGestureRecognizer class]];
    [self.gestureRecognizers enumerateObjectsUsingBlock:enumerator];
    Block_release(enumerator);    
}

- (void)pinch {
    void (^enumerator)(UIGestureRecognizer *, NSUInteger, BOOL *) = [self gestureEnumeratorForClass:[UIPinchGestureRecognizer class]];
    [self.gestureRecognizers enumerateObjectsUsingBlock:enumerator];
    Block_release(enumerator);
}

#pragma mark - Private
- (void (^)(UIGestureRecognizer *recognizer, NSUInteger idx, BOOL *stop))gestureEnumeratorForClass:(Class)klazz {
    return Block_copy(^(UIGestureRecognizer *recognizer, NSUInteger idx, BOOL *stop) {
        if([recognizer class] == klazz) {
            [recognizer recognize];
        }
    });
}

@end
