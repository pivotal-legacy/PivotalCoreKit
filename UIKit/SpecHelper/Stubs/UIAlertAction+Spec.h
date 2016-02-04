#import <UIKit/UIKit.h>

typedef void (^PCKAlertActionHandler)(UIAlertAction *action);

@interface UIAlertAction (Spec)

@property (nonatomic, readonly) PCKAlertActionHandler handler;

@end
