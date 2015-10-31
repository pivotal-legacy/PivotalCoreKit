#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPopoverController (Spec)

+ (nullable instancetype)currentPopoverController;
+ (void)reset;

@end

NS_ASSUME_NONNULL_END
