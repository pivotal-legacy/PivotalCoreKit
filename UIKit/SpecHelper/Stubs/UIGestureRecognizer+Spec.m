#if __has_feature(objc_arc)
#error This file must be compiled without ARC
#endif

#import "UIGestureRecognizer+Spec.h"
#import <objc/runtime.h>
#import "PCKMethodRedirector.h"

@interface UIGestureRecognizer (Spec_Private)

- (void)addUnswizzledTarget:(id)target action:(SEL)action;
- (void)addSnoopedTarget:(id)target action:(SEL)action;
- (void)removeUnswizzledTarget:(id)target action:(SEL)action;
- (void)removeSnoopedTarget:(id)target action:(SEL)action;
- (UIGestureRecognizerState)snoopedState;
- (UIGestureRecognizerState)unswizzledState;
- (instancetype)initWithoutSwizzledTarget:(id)target action:(SEL)action;
- (instancetype)initWithSwizzledTarget:(id)target action:(SEL)action;

@end

@interface PCKGestureRecognizerTargetActionPair : NSObject

@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic) SEL action;

+ (instancetype)targetActionPairWithTarget:(id)target action:(SEL)action;

@end

@implementation PCKGestureRecognizerTargetActionPair

+ (void)load {
    [PCKMethodRedirector redirectSelector:@selector(addTarget:action:)
                                 forClass:[UIGestureRecognizer class]
                                       to:@selector(addSnoopedTarget:action:)
                            andRenameItTo:@selector(addUnswizzledTarget:action:)];

    [PCKMethodRedirector redirectSelector:@selector(removeTarget:action:)
                                 forClass:[UIGestureRecognizer class]
                                       to:@selector(removeSnoopedTarget:action:)
                            andRenameItTo:@selector(removeUnswizzledTarget:action:)];

    [PCKMethodRedirector redirectSelector:@selector(initWithTarget:action:)
                                 forClass:[UIGestureRecognizer class]
                                       to:@selector(initWithSwizzledTarget:action:)
                            andRenameItTo:@selector(initWithoutSwizzledTarget:action:)];

    [PCKMethodRedirector redirectSelector:@selector(state)
                                 forClass:[UIGestureRecognizer class]
                                       to:@selector(snoopedState)
                            andRenameItTo:@selector(unswizzledState)];
}

+ (instancetype)targetActionPairWithTarget:(id)target action:(SEL)action {
    PCKGestureRecognizerTargetActionPair *pair = [[PCKGestureRecognizerTargetActionPair alloc] init];
    pair.target = target;
    pair.action = action;
    return [pair autorelease];
}

@end

#pragma mark -

@implementation UIGestureRecognizer (Spec)

- (instancetype)initWithSwizzledTarget:(id)target action:(SEL)action {
    if (self = [self initWithoutSwizzledTarget:target action:action]) {
        [self setSnoopedState:UIGestureRecognizerStatePossible];
        if (target && action) {
            [self addSnoopedTarget:target action:action];
        }
    }

    return self;
}

#pragma mark - Public interface
- (void)recognize {
    if (self.view.hidden) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when in a hidden view" userInfo:nil] raise];
    }
    if (!self.enabled) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when recognizer is disabled" userInfo:nil] raise];
    }

    [self setSnoopedState:UIGestureRecognizerStateEnded];
    [self.targetsAndActions enumerateObjectsUsingBlock:^(PCKGestureRecognizerTargetActionPair *targetActionPair, NSUInteger index, BOOL *stop) {
        [targetActionPair.target performSelector:targetActionPair.action withObject:self];
    }];
    [self setSnoopedState:UIGestureRecognizerStatePossible];
}

+ (void)whitelistClassForGestureSnooping:(Class)klass {}

#pragma mark - swizzled methods
- (void)addSnoopedTarget:(id)target action:(SEL)action {
    [self addUnswizzledTarget:target action:action];
    [[self targetsAndActions] addObject:[PCKGestureRecognizerTargetActionPair targetActionPairWithTarget:target action:action]];
}

- (void)removeSnoopedTarget:(id)target action:(SEL)action {
    [self removeUnswizzledTarget:target action:action];

    NSMutableArray *targetsAndActions = [self targetsAndActions];
    __block id unretainedTarget = target;
    NSPredicate *targetAndActionPredicate = [NSPredicate predicateWithBlock:^BOOL(PCKGestureRecognizerTargetActionPair *targetActionPair, NSDictionary *bindings) {
        return unretainedTarget == targetActionPair.target && action == targetActionPair.action;
    }];

    NSArray *matchingTargetsAndActions = [targetsAndActions filteredArrayUsingPredicate:targetAndActionPredicate];
    [targetsAndActions removeObjectsInArray:matchingTargetsAndActions];
}

#pragma mark - Targets and Actions

static char TARGETS_AND_ACTIONS_KEY;
static char GESTURE_RECOGNIZER_STATE_KEY;

- (NSMutableArray *)targetsAndActions {
    NSMutableArray *targetsAndActions = objc_getAssociatedObject(self, &TARGETS_AND_ACTIONS_KEY);
    if (!targetsAndActions) {
        targetsAndActions = [[[NSMutableArray alloc] init] autorelease];
        [self setTargetsAndActions:targetsAndActions];
    }
    return targetsAndActions;
}

- (void)setTargetsAndActions:(NSMutableArray *)targetsAndActions {
    objc_setAssociatedObject(self, &TARGETS_AND_ACTIONS_KEY, targetsAndActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIGestureRecognizerState)snoopedState {
    return (UIGestureRecognizerState)[(NSNumber *)objc_getAssociatedObject(self, &GESTURE_RECOGNIZER_STATE_KEY) integerValue];
}

- (void)setSnoopedState:(UIGestureRecognizerState)newState {
    objc_setAssociatedObject(self, &GESTURE_RECOGNIZER_STATE_KEY, @(newState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
