#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (Spec)

- (void)recognize;

+ (void)whitelistClassForGestureSnooping:(Class)klass __attribute__((deprecated("Calling this method is no longer required")));

@end
