#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface CustomCategoryNotificationController : WKUserNotificationInterfaceController

@property (weak, nonatomic, readonly) WKInterfaceLabel *alertLabel;

@end
