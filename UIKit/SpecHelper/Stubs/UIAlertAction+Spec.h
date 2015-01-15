#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
typedef void (^PCKAlertActionHandler)(UIAlertAction *action);

@interface UIAlertAction (Spec)

- (PCKAlertActionHandler)handler;

@end
#endif
