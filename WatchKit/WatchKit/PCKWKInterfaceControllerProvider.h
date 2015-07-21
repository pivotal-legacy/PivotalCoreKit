#import <Foundation/Foundation.h>


@class WKInterfaceController;


@interface PCKWKInterfaceControllerProvider : NSObject

- (WKInterfaceController *)interfaceControllerWithProperties:(NSDictionary *)controllerProperties;

@end
