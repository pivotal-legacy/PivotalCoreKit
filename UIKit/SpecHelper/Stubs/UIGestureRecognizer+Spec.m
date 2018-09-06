#if __has_feature(objc_arc)
#error This file must be compiled without ARC
#endif

#import "UIGestureRecognizer+Spec.h"
#import <objc/runtime.h>
#import "PCKMethodRedirector.h"

static NSString * const kGestureStateKey = @"state";
static NSString * const kLocationInViewKey = @"kLocationInView";

@interface UIGestureRecognizerTarget : NSObject
- (SEL)_action;
@end

@interface UIGestureRecognizer (PrivateAPI)
- (void)_resetGestureRecognizer;
@end

@interface UIGestureRecognizer (SpecPrivate)
- (CGPoint)_locationInView:(UIView *)view;
@end

UIView *oldestParentView(UIView *view);
BOOL viewSharesHierarchy(UIView *view, UIView *otherView);

@implementation UIGestureRecognizer (Spec)

#pragma mark - Public interface

- (void)recognize {
    [self sharedRecognitionWithState:UIGestureRecognizerStateEnded];

    [self _resetGestureRecognizer];
    [self setValue:@(UIGestureRecognizerStatePossible) forKey:kGestureStateKey];
}

- (void)recognizeWithState:(UIGestureRecognizerState)state {
    [self sharedRecognitionWithState:state];
}

- (void)setLocationInView:(CGPoint)point {
    objc_setAssociatedObject(self, kLocationInViewKey, [NSValue valueWithCGPoint:point], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)enableLocationInViewMocking {
    [self setLocationInViewMocking:YES];
}

- (void)disableLocationInViewMocking {
    [self setLocationInViewMocking:NO];
}

- (void)setLocationInViewMocking:(BOOL)enable {
    SEL preservedSelector = NSSelectorFromString(@"original_locationInView:");
    Method originalMethod = class_getInstanceMethod([self class], @selector(locationInView:));
    if (enable) {
        class_addMethod(
            [self class],
            preservedSelector,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod)
        );
        method_setImplementation(
            originalMethod,
            method_getImplementation(class_getInstanceMethod([self class], @selector(pck_locationInView:)))
        );
    } else {
        Method preservedMethod = class_getInstanceMethod([self class], preservedSelector);
        if (preservedMethod == NULL) { return; }

        IMP preservedImplementation = method_getImplementation(preservedMethod);
        method_setImplementation(originalMethod, preservedImplementation);
    }
}

- (CGPoint)pck_locationInView:(UIView *)view {
    NSValue *pointValue = objc_getAssociatedObject(self, kLocationInViewKey);
    CGPoint point = [pointValue CGPointValue];
    if (view == self.view) {
        return point;
    } else if (view == nil) {
        if (self.view.window == nil) {
            [[NSException exceptionWithName:@"No valid location"
                                     reason:@"Can't give location in view with no view and gesture recognizer not part of a window hierarchy"
                                   userInfo:nil] raise];
        } else {
            view = self.view.window;
        }
    } else if (!viewSharesHierarchy(self.view, view)) {
        [[NSException exceptionWithName:@"No valid location"
                                 reason:@"Can't give location in view not related to gesture recognizer's view"
                               userInfo:nil] raise];
    }
    return [self.view convertPoint:point toView:view];
}

+ (void)whitelistClassForGestureSnooping:(Class)klass {}

- (void)sharedRecognitionWithState:(UIGestureRecognizerState)state {
    if (self.view == nil) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when not in a view" userInfo:nil] raise];
    }
    if (self.view.hidden) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when in a hidden view" userInfo:nil] raise];
    }
    if (!self.enabled) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when recognizer is disabled" userInfo:nil] raise];
    }

    [self setValue:@(state) forKey:kGestureStateKey];

    Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
    Ivar targetIvar = class_getInstanceVariable(targetActionPairClass, "_target");
    Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");

    NSArray *targetsAndActions = [self valueForKey:@"_targets"];
    [targetsAndActions enumerateObjectsUsingBlock:^(UIGestureRecognizerTarget *pair, NSUInteger idx, BOOL *stop) {
        id target = object_getIvar(pair, targetIvar);
        SEL action = (SEL)object_getIvar(pair, actionIvar);
        [target performSelector:action withObject:self];
    }];
}

@end

BOOL viewSharesHierarchy(UIView *view, UIView *otherView) {
    return oldestParentView(view) == oldestParentView(otherView);
}

UIView *oldestParentView(UIView *view) {
    if (view.superview) {
        return oldestParentView(view.superview);
    }
    return view;
}
