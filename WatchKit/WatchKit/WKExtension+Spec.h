#import "WKExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKExtension (Spec)

+ (void)setSharedExtension:(WKExtension *)sharedExtension;

- (void)setRootInterfaceController:(nullable WKInterfaceController *)rootInterfaceController;

@end

NS_ASSUME_NONNULL_END
