#import "WKInterfaceController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKUserNotificationInterfaceController (Spec)

@property (nonatomic, readonly, nullable) void(^lastCompletionBlock)(WKUserNotificationInterfaceType);

@end

NS_ASSUME_NONNULL_END
