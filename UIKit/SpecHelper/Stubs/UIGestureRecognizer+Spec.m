#if __has_feature(objc_arc)
#error This file must be compiled without ARC
#endif

#import "UIGestureRecognizer+Spec.h"
#import <objc/runtime.h>
#import "PCKMethodRedirector.h"

static NSString * const kGestureStateKey = @"state";

@interface UIGestureRecognizerTarget : NSObject
- (SEL)_action;
@end

@interface UIGestureRecognizer (PrivateAPI)
- (void)_resetGestureRecognizer;
@end

@implementation UIGestureRecognizer (Spec)

#pragma mark - Public interface
- (void)recognize {
    if (self.view == nil) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when not in a view" userInfo:nil] raise];
    }
    if (self.view.hidden) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when in a hidden view" userInfo:nil] raise];
    }
    if (!self.enabled) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when recognizer is disabled" userInfo:nil] raise];
    }

    [self setValue:@(UIGestureRecognizerStateEnded) forKey:kGestureStateKey];


    Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
    Ivar targetIvar = class_getInstanceVariable(targetActionPairClass, "_target");
    Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");

    NSArray *targetsAndActions = [self valueForKey:@"_targets"];
    [targetsAndActions enumerateObjectsUsingBlock:^(UIGestureRecognizerTarget *pair, NSUInteger idx, BOOL *stop) {
        id target = object_getIvar(pair, targetIvar);
        SEL action = (SEL)object_getIvar(pair, actionIvar);
        [target performSelector:action withObject:self];
    }];

    [self _resetGestureRecognizer];
    [self setValue:@(UIGestureRecognizerStatePossible) forKey:kGestureStateKey];
}

+ (void)whitelistClassForGestureSnooping:(Class)klass {}

@end
