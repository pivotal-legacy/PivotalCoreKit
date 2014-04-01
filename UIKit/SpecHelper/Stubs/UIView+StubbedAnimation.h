#import <UIKit/UIKit.h>

@interface UIView (StubbedAnimation)

+ (NSTimeInterval)lastAnimationDuration;
+ (NSTimeInterval)lastAnimationDelay;
+ (UIViewAnimationOptions)lastAnimationOptions;
+ (CGFloat)lastAnimationSpringWithDamping;
+ (CGFloat)lastAnimationInitialSpringVelocity;

@end
