#import "UIGestureRecognizer+Spec.h"
#import "objc/runtime.h"

@interface PCKGestureRecognizerTargetActionPair : NSObject
@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic) SEL action;
+ (instancetype)targetActionPairWithTarget:(id)target action:(SEL)action;
@end

@implementation PCKGestureRecognizerTargetActionPair

+ (instancetype)targetActionPairWithTarget:(id)target action:(SEL)action {
    PCKGestureRecognizerTargetActionPair *pair = [[PCKGestureRecognizerTargetActionPair alloc] init];
    pair.target = target;
    pair.action = action;
    return [pair autorelease];
}

@end


@interface UIGestureRecognizer (Spec_Private)
- (void)addUnswizzledTarget:(id)target action:(SEL)action;
- (void)removeUnswizzledTarget:(id)target action:(SEL)action;
- (instancetype)initWithoutSwizzledTarget:(id)target action:(SEL)action;
@end

@implementation UIGestureRecognizer (Spec)

#pragma mark - TODO Refactor to use code in Foundation project
+ (void)redirectSelector:(SEL)originalSelector to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    [self redirectSelector:originalSelector
                      forClass:[self class]
                            to:newSelector
                 andRenameItTo:renamedSelector];

}

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    if ([klass instancesRespondToSelector:renamedSelector]) {
        return;
    }

    Method originalMethod = class_getInstanceMethod(klass, originalSelector);
    class_addMethod(klass, renamedSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));

    Method newMethod = class_getInstanceMethod(klass, newSelector);
    class_replaceMethod(klass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
}

#pragma mark - Setup
+ (void)load {
    [self redirectSelector:@selector(addTarget:action:)
                        to:@selector(addSnoopedTarget:action:)
             andRenameItTo:@selector(addUnswizzledTarget:action:)];

    [self redirectSelector:@selector(removeTarget:action:)
                        to:@selector(removeSnoopedTarget:action:)
             andRenameItTo:@selector(removeUnswizzledTarget:action:)];

    [self redirectSelector:@selector(initWithTarget:action:)
                        to:@selector(initWithSwizzledTarget:action:)
             andRenameItTo:@selector(initWithoutSwizzledTarget:action:)];
}

- (instancetype)initWithSwizzledTarget:(id)target action:(SEL)action {
    if (self = [self initWithoutSwizzledTarget:target action:action]) {
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

    [self.targetsAndActions enumerateObjectsUsingBlock:^(PCKGestureRecognizerTargetActionPair *targetActionPair, NSUInteger index, BOOL *stop) {
        [targetActionPair.target performSelector:targetActionPair.action withObject:self];
    }];
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

#pragma mark - targetsAndActions
static char const * const targetAndActionsKey = "targetAndActionKey";

- (NSMutableArray *)targetsAndActions {
    NSMutableArray *targetsAndActions = objc_getAssociatedObject(self, &targetAndActionsKey);
    if (!targetsAndActions) {
        targetsAndActions = [[[NSMutableArray alloc] init] autorelease];
        [self setTargetsAndActions:targetsAndActions];
    }
    return targetsAndActions;
}

- (void)setTargetsAndActions:(NSMutableArray *)targetsAndActions {
    objc_setAssociatedObject(self, &targetAndActionsKey, targetsAndActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
