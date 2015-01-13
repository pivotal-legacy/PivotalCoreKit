#import <WatchKit/WatchKit.h>


@interface NotificationController : WKUserNotificationInterfaceController

@property (weak, nonatomic, readonly) WKInterfaceLabel *alertLabel;

@end
