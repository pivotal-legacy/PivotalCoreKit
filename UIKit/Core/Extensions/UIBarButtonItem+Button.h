#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Button)
+ (UIBarButtonItem *)barButtonItemUsingButton:(UIButton *)button;
- (nullable UIButton *)button;
@end

NS_ASSUME_NONNULL_END
