#import <UIKit/UIKit.h>

typedef void (^PCKAlertActionHandler)(UIAlertAction *action);

@interface UIAlertAction (Spec)

- (PCKAlertActionHandler)handler;

@end
