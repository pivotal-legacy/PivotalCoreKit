#import <UIKit/UIKit.h>

@interface PCKViewAnimation : NSObject

@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) NSTimeInterval delay;
@property (assign, nonatomic) CGFloat springWithDamping;
@property (assign, nonatomic) CGFloat initialSpringVelocity;
@property (assign, nonatomic) UIViewAnimationOptions options;
@property (strong, nonatomic) void (^animationBlock)(void);
@property (strong, nonatomic) void (^completionBlock)(BOOL);

- (void)animate;
- (void)complete;
- (void)cancel;

@end

@interface UIView (StubbedAnimation)

+ (NSTimeInterval)lastAnimationDuration;
+ (NSTimeInterval)lastAnimationDelay;
+ (UIViewAnimationOptions)lastAnimationOptions;
+ (CGFloat)lastAnimationSpringWithDamping;
+ (CGFloat)lastAnimationInitialSpringVelocity;

+ (void)pauseAnimations;
+ (NSArray *)animations;
+ (PCKViewAnimation *)lastAnimation;

@end