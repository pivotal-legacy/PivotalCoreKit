#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertView (Spec)

+ (nullable UIAlertView *)currentAlertView;
+ (void)reset;

- (void)dismissWithOkButton;
- (void)dismissWithCancelButton;

@end

NS_ASSUME_NONNULL_END
