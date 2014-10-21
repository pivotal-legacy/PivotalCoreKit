#import <UIKit/UIKit.h>

@interface UIView (Spec)
- (UIView *)subviewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;
- (UIView *)firstSubviewOfClass:(Class)aClass;

- (void)tap;
- (void)swipe;
- (void)swipeInDirection:(UISwipeGestureRecognizerDirection)swipeDirection;
- (void)pinch;

@end
