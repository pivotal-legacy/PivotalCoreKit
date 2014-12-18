#import <UIKit/UIKit.h>

#ifdef __IPHONE_8_0
typedef void (^PCKAlertActionHandler)(UIAlertAction *action);

@interface UIAlertAction (Spec)

- (PCKAlertActionHandler)handler;

@end
#endif
