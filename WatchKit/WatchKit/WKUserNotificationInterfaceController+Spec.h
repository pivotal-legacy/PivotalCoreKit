#import "WKInterfaceController.h"

@interface WKUserNotificationInterfaceController (Spec)

@property (nonatomic, readonly) void(^lastCompletionBlock)(WKUserNotificationInterfaceType);

@end