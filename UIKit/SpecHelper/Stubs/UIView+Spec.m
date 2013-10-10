#import <UIKit/UIKit.h>

@implementation UIView (Spec)

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
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

@end
