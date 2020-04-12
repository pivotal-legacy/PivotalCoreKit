#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (Spec)

- (void)recognize;
- (void)recognizeWithState:(UIGestureRecognizerState)state NS_SWIFT_NAME(recognize(with:));

- (void)setLocationInView:(CGPoint)point;
- (void)enableLocationInViewMocking;
- (void)disableLocationInViewMocking;

+ (void)whitelistClassForGestureSnooping:(Class)klass __attribute__((deprecated("Calling this method is no longer required")));

@end

NS_ASSUME_NONNULL_END
