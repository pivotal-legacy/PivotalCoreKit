#import <UIKit/UIKit.h>

@interface UIView (StubbedGestureRecognizers)

- (void)tap;
- (void)swipe;
- (void)swipeInDirection:(UISwipeGestureRecognizerDirection)swipeDirection;
- (void)pinch;

@end
