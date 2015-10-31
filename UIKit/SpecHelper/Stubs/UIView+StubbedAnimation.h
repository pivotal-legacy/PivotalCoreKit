#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCKViewAnimation : NSObject

@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) NSTimeInterval delay;
@property (assign, nonatomic) CGFloat springWithDamping;
@property (assign, nonatomic) CGFloat initialSpringVelocity;
@property (assign, nonatomic) UIViewAnimationOptions options;
@property (strong, nonatomic) void (^animationBlock)(void);
@property (strong, nonatomic, nullable) void (^completionBlock)(BOOL);

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
+ (void)resumeAnimations;
+ (NSArray *)animations;
+ (nullable PCKViewAnimation *)lastAnimation;
+ (void)resetAnimations;

@end

NS_ASSUME_NONNULL_END
