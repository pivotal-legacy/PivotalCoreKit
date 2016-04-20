#import "UIView+StubbedAnimation.h"
#import <objc/runtime.h>

static BOOL shouldImmediatelyExecuteAnimationBlocks__ = YES;
static NSMutableArray *animations__;

@implementation UIView (StubbedAnimation)

+ (void)load {
    id cedarHooksProtocol = NSProtocolFromString(@"CDRHooks");
    if (cedarHooksProtocol) {
        class_addProtocol(self, cedarHooksProtocol);
    }
}

+ (NSTimeInterval)lastAnimationDuration {
    return [(PCKViewAnimation*)[animations__ lastObject] duration];
}

+ (NSTimeInterval)lastAnimationDelay {
    return [[animations__ lastObject] delay];
}

+ (UIViewAnimationOptions)lastAnimationOptions {
    return [(PCKViewAnimation*)[animations__ lastObject] options];
}

+ (CGFloat)lastAnimationSpringWithDamping {
    return [[animations__ lastObject] springWithDamping];
}

+ (CGFloat)lastAnimationInitialSpringVelocity {
    return [[animations__ lastObject] initialSpringVelocity];
}

+ (void)pauseAnimations {
    shouldImmediatelyExecuteAnimationBlocks__ = NO;
}

+ (void)resumeAnimations {
    shouldImmediatelyExecuteAnimationBlocks__ = YES;
    while (animations__.count != 0) {
        PCKViewAnimation *animation = [animations__ firstObject];
        [animations__ removeObjectAtIndex:0];

        [animation animate];
        [animation complete];
    }
}

+ (NSArray *)animations {
    return animations__;
}

+ (PCKViewAnimation *)lastAnimation {
    return [animations__ lastObject];
}

+ (void)resetAnimations {
    shouldImmediatelyExecuteAnimationBlocks__ = YES;
    animations__ = [NSMutableArray array];
}

#pragma mark - Overrides

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    [self animateWithDuration:duration delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:0 animations:animations completion:completion];
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations {
    [self animateWithDuration:duration delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:0 animations:animations completion:nil];
}

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    [self animateWithDuration:duration delay:delay usingSpringWithDamping:0 initialSpringVelocity:0 options:options animations:animations completion:completion];
}

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {

    PCKViewAnimation *animation = [[PCKViewAnimation alloc] init];
    animation.duration = duration;
    animation.delay = delay;
    animation.springWithDamping = dampingRatio;
    animation.initialSpringVelocity = velocity;
    animation.options = options;
    animation.animationBlock = animations;
    animation.completionBlock = completion;
    [animations__ addObject:animation];

    if (shouldImmediatelyExecuteAnimationBlocks__) {
        [animation animate];
        [animation complete];
    }
}

#pragma mark - CedarHooks

+ (void)beforeEach {
    [self resetAnimations];
}

@end

@implementation PCKViewAnimation

- (void)animate {
    self.animationBlock();
}

- (void)complete {
    if (self.completionBlock) {
        self.completionBlock(YES);
    }
}

- (void)cancel {
    self.completionBlock(NO);
}

@end

