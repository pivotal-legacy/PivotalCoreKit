#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Button)
+ (UIBarButtonItem *)barButtonItemUsingButton:(UIButton *)button;
- (UIButton *)button;
@end
