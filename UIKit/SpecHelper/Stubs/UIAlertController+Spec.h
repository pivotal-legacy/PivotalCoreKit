#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Spec)

- (void)dismissByTappingCancelButton;
- (void)dismissByTappingButtonWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
