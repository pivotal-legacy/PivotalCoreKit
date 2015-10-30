#import <UIKit/UIKit.h>

@interface UIView (StubbedGestureRecognizers)

- (void)tap;
/*! @abstract Use swipeInDirection: instead. */
- (void)swipe DEPRECATED_ATTRIBUTE;
- (void)swipeInDirection:(UISwipeGestureRecognizerDirection)swipeDirection;

#if !TARGET_OS_TV
- (void)pinch;
#endif

@end
