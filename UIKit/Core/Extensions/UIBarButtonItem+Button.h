#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Button)
+ (UIBarButtonItem *)barButtonItemUsingButton:(UIButton *)button;
@property (nonatomic, readonly) UIButton *button;
@end
