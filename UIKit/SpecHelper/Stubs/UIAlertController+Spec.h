#import <UIKit/UIKit.h>

#ifdef __IPHONE_8_0
@interface UIAlertController (Spec)

- (void)dismissByTappingCancelButton;
- (void)dismissByTappingButtonWithTitle:(NSString *)title;

@end
#endif
