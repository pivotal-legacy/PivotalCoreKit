#import "UIView+StubbedAnimation.h"

static NSTimeInterval lastAnimationDuration__ = 0;
static NSTimeInterval lastAnimationDelay__ = 0;
static UIViewAnimationOptions lastAnimationOptions__ = 0;
static CGFloat lastAnimationSpringWithDamping__ = 0;
static CGFloat lastAnimationInitialSpringVelocity__ = 0;

@implementation UIView (StubbedAnimation)

+ (NSTimeInterval)lastAnimationDuration {
    return lastAnimationDuration__;
}

+ (NSTimeInterval)lastAnimationDelay {
    return lastAnimationDelay__;
}

+ (UIViewAnimationOptions)lastAnimationOptions {
    return lastAnimationOptions__;
}

+ (CGFloat)lastAnimationSpringWithDamping {
    return lastAnimationSpringWithDamping__;
}

+ (CGFloat)lastAnimationInitialSpringVelocity {
    return lastAnimationInitialSpringVelocity__;
}

#pragma mark - Overrides

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    lastAnimationDuration__ = duration;
    if (animations) {
        animations();
    }
    if (completion) {
        completion(YES);
    }
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations {
    [self animateWithDuration:duration animations:animations completion:nil];
}

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    lastAnimationDelay__ = delay;
    lastAnimationOptions__ = options;
    [self animateWithDuration:duration animations:animations completion:completion];
}

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    lastAnimationSpringWithDamping__ = dampingRatio;
    lastAnimationInitialSpringVelocity__ = velocity;
    [self animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
}

#pragma mark - CedarHooks

+ (void)beforeEach {
    lastAnimationDuration__ = 0;
    lastAnimationDelay__ = 0;
    lastAnimationOptions__ = 0;
    lastAnimationSpringWithDamping__ = 0;
    lastAnimationInitialSpringVelocity__ = 0;
}

@end
