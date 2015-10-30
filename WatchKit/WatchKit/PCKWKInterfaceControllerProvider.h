#import <Foundation/Foundation.h>


@class WKInterfaceController;

NS_ASSUME_NONNULL_BEGIN

@interface PCKWKInterfaceControllerProvider : NSObject

- (WKInterfaceController *)interfaceControllerWithProperties:(NSDictionary *)controllerProperties;

@end

NS_ASSUME_NONNULL_END
