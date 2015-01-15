#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
@interface UIAlertController (Spec)

- (void)dismissByTappingCancelButton;
- (void)dismissByTappingButtonWithTitle:(NSString *)title;

@end
#endif
